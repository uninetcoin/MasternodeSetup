#!/bin/bash

echo -e "\n\nupdate & prepare system ...\n\n"
sudo apt-get update -y &&
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y &&
sudo DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y 

sudo apt-get install nano htop git -y


sudo apt-get install unzip -y
sudo apt-get install build-essential libtool autotools-dev automake pkg-config -y
sudo apt-get install libssl-dev libevent-dev bsdmainutils -y
sudo apt-get install libminiupnpc-dev -y
sudo apt-get install libzmq5-dev -y
sudo apt-get install libboost-all-dev -y

sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt-get update -y
sudo apt-get install libdb4.8-dev libdb4.8++-dev -y

echo -e "\n\nsetup unnd ...\n\n"

cd ~

version=`lsb_release -r | awk '{print $2}'`
echo "ubuntu version : "\n
echo $version

mkdir /root/unn
mkdir /root/.unn

cd /root/unn

wget https://github.com/uninetcoin/uninet-core/releases/download/v1.0/unn-cli
sleep 5
wget https://github.com/uninetcoin/uninet-core/releases/download/v1.0/unnd
sleep 5
chmod -R 755 ./*

sleep 5

chmod -R 755 /root/unn
chmod -R 755 /root/.unn

echo -e "\n\nlaunch unnd ...\n\n"
sudo apt-get install -y pwgen
GEN_PASS=`pwgen -1 20 -n`
IP_ADD=`curl ipinfo.io/ip`

echo -e "rpcuser=unnuser\nrpcpassword=${GEN_PASS}\nserver=1\nlisten=1\nmaxconnections=256\ndaemon=1\nrpcallowip=127.0.0.1\nexternalip=${IP_ADD}:47578\nstaking=1" > /root/.unn/unn.conf
cd /root/unn
./unnd
sleep 40
masternodekey=$(./unn-cli masternode genkey)
./unn-cli stop

# add launch after reboot
crontab -l > tempcron
echo "@reboot /root/unn/unnd -reindex >/dev/null 2>&1" >> tempcron
crontab tempcron
rm tempcron

echo -e "masternode=1\nmasternodeprivkey=$masternodekey\n\n\n" >> /root/.unn/unn.conf

echo -e "addnode=13.52.103.88" >> /root/.unn/unn.conf
echo -e "addnode=54.183.216.111" >> /root/.unn/unn.conf
echo -e "addnode=54.215.247.214" >> /root/.unn/unn.conf
echo -e "addnode=54.67.71.155" >> /root/.unn/unn.conf
echo -e "addnode=54.215.250.119" >> /root/.unn/unn.conf
echo -e "addnode=54.153.107.56" >> /root/.unn/unn.conf
echo -e "addnode=54.215.238.65" >> /root/.unn/unn.conf
echo -e "addnode=13.57.208.182" >> /root/.unn/unn.conf
echo -e "addnode=54.183.182.147" >> /root/.unn/unn.conf
echo -e "addnode=18.144.25.62" >> /root/.unn/unn.conf

sleep 10

./unnd -reindex
cd /root/.unn
ufw allow 47578

# output masternode key
echo -e "${IP_ADD}:47578"
echo -e "Masternode private key: $masternodekey"
echo -e "Welcome to the UNN Masternode Network!"
