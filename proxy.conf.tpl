# Proxy
proxy_set_header Host $host;
proxy_set_header X-Real-IP $remote_addr;
proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
proxy_set_header X-Forwarded-Proto $http_x_forwarded_proto;
proxy_pass http://backend;
proxy_read_timeout {{ .Env.PROXY_READ_TIMEOUT }};
proxy_send_timeout {{ .Env.PROXY_SEND_TIMEOUT }};
client_max_body_size {{ .Env.CLIENT_MAX_BODY_SIZE }};
proxy_request_buffering {{ .Env.PROXY_REQUEST_BUFFERING }};
proxy_buffering {{ .Env.PROXY_BUFFERING }};
