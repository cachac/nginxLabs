# HTTP2
- Hyper Text Transfer Protocol
- Comunication between client (browser) and server: Request & Response
- 1.0 = 1996
- 1.1 = 1997
- 2.0 = 2015
- features:
  - multi request/connection
  - chunks = sequence of independent streams (HTTP payload)
  - server push = server response without request (<1.25%)
  - 1.1 use plain text commands, 2.0 use binary commands
  - header compression
  - performance: web, mobile
  - less bandwidth

> [Removing HTTP/2 Server Push from Chrome](https://developer.chrome.com/blog/removing-push/)

> [cable map](https://www.submarinecablemap.com/)

```
# --with-http_v2_module
nginx -V

server {
  listen 82 http2;

```
