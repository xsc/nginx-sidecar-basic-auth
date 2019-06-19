# nginx-sidecar-basic-auth

[![](https://images.microbadger.com/badges/version/xscys/nginx-sidecar-basic-auth.svg)](https://hub.docker.com/r/xscys/nginx-sidecar-basic-auth)
[![](https://images.microbadger.com/badges/image/xscys/nginx-sidecar-basic-auth.svg)](https://hub.docker.com/r/xscys/nginx-sidecar-basic-auth)

This is a Docker image that provides an [nginx][nginx] proxy server enforcing
HTTP basic authentication on every request (exception `OPTIONS`). It is suitable
for operation within [OpenShift][openshift], e.g. as a sidecar container.

[openshift]: https://openshift.com
[nginx]: https://www.nginx.com

## Configuration

Configuration is provided using environment variables:

| Environment              | Description                                                        | Default Value |
| ----------------------- -| ------------------------------------------------------------------ | ------------- |
| `PORT`                   | Port to listen on                                                  | `8087`        |
| `FORWARD_HOST`           | Hostname of the backend server to proxy to                         | `localhost`   |
| `FORWARD_PORT`           | Port of the backend server to proxy to                             | `8080`        |
| `BASIC_AUTH_USERNAME`    | Username to use for authentication                                 | `admin`       |
| `BASIC_AUTH_PASSWORD`    | Password to use for authentication                                 | `admin`       |
| `PROXY_READ_TIMEOUT`     | Defines a timeout for reading a response from the proxied server   | `60s`         |
| `PROXY_SEND_TIMEOUT`     | Sets a timeout for transmitting a request to the proxied server    | `60s`         |
| `CLIENT_MAX_BODY_SIZE`   | Sets the maximum allowed size of the client request body           | `1m`          |
| `PROXY_REQUEST_BUFFERING | Enables or disables buffering of a client request body             | `on`          |
| `PROXY_BUFFERING         | Enables or disables buffering of responses from the proxied server | `on`          |


## Usage

### Docker

Start the container and link it with your backend (alternatively, use Docker
networks):

```sh
docker run -d --name nginx-basic-auth -p 8087:8087 \
  --link backend:backend \
  -e FORWARD_HOST=backend \
  -e FORWARD_PORT=3000 \
  xscys/nginx-sidecar-basic-auth
```

### OpenShift Sidecar Usage

Add the sidecar container next to your application container in your deployment
configuration:

```yaml
- image: xscys/nginx-sidecar-basic-auth
  imagePullPolicy: Always
  name: auth-proxy
  ports:
    - containerPort: 8087
      protocol: TCP
  env:
    - name: FORWARD_PORT
      value: ${BACKEND_CONTAINER_PORT}
```

## License

```
MIT License

Copyright (c) 2019 Yannick Scherer

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
