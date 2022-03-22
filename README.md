
Work in progress. Come back later.

This is the idea: Client shell script on OpenWRT generates pub/priv key, then makes HTTPS request to Python web server with its pubkey and asks for wireguard access. Server modifies its wireguard config adding client access and responds with unique IP and its own public key. Client finalizes its own config file and connects over wireguard.


# client

```
opkg install wireguard-tools
```

# server

`python3 server.py`

```
pip3 install bottle
pip3 install wgconfig
```
