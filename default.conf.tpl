# Upstream
upstream backend {
    server {{ .Env.FORWARD_HOST }}:{{ .Env.FORWARD_PORT }} max_fails=0;
}

# WS Handling
map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

# Server Definition
server {
    listen {{ .Env.PORT }};

{{ if .Env.WEBSOCKET_PATH }}
    location {{ .Env.WEBSOCKET_PATH }} {
        proxy_pass http://backend{{ .Env.FORWARD_WEBSOCKET_PATH | default "" }};
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $http_x_forwarded_proto;
        proxy_read_timeout {{ .Env.PROXY_READ_TIMEOUT }};
        proxy_send_timeout {{ .Env.PROXY_SEND_TIMEOUT }};
    }
{{ end }}

{{ if .Env.HEALTH_PATH }}
    location {{ .Env.HEALTH_PATH }} {
        auth_basic "off";
        include /etc/nginx/proxy.conf;
    }
{{ end }}

    location / {

        # Basic Auth
        limit_except OPTIONS {
            auth_basic "Restricted";
            auth_basic_user_file "auth.htpasswd";
        }
        include /etc/nginx/proxy.conf;
    }
}
