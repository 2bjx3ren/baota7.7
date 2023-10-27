#!/bin/bash
# 一键安装部署邮件通知

yum install -y openssl openssl-devel
echo "openssl...完成"
sleep 2

yum install -y mailx
echo "mailx...完成"
sleep 2

mkdir -p /root/.certs/
cd $HOME
echo n | openssl s_client -connect smtp.qq.com:465 | sed -ne '/-BEGIN CERTIFICATE/,/END CERTIFICATE/p' > ~/.certs/qq.crt 
certutil -A -n "GeoTrust SSL CA" -t "C,," -d ~/.certs -i ~/.certs/qq.crt
certutil -A -n "GeoTrust Global CA" -t "C,," -d ~/.certs -i ~/.certs/qq.crt
certutil -L -d /root/.certs
echo "certs...完成"
sleep 2

echo "set from=965944680@qq.com
set smtp=smtps://smtp.qq.com:465
set smtp-auth-user=965944680
set smtp-auth-password=
set smtp-auth=login
set ssl-verify=ignore
set nss-config-dir=/root/.certs" >> /etc/mail.rc
echo "mail...完成"
sleep 1

exit 0