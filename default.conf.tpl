# Upstream
upstream backend {
    server {{ .Env.FORWARD_HOST }}:{{ .Env.FORWARD_PORT }} max_fails=0;
}
# Server Definition
server {
    listen {{ .Env.PORT }};

    location / {

        # Basic Auth
        limit_except OPTIONS {
            auth_basic "Restricted";
            auth_basic_user_file "auth.htpasswd";
        }

        # Proxy
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $http_x_forwarded_proto;
        proxy_pass http://backend;
        proxy_read_timeout 900;
    }
}
