#!/bin/bash 
#Sistem requirement configure
yum install epel-release -y
yum update -y
yum install -y iptraf htop ngrep pcapy wget git net-tools ntp gcc
systemctl enable ntpd

#NTP server configuration
ntpdate -u 0.centos.pool.ntp.org

#SELinux disabled
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

#Firewall stopping
systemctl disable firewalld
systemctl stop firewalld

#Java installation
yum install java-1.8.0-openjdk.x86_64 -y 

#ELK GPG-KEY importing
rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch

#ELK creating repo
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
enabled=1" > /etc/yum.repos.d/kibana.repo


echo "[logstash-2.3]
name=Logstash repository for 2.3.x packages
baseurl=https://packages.elastic.co/logstash/2.3/centos
gpgcheck=1
gpgkey=https://packages.elastic.co/GPG-KEY-elasticsearch
enabled=1" > /etc/yum.repos.d/logstash.repo

#ELK installing
yum install elasticsearch.noarch logstash.noarch kibana.x86_64 -y 

#ELK services enabled and starting
systemctl enable elasticsearch.service
systemctl enable logstash.service
systemctl enable kibana.service
systemctl start elasticsearch.service
systemctl start logstash.service
systemctl start kibana.service

#Elasticsearch sysconfig configuration
echo "ES_HEAP_SIZE=1g
ES_STARTUP_SLEEP_TIME=5" >> /etc/sysconfig/elasticsearch

#Logstash sysconfig configuration
echo "LS_USER=root
LS_GROUP=root" >> /etc/sysconfig/logstash

##test
