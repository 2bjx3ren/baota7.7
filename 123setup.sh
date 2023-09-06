#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

echo "创建虚拟内存目录"
swapoff -a
dd if=/dev/zero of=/var/swap bs=1M count=2048
sleep 5
echo "虚拟内存目录创建成功"

echo "开始配置虚拟内存"
mkswap /var/swap
swapon /var/swap
echo "/var/swap swap swap defaults 0 0" >> /etc/fstab
cat /etc/fstab
sleep 1
echo "虚拟内存配置成功"

echo "开始修改DNS"
echo "DNS1=1.1.1.1" >> /etc/sysconfig/network-scripts/ifcfg-eth0
echo "DNS2=8.8.8.8" >> /etc/sysconfig/network-scripts/ifcfg-eth0
cat /etc/sysconfig/network-scripts/ifcfg-eth0
service network restart
sleep 5
echo "DNS修改成功"

echo "开始安装Gost"
yum install wget -y
wget -N --no-check-certificate "https://raw.githubusercontent.com/KANIKIG/Multi-EasyGost/master/gost.sh"
chmod +x gost.sh
( sleep 1; echo 1; sleep 3; echo n ) | ./gost.sh
sleep 15
echo "Gost安装成功"

echo "配置Gost"
echo "socks/ntetv.com#ntetv#34567" >> /etc/gost/rawconf
( sleep 1; echo 6 ) | ./gost.sh
sleep 3
echo "Gost安装成功"

echo "开始安装Firewalld"
yum install firewalld -y
systemctl stop firewalld
systemctl start firewalld.service
firewall-cmd --permanent --add-port=57630/tcp
firewall-cmd --permanent --add-port=34567/tcp
firewall-cmd --reload
systemctl restart firewalld
firewall-cmd --list-all
sleep 1
echo "Firewalld配置成功"

echo "开始安装tcp.sh"
wget -N --no-check-certificate "http://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh"
chmod +x tcp.sh
( sleep 1; echo 2 ) | ./tcp.sh
