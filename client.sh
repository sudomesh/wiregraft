#!/bin/sh

SERVER=https://localhost:8080/request
CONF=/etc/wireguard/wg0.conf      
PRIVKEY=/etc/wireguard/private.key
PUBKEY=/etc/wireguard/public.key
              
touch $PRIVKEY    
chmod 600 $PRIVKEY  
wg genkey > $PRIVKEY              
cat $PRIVKEY | wg pubkey > $PUBKEY
           
touch $CONF    
chmod 600 $CONF            
echo "[Interface]" >> $CONF                 
echo "PrivateKey = $(cat $PRIVKEY)" >> $CONF

RESPONSE=$(wget --quiet $SERVER -O -) 
