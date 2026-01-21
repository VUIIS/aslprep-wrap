#!/usr/bin/env python

import argparse
import json

parser = argparse.ArgumentParser()
parser.add_argument('--jsonfile', required=True)
parser.add_argument('tag')
parser.add_argument('value')
args = parser.parse_args()

with open(args.jsonfile) as f:
    jobj = json.loads(f.read())

jobj[args.tag] = args.value

with open(args.jsonfile, 'w') as f:
    json.dump(jobj, f, indent=4)
