daemon off;

events {
    worker_connections 512;
}

error_log /dev/stderr warn;
pid       /tmp/nginx.pid;

http {
    include           /etc/nginx/mime.types;
    default_type      application/octet-stream;

    client_body_temp_path /tmp/nginx 1 2;
    proxy_temp_path       /tmp/nginx-proxy;
    fastcgi_temp_path     /tmp/nginx-fastcgi;
    uwsgi_temp_path       /tmp/nginx-uwsgi;
    scgi_temp_path        /tmp/nginx-scgi;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log        /dev/stdout main;
    sendfile          on;
    keepalive_timeout 65;

    include /etc/nginx/conf.d/*.conf;
}
