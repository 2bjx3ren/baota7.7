#!/bin/bash

( sleep 1; echo 7 ) | ./tcp.sh
( sleep 1; echo 10; sleep 3; echo n ) | ./tcp.sh
sleep 3
echo "bbr优化完成"

echo "开始安装bt面板"
wget -O install.sh https://raw.githubusercontent.com/2bjx3ren/baota7.7/main/install_6.0.sh
sleep 1
bash install.sh
sleep 10
echo "bt安装完成"

echo "开始优化bt面板"
wget -O optimize.sh https://raw.githubusercontent.com/2bjx3ren/baota7.7/main/optimize.sh
sleep 1
bash optimize.sh
