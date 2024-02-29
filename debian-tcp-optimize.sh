#!/bin/bash

# 打开文件描述符限制 将硬限制和软限制都设置为65535，以允许更多的文件描述符
echo "* hard nofile 65535" >> /etc/security/limits.conf 
echo "* soft nofile 65535" >> /etc/security/limits.conf

# 调整内核参数 通过 here 文档（heredoc）向 /etc/sysctl.conf 文件中添加内核参数
cat << EOF >> /etc/sysctl.conf

fs.file-max = 1000000
fs.inotify.max_user_instances = 8192
net.core.somaxconn = 65535
net.core.netdev_max_backlog = 65535
net.core.rmem_max = 16777216 
net.core.wmem_max = 16777216
net.core.wmem_default = 2097152
net.ipv4.ip_forward = 1
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.tcp_max_syn_backlog = 65535
net.ipv4.tcp_max_tw_buckets = 65535
net.ipv4.tcp_rmem = 16384 32768 262144
net.ipv4.tcp_wmem = 16384 32768 262144
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_fin_timeout = 10
net.ipv4.tcp_slow_start_after_idle = 0
net.ipv4.tcp_keepalive_time = 300 
net.ipv4.tcp_keepalive_probes = 5 
net.ipv4.tcp_keepalive_intvl = 15
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_window_scaling = 1
net.ipv6.conf.all.autoconf = 0
net.ipv6.conf.default.autoconf = 0
net.ipv6.conf.all.accept_ra = 0
net.ipv6.conf.default.accept_ra = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0

EOF

# 应用新的内核参数 使用 sysctl 命令重新加载 /etc/sysctl.conf 文件中的配置
sysctl -p

kernel_version=$(uname -r)
echo "当前内核版本为: $kernel_version"

# 检查是否已经安装了 BBR 模块
if lsmod | grep -q "^tcp_bbr "; then
    echo "BBR 模块已安装"
else
    # 安装 BBR 模块
    echo "安装 BBR 模块..."
    sudo modprobe tcp_bbr
    echo "tcp_bbr" | sudo tee -a /etc/modules-load.d/modules.conf
    echo "net.core.default_qdisc=fq" | sudo tee -a /etc/sysctl.conf
    echo "net.ipv4.tcp_congestion_control=bbr" | sudo tee -a /etc/sysctl.conf
    sudo sysctl -p
fi

# 验证 BBR 是否已启用
if sysctl net.ipv4.tcp_congestion_control | grep -q "bbr"; then
    echo "BBR 已启用"
else
    echo "BBR 启用失败，请手动检查您的系统设置"
fi

echo "系统优化设置完成。"