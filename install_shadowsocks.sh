#! /usr/bin/env bash
# Operating System: Centos 7 x86_64
cd
yum -y update
yum -y install gcc
yum -y install openssl-devel
yum -y install wget

wget http://python.org/ftp/python/2.7.3/Python-2.7.3.tar.bz2
tar -jxvf Python-2.7.3.tar.bz2 
cd Python-2.7.3  
./configure
make all
make install 
mv /usr/bin/python /usr/bin/python2.6.6
ln -s /usr/local/bin/python2.7 /usr/bin/python 
sed -i '1s/python/python2.6.6/' /usr/bin/yum
sed -i '1s/python/python2.6.6/' /usr/libexec/urlgrabber-ext-down

cd
yum -y install python-setuptools
wget https://bootstrap.pypa.io/ez_setup.py -O - | python
easy_install pip
pip install distribute

pip install shadowsocks

IP_ADDR=`ip addr | tail -1 | awk '{print $4}'`

cat > /etc/shadowsocks.json << EOF
{
    "server":"$IP_ADDR",
    "port_password":{
         "8888":"shadowsocks",
         "9999":"shadowsocks"
         },
    "timeout":300,
    "method":"aes-256-cfb",
    "fast_open":false,
    "workers":1
}
EOF

cat >> /etc/rc.local << EOF
ssserver -c /etc/shadowsocks.json -d start
EOF

ssserver -c /etc/shadowsocks.json -d start
if [ $? -eq 0 ]
then
    echo "shadowsocks已启动..."
else
    echo "shadowsocks启动异常..."
fi

echo "
    =========================[ shadowsocks command ]==========================
    |  启动shadowsocks服务: ssserver -c /etc/shadowsocks.json -d start        |
    |  关闭shadowsocks服务: ssserver -c /etc/shadowsocks.json -d stop         |
    |  重启shadowsocks服务: ssserver -c /etc/shadowsocks.json -d restart      |
    ==========================================================================

    =========================[    win_turn 提醒您   ]==========================
    |  ip地址:   $IP_ADDR                                                     |
    |  端 口1:   8888                                                         |
    |  密 码1:   shadowsocks                                                  |
    |  端 口2:   9999                                                         |
    |  密 码2:   shadowsocks                                                  |
    ==========================================================================
"
