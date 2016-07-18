#!/bin/bash

yum install nginx.x86_64 -y
yum install httpd-tools.x86_64 -

systemctl start nginx.service
systemctl enable nginx.service

mkdir /etc/nginx/ssl

#SSL Bilgileri Girilir.
openssl req -x509 -nodes -days 10365 -newkey rsa:2048 -keyout /etc/nginx/ssl/kibana.key -out /etc/nginx/ssl/kibana.crt


echo '#
# HTTPS server configuration
#

server {
    listen       443 default_server;
    server_name  _;

    ssl                  on;
    ssl_certificate      /etc/nginx/ssl/kibana.crt;
    ssl_certificate_key  /etc/nginx/ssl/kibana.key;

    ssl_session_timeout  5m;

    ssl_protocols  TLSv1;
    ssl_ciphers  ALL:!ADH:!EXPORT56:RC4+RSA:+HIGH:+MEDIUM:+LOW:+SSLv2:+EXP;
    ssl_prefer_server_ciphers   on;

    location / {
        proxy_pass http://localhost:5601/;
        proxy_redirect http://host:5601/ /;
        root   html;
        index  index.html index.htm;
        auth_basic "Restricted";
        auth_basic_user_file /etc/nginx/conf.d/kibana.htpasswd;
    }
}' > /etc/nginx/conf.d/ssl.conf

htpasswd -c /etc/nginx/conf.d/kibana.htpasswd idsadmin

systemctl restart nginx.service

echo 'server.host: "127.0.0.1"' >> /opt/kibana/config/kibana.yml

systemctl restart kibana.service
