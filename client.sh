#!/bin/sh

SERVER_URL="https://localhost:8080/request"
WIREGUARD_CONFIG_DIR=./conf # for testing
#WIREGUARD_CONFIG_DIR=./etc
CONF=${WIREGUARD_CONFIG_DIR}/wg0.conf      
PRIVKEY_FILE=${WIREGUARD_CONFIG_DIR}/private.key
PUBKEY_FILE=${WIREGUARD_CONFIG_DIR}/public.key

mkdir -p $WIREGUARD_CONFIG_DIR

# TODO check if files already exist

touch $PRIVKEY_FILE
chmod 600 $PRIVKEY_FILE  
wg genkey > $PRIVKEY_FILE              
PUBKEY=$(cat $PRIVKEY_FILE | wg pubkey)
echo $PUBKEY > $PUBKEY_FILE

touch $CONF    
chmod 600 $CONF            
echo "[Interface]" > $CONF                 
echo "PrivateKey = $PRIVKEY" >> $CONF

RESPONSE=$(wget --quiet ${SERVER_URL}/${PUBKEY} -O -) 
