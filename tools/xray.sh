#!/bin/bash

set -e

# 安装依赖
apt-get update
apt-get install -y unzip
if [ ! -d "/tools" ]; then
    mkdir /tools
fi

# 下载和安装Xray
wget https://github.com/chaitin/xray/releases/download/1.9.11/xray_linux_amd64.zip -P /tools/
unzip /tools/xray_linux_amd64.zip -d /tools/
chmod +x /tools/xray_linux_amd64
cd /tools/
./xray_linux_amd64

# 创建配置文件
cat <<EOT > /tools/config.yaml
version: 4.0

parallel: 30

http:
  proxy: ""
  proxy_rule: []
  dial_timeout: 5
  read_timeout: 10
  max_conns_per_host: 50
  enable_http2: false
  fail_retries: 0
  max_redirect: 5
  max_resp_body_size: 2097152
  max_qps: 500
  allow_methods:
  - HEAD
  - GET
  - POST
  - PUT
  - PATCH
  - DELETE
  - OPTIONS
  - CONNECT
  - TRACE
  - MOVE
  - PROPFIND
  headers:
    User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.0) Gecko/20100101 Firefox/78.0

plugins:
  baseline:
    enabled: true
    detect_cors_header_config: true
    detect_server_error_page: true
    detect_phpinfo: true
    detect_system_path_leak: false
    detect_outdated_ssl_version: false
    detect_http_header_config: false
    detect_cookie_httponly: false
    detect_china_id_card_number: false
    detect_china_phone_number: false
    detect_china_bank_card: false
    detect_private_ip: false
  brute-force:
    enabled: true
    username_dictionary: ""
    password_dictionary: ""
  cmd-injection:
    enabled: true
  crlf-injection:
    enabled: true
  dirscan:
    enabled: true
    depth: 1
    dictionary: ""
    exclude_dir: []
  fastjson:
    enabled: true
  jsonp:
    enabled: true
  path-traversal:
    enabled: true
  phantasm:
    enabled: true
    depth: 1
    auto_load_poc: false
    exclude_poc: []
    include_poc: []
    poc_tags:
      poc-yaml-test: ["HW", "ST"]
      poc-yaml-test-1: ["ST"]
  redirect:
    enabled: true
  shiro:
    enabled: true
    cookie_name: rememberMe
    aes_key: []
    aes_key_file: ""
  sqldet:
    enabled: true
    boolean_based_detection: true
    error_based_detection: true
    time_based_detection: true
    use_comment_in_payload: false
    detect_sqli_in_cookie: true
  ssrf:
    enabled: true
  struts:
    enabled: true
  thinkphp:
    enabled: true
    detect_thinkphp_sqli: true
  upload:
    enabled: true
  xss:
    enabled: true
    detect_xss_in_cookie: true
    ie_feature: false
  xxe:
    enabled: true
  xstream:
    enabled: true
    full: false

reverse:
  db_file_path: "reverse.db"
  token: "Aa123456"
  http:
    enabled: true
    listen_ip: 0.0.0.0
    listen_port: "9999"
    ip_header: ""
  dns:
    enabled: false
    listen_ip: 0.0.0.0
    domain: ""
    is_domain_name_server: false
    resolve:
    - type: A
      record: localhost
      value: 127.0.0.1
      ttl: 60
  client:
    remote_server: false
    http_base_url: ""
    dns_server_ip: ""

mitm:
  ca_cert: ./ca.crt
  ca_key: ./ca.key
  basic_auth:
    username: ""
    password: ""
  allow_ip_range: []
  restriction:
    hostname_allowed: []
    hostname_disallowed:
    - '*google*'
    - '*github*'
    - '*.gov.cn'
    - '*.edu.cn'
    - '*chaitin*'
    - '*.xray.cool'
    - '*wx*'
    - '*wx.qq.com'
  queue:
    max_length: 3000
  proxy_header:
    via: ""
    x_forwarded: false
  upstream_proxy: ""

basic-crawler:
  max_depth: 0
  max_count_of_links: 0
  allow_visit_parent_path: false
  restriction:
    hostname_allowed: []
    hostname_disallowed:
    - '*google*'
    - '*github*'
    - '*.gov.cn'
    - '*.edu.cn'
    - '*chaitin*'
    - '*.xray.cool'
    - '*wx*'
    - '*wx.qq.com'
  basic_auth:
    username: ""
    password: ""

subdomain:
  max_parallel: 500
  allow_recursion: false
  max_recursion_depth: 3
  web_only: false
  ip_only: false
  servers:
  - 8.8.8.8
  - 8.8.4.4
  - 223.5.5.5
  - 223.6.6.6
  - 114.114.114.114
  sources:
    brute:
      enabled: true
      main_dict: ""
      sub_dict: ""
    httpfinder:
      enabled: true
    dnsfinder:
      enabled: true
    certspotter:
      enabled: true
    crt:
      enabled: true
    hackertarget:
      enabled: true
    qianxun:
      enabled: true
    rapiddns:
      enabled: true
    sublist3r:
      enabled: true
    threatminer:
      enabled: true
    virusTotal:
      enabled: true
    alienvault:
      enabled: true
    bufferover:
      enabled: true
    fofa:
      enabled: false
      email: ""
      key: ""
    ip138:
      enabled: true
    myssl:
      enabled: true
    riskiq:
      enabled: false
      user: ""
      key: ""
    quake:
      enabled: false
      key: ""
    baidu:
      enabled: true
      page_limit: 12
    yahoo:
      enabled: true
      page_limit: 12
    sogou:
      enabled: true
      page_limit: 12
    google:
      enabled: true
      page_limit: 12
    bing:
      enabled: true
      page_limit: 12
    ask:
      enabled: true
      page_limit: 12
EOT

# 启动Xray
./xray_linux_amd64 reverse
