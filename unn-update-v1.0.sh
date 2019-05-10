#!/bin/bash

echo -e "\n\nupdate unnd ...\n\n"
cd /root/unn
./unn-cli stop
sleep 10

rm /root/unn/unnd
rm /root/unn/unn-cli

sleep 1 

wget https://github.com/uninetcoin/uninet-core/releases/download/v1.0/unn-cli
wget https://github.com/uninetcoin/uninet-core/releases/download/v1.0/unnd

chmod -R 755 /root/unn/*

echo -e "\n\nlaunch unnd ...\n\n"
./unnd -reindex

echo "UNN Daemon Updated"
