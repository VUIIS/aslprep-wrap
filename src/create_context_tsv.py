#!/usr/bin/env python

import argparse
import json
import nibabel
import pandas

parser = argparse.ArgumentParser()
parser.add_argument('--img_niigz', required=True)
parser.add_argument('--alternating', action='store_true', default=True)
parser.add_argument('--control_first', action='store_true', default=True)
parser.add_argument('--label_first', action='store_true')
args = parser.parse_args()

# Check args
if not args.alternating:
    raise Exception('Can only handle alternating label type')

if args.control_first and args.label_first:
    raise Exception('Specify only one of --control_first, --label_first')

if args.control_first:
    label0 = 'control'
    label1 = 'label'
elif args.label_first:
    label0 = 'label'
    label1 = 'control'
else:
    raise Exception('Need --control_first or --label_first')


# Get json
jsonfile = args.img_niigz.replace('.nii.gz','.json')
with open(jsonfile) as f:
    jobj = json.loads(f.read())

# Determine output filename
tsvfile = args.img_niigz.replace('_asl.nii.gz','_aslcontext.tsv')

# Get number of volumes from .nii.gz
nii = nibabel.load(args.img_niigz)
nvols = nii.header['dim'][4]

# Make label list
labels = [label0, label1] * int(nvols/2)
if len(labels) != nvols:
    raise Exception(f'Odd number of volumes present ({nvols})?')

labelframe = pandas.DataFrame(labels, columns=['volume_type'])

labelframe.to_csv(tsvfile, sep='\t', index=False)

