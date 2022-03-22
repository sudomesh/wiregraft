#!/usr/bin/busybox sh
#!/bin/sh

SERVER_URL="http://localhost:8080/request"
WIREGUARD_ENDPOINT="example.com:49992"

CLIENT_ALLOWEDIPS="172.25.0.0/24" # TODO should come from server
KEEPALIVE="10" # TODO should come from server

WIREGUARD_CONFIG_DIR=./conf # for testing
#WIREGUARD_CONFIG_DIR=./etc

CONF=${WIREGUARD_CONFIG_DIR}/wg0.conf      
PRIVKEY_FILE=${WIREGUARD_CONFIG_DIR}/private.key
PUBKEY_FILE=${WIREGUARD_CONFIG_DIR}/public.key

###################################################

mkdir -p $WIREGUARD_CONFIG_DIR

# TODO check if files already exist

touch $PRIVKEY_FILE
chmod 600 $PRIVKEY_FILE  
PRIVKEY=$(wg genkey)
echo $PRIVKEY > $PRIVKEY_FILE              
PUBKEY=$(cat $PRIVKEY_FILE | wg pubkey)
echo $PUBKEY > $PUBKEY_FILE

touch $CONF    
chmod 600 $CONF            
echo "[Interface]" > $CONF                 
echo "PrivateKey = $PRIVKEY" >> $CONF
echo " " >> $CONF

RESPONSE=$(curl --silent --data-urlencode key=${PUBKEY} ${SERVER_URL}) 
echo "Got response: $RESPONSE"
LEN=${#RESPONSE}
i=3

ASSIGNED_IP=""
SERVER_PUBKEY=""
while [ "$i" -lt "$LEN" ]; do
    if [ ${RESPONSE:$i:1} == "|" ]; then
        ASSIGNED_IP=${RESPONSE:0:$i}
        SERVER_PUBKEY=${RESPONSE:$i+1:-1}
        break
    fi
    i=$((i+1))
done

echo "[Peer]" >> $CONF
echo "Endpoint = $WIREGUARD_ENDPOINT" >> $CONF
echo "AllowedIPs = $CLIENT_ALLOWEDIPS" >> $CONF
echo "PublicKey = $SERVER_PUBKEY" >> $CONF
echo "PersistenKeepalive = $KEEPALIVE" >> $CONF
