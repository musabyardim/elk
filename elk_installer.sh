#!/bin/bash 
#Sistem gereksinimleri yükleniyor
yum install epel-release -y
yum update -y
yum install -y iptraf htop atop ngrep pcapy wget git net-tools ntp gcc bind-utils
systemctl enable ntpd

#NTP sunucusu ayarlanıyor
ntpdate -u 0.centos.pool.ntp.org

#SELinux kapatılıyor
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

#Firewall durduruluyor
systemctl disable firewalld
systemctl stop firewalld

#Java yükleniyor
yum install java-1.8.0-openjdk.x86_64 -y 

#ELK GPG-KEY import ediliyor
rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch

#ELK repoları oluşturuluyor
echo "[elasticsearch-2.x]
name=Elasticsearch repository for 2.x packages
baseurl=https://packages.elastic.co/elasticsearch/2.x/centos
gpgcheck=1
gpgkey=https://packages.elastic.co/GPG-KEY-elasticsearch
enabled=1" > /etc/yum.repos.d/elasticsearch.repo

echo "[kibana-4.5]
name=Kibana repository for 4.5.x packages
baseurl=http://packages.elastic.co/kibana/4.5/centos
gpgcheck=1
gpgkey=http://packages.elastic.co/GPG-KEY-elasticsearch
enabled=1" > vi /etc/yum.repos.d/kibana.repo


echo "[logstash-2.3]
name=Logstash repository for 2.3.x packages
baseurl=https://packages.elastic.co/logstash/2.3/centos
gpgcheck=1
gpgkey=https://packages.elastic.co/GPG-KEY-elasticsearch
enabled=1" > /etc/yum.repos.d/logstash.repo

#ELK kuruluyor
yum install elasticsearch.noarch logstash.noarch kibana.x86_64 -y 

#ELK servisleri yapılandırılıyor/çalıştırılıyor.
systemctl enable elasticsearch.service
systemctl enable logstash.service
systemctl enable kibana.service
systemctl start elasticsearch.service
systemctl start logstash.service
systemctl start kibana.service

echo "cluster.name: my-cluster
node.name: node-1" > /etc/elasticsearch/elasticsearch.yml

