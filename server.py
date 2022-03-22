#!/usr/bin/env python3

import wgconfig
from bottle import route, run, template

wc = wgconfig.WGConfig('./etc/wg0.conf')
wc.read_file()
print("interface:", wc.interface)

@route('/hello/<name>')
def index(name):
    return template('<b>Hello {{name}}</b>!', name=name)

run(host='localhost', port=8080)
