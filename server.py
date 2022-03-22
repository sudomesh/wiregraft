#!/usr/bin/env python3

import wgconfig
from bottle import route, run, template

wc = wgconfig.WGConfig('./example.conf')
wc.read_file()
privkey = wc.interface['PrivateKey']

print("Priv:", privkey)

@route('/hello/<name>')
def index(name):
    return template('<b>Hello {{name}}</b>!', name=name)

run(host='localhost', port=8080)
