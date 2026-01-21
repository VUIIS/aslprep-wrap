#!/usr/bin/env python

import argparse
import json

parser = argparse.ArgumentParser()
parser.add_argument('--img_niigz', required=True)
parser.add_argument('--intendedfor', required=True)
args = parser.parse_args()

# Get json
jsonfile = args.img_niigz.replace('.nii.gz','.json')
with open(jsonfile) as f:
    jobj = json.loads(f.read())

if 'IntendedFor' in jobj:
    intended = jobj['IntendedFor']
else:
    intended = []

intended.append(args.intendedfor)
jobj['IntendedFor'] = intended

with open(jsonfile, 'w') as f:
    json.dump(jobj, f, indent=4)
