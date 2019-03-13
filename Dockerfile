FROM nginx:alpine
MAINTAINER "Yannick Scherer <yannick.scherer@gmail.com>"

# --------------------
# METADATA
# --------------------
EXPOSE 8087
ENV NGINX_VERSION=1.12.2 \
    DOCKERIZE_VERSION=v0.6.1 \
    PORT=8087 \
    FORWARD_HOST=localhost \
    FORWARD_PORT=8080 \
    BASIC_AUTH_USERNAME=admin \
    BASIC_AUTH_PASSWORD=admin

# --------------------
# DEPENDENCIES
# --------------------
RUN wget -O dockerize.tar.gz https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
  && tar -C /usr/local/bin -xzvf dockerize.tar.gz \
  && apk add --update --no-cache --virtual entrypoint apache2-utils \
  && rm dockerize.tar.gz /etc/nginx/conf.d/default.conf /etc/nginx/nginx.conf \
  && mkdir /templates \
  && chmod g+rw /etc/nginx /etc/nginx/conf.d /templates

# --------------------
# TEMPLATES
# --------------------
COPY default.conf.tpl nginx.conf.tpl /templates/

# --------------------
# FILL TEMPLATES & GO
# --------------------
CMD htpasswd -Bbn "$BASIC_AUTH_USERNAME" "$BASIC_AUTH_PASSWORD" > /etc/nginx/auth.htpasswd && \
    dockerize \
      -template /templates/default.conf.tpl:/etc/nginx/conf.d/default.conf \
      -template /templates/nginx.conf.tpl:/etc/nginx/nginx.conf \
      nginx
