#!/usr/bin/env python

import argparse
import json

parser = argparse.ArgumentParser()
parser.add_argument('--jsonfile', required=True)
parser.add_argument('--M0Type')
parser.add_argument('--RepetitionTimePreparation')
parser.add_argument('--PostLabelingDelay')
parser.add_argument('--ArterialSpinLabelingType')
args = parser.parse_args()

with open(args.jsonfile) as f:
    jobj = json.loads(f.read())

if args.M0Type:
    jobj['M0Type'] = args.M0Type

if args.RepetitionTimePreparation:
    jobj['RepetitionTimePreparation'] = float(args.RepetitionTimePreparation)

if args.PostLabelingDelay:
    jobj['PostLabelingDelay'] = float(args.PostLabelingDelay)

if args.ArterialSpinLabelingType:
    jobj['ArterialSpinLabelingType'] = args.ArterialSpinLabelingType

with open(args.jsonfile, 'w') as f:
    json.dump(jobj, f, indent=4)
