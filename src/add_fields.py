#!/usr/bin/env python

import argparse
import json

parser = argparse.ArgumentParser()
parser.add_argument('--jsonfile', required=True)
parser.add_argument('--M0Type')
parser.add_argument('--RepetitionTimePreparation')
parser.add_argument('--PostLabelingDelay')
parser.add_argument('--ArterialSpinLabelingType')
parser.add_argument('--LabelingDuration')
parser.add_argument('--BackgroundSuppression')
parser.add_argument('--BackgroundSuppressionNumberPulses')
parser.add_argument('--TotalAcquiredPairs')
parser.add_argument('--LabelingDistance')
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

if args.LabelingDuration:
    jobj['LabelingDuration'] = float(args.LabelingDuration)

if args.BackgroundSuppression:
    jobj['BackgroundSuppression'] = args.BackgroundSuppression

if args.BackgroundSuppressionNumberPulses:
    jobj['BackgroundSuppressionNumberPulses'] = int(args.BackgroundSuppressionNumberPulses)

if args.TotalAcquiredPairs:
    jobj['TotalAcquiredPairs'] = int(args.TotalAcquiredPairs)

if args.LabelingDistance:
    jobj['LabelingDistance'] = float(args.LabelingDistance)

with open(args.jsonfile, 'w') as f:
    json.dump(jobj, f, indent=4)
