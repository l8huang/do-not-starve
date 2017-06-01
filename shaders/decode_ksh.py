#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import os
import struct
import io
import json
import six
import binascii


def decode_header(fp):
    offset = 0
    header = {}

    content = fp.read()
    buffer = io.BytesIO(content)

    length = struct.unpack_from("I", content, offset=offset)[0]
    offset += 4
    fp.seek(offset)
    header['name'] = fp.read(length).decode("utf-8") 
    offset += length

    nvar = struct.unpack_from("I", content, offset=offset)[0]
    offset += 4
    header['vars'] = {}
    for i in range(nvar):
        l = struct.unpack_from("I", content, offset=offset)[0]
        offset += 4
        fp.seek(offset)

        name = fp.read(l).decode("utf-8") 
        offset += l
        header['vars'][name] = {}

        unk = struct.unpack_from("3I", content, offset=offset)
        offset += struct.calcsize("3I")
        header['vars'][name]['unk'] = unk
        if unk[1] == 43:
            header['vars'][name]['values'] = []
            continue

        nvar = struct.unpack_from("I", content, offset=offset)
        offset += 4

        fmt = "%dI" % nvar
        values = struct.unpack_from(fmt, content, offset=offset)
        offset += struct.calcsize(fmt)
        header['vars'][name]['values'] = values

    #print(header)
    return header, offset


def decode_shaders(fp, offset):
    fp.seek(offset)
    shaders = {}

    l = struct.unpack_from("I", fp.read(4))[0]
    offset += 4
    name = fp.read(l).decode("utf-8") 
    offset += l
    l = struct.unpack_from("I", fp.read(4))[0]
    offset += 4
    shader = fp.read(l).decode("utf-8").rstrip('\0')

    offset += l
    shaders[name] = shader

    l = struct.unpack_from("I", fp.read(4))[0]
    offset += 4
    name = fp.read(l).decode("utf-8") 
    offset += l
    l = struct.unpack_from("I", fp.read(4))[0]
    offset += 4
    shader = fp.read(l).decode("utf-8").rstrip('\0')
    offset += l
    shaders[name] = shader

    return shaders

def format_header(header):
    rslt = []
    rslt.append("name: %s" % header['name'])
    for k,v in six.iteritems(header['vars']):
        rslt.append("%s: %s : %s" % (k, v['unk'], v['values']))
    
    rslt = ["// %s\n" % i for i in rslt]
    rslt = "".join(rslt)
    return rslt

def decode_ksh(fp):
    header, offset = decode_header(fp)
    shaders = decode_shaders(fp, offset)
    rslt = ""
    rslt += format_header(header)

    for k,v in six.iteritems(shaders):
        rslt += "\n/* %s */\n" % k
        rslt += v

    return rslt


if __name__ == "__main__":
    f = sys.argv[1]
    print("decode %s" % f)
    with open(f, 'rb') as file:
        rslt = decode_ksh(file)
    f += ".txt"
    with open(f, "wb") as file:
        file.write(rslt.encode())






