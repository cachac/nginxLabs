# monitoring <!-- omit in toc -->

> [stub status](https://nginx.org/en/docs/http/ngx_http_stub_status_module.html)
> [steps and info](https://antonputra.com/monitoring/monitor-nginx-with-prometheus/#expose-basic-nginx-metrics)


# 1. Check stub
```
nginx -V 2>&1 | grep --color -- --with-http_stub_status_module
```

## 1.1. Config
```
vim /etc/nginx/conf.d/status.conf
```

```sh
server {
    listen 8080;
    # Optionally: allow access only from localhost
    # listen 127.0.0.1:8080;

    server_name _;

    location /status {
        stub_status;
    }
}

```

sudo systemctl reload nginx


check <IP>:8080/status


# 2. Nginx exporter
- version 0.11.0

```
sudo -i
sh assets/install_nginx_exporter.sh
systemctl status nginx-exporter

journalctl -u nginx-exporter -f --no-pager
# NGINX Prometheus Exporter has successfully started

curl localhost:9113/metrics
```

# 3. Prometheus
```
sh assets/install_prometheus.sh

systemctl status prometheus

# check
http://<ip>:9090

# check targets
# check query
install_nginx_exporter.sh
```

# 4. Grafana
```
sh assets/install_grafana.sh

systemctl status grafana-server

# check admin/admin
http://<ip>:3000
```
## 4.1. datasource
- datasource: http://localhost:9090

## 4.2. testing dashboard
- name: nginx-test
- query: nginx_connections_active
- tile: active connections
- legend: {{ instance }}

## 4.3. dashboard from json
> [json](./assets/dashboard.json)

# 5. Logging
```
sh install_fluentd.sh
systemctl status fluentd
fluentd --
# 1.15

vim /etc/nginx/nginx.conf
```

```sh
    log_format custom '$remote_addr - $remote_user [$time_local] '
    '"$request" $status $body_bytes_sent '
    '"$http_referer" "$http_user_agent" '
    '$upstream_response_time';   # <-------------------------------------------------

    access_log /var/log/nginx/access.log custom; # <-------------------------------------------------
```

```
nginx -t
systemctl restart nginx

tail -f /var/log/nginx/access.log

curl http://localhost:24231/metrics

```

## 5.1. Optional. check regular expression
- regex101.com
```
^(?<remote>[^ ]*) (?<host>[^ ]*) (?<user>[^ ]*) \[(?<time>[^\]]*)\] \"(?<method>\w+)(?:\s+(?<path>[^\"]*?)(?:\s+\S*)?)?\" (?<status_code>[^ ]*) (?<size>[^ ]*)(?:\s"(?<referer>[^\"]*)") "(?<agent>[^\"]*)" (?<urt>[^ ]*)$
```
- log
```
127.0.0.1 - - [23/Apr/2023:20:13:32 +0000] "GET /status HTTP/1.1" 200 105 "-" "NGINX-Prometheus-Exporter/v0.11.0" -
```
