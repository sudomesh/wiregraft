#!/usr/bin/env python3

import subprocess
import wgconfig
from bottle import route, request, response, run, template

PORT=8080
CLIENT_SUBNET="24"

wc = wgconfig.WGConfig('./example.conf')
wc.read_file()
privkey = wc.interface['PrivateKey']
res = subprocess.run(["wg", "pubkey"], input=privkey, text=True, capture_output=True)
# TODO error check
pubkey = res.stdout

# TODO stub
def findNextClientIP():
    return "100.70.0.1"


def addClientToConfig(clientPubKey, clientRequestIP="unknown IP"):
    global CLIENT_SUBNET
    clientIP = findNextClientIP()

    wc.add_peer(clientPubKey, "# Added by " + clientRequestIP)
    wc.add_attr(clientPubKey, "AllowedIPs", clientIP + "/" + CLIENT_SUBNET)

    wc.write_file()

    return clientIP

@route('/request', method=['POST'])
def index():
    clientKey = request.params.key
    clientIP = addClientToConfig(clientKey, request.remote_addr)
    # TODO return text instead of HTML
    return template('{{clientIP}}|{{serverPubkey}}', clientIP=clientIP, serverPubkey=pubkey)


run(host='localhost', port=8080)
