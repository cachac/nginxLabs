#!/bin/bash


apt install -y build-essential ruby-dev
gem install fluentd --no-doc
gem install fluent-plugin-prometheus
mkdir /etc/fluent/

cat <<EOF > /etc/fluent/fluent.conf
<source>
    @type prometheus_tail_monitor
</source>

<source>
  @type prometheus
</source>

<source>
    @type tail
    <parse>
    @type regexp
    expression /^(?<remote>[^ ]*) (?<host>[^ ]*) (?<user>[^ ]*) \[(?<time>[^\]]*)\] \"(?<method>\w+)(?:\s+(?<path>[^\"]*?)(?:\s+\S*)?)?\" (?<status_code>[^ ]*) (?<size>[^ ]*)(?:\s"(?<referer>[^\"]*)") "(?<agent>[^\"]*)" (?<urt>[^ ]*)$/
        time_format %d/%b/%Y:%H:%M:%S %z
        keep_time_key true
        types size:integer,reqtime:float,uct:float,uht:float,urt:float
    </parse>
    tag nginx
    path /var/log/nginx/access.log
    pos_file /tmp/fluent_nginx.pos
</source>
<filter nginx>
    @type prometheus

  <metric>
    name nginx_size_bytes_total
    type counter
    desc nginx bytes sent
    key size
  </metric>

  <metric>
    name nginx_request_status_code_total
    type counter
    desc nginx request status code
    <labels>
      method ${method}
      path ${path}
      status_code ${status_code}
    </labels>
  </metric>

  <metric>
    name nginx_http_request_duration_seconds
    type histogram
    desc Histogram of the total time spent on receiving the response from the upstream server.
    key urt
    <labels>
      method ${method}
      path ${path}
      status_code ${status_code}
    </labels>
  </metric>

</filter>
EOF

cat <<EOF > /etc/systemd/system/fluentd.service
[Unit]
Description=Fluentd
Wants=network-online.target
After=network-online.target

StartLimitIntervalSec=0

[Service]
User=root
Group=root
Type=simple
Restart=on-failure
RestartSec=5s
ExecStart=fluentd --config /etc/fluent/fluent.conf

[Install]
WantedBy=multi-user.target
EOF

systemctl enable fluentd
systemctl start fluentd
