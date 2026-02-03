#!/usr/bin/env python

import argparse
import json
import nibabel
import numpy

parser = argparse.ArgumentParser()
parser.add_argument('--img_niigz', required=True)
parser.add_argument('--slice_encoding_direction', required=True)
parser.add_argument('--labeling_duration', required=True, type=float)
parser.add_argument('--post_labeling_delay', required=True, type=float)
args = parser.parse_args()

# Get json
jsonfile = args.img_niigz.replace('.nii.gz','.json')
with open(jsonfile) as f:
    jobj = json.loads(f.read())

# Get number of slices and TR from .nii.gz. Assume
# slice axis is the third one.
nii = nibabel.load(args.img_niigz)
nslices = nii.header['dim'][3]
tr = nii.header['pixdim'][4]

# Check for existing
if 'SliceTiming' in jobj:
    raise Exception(f'SliceTiming field exists in {jsonfile}')
if 'SliceEncodingDirection' in jobj:
    raise Exception(f'SliceEncodingDirection field exists in {jsonfile}')

# Get repetition time from .json to crosscheck
tr2 = jobj['RepetitionTime']
if abs(tr2-tr)>0.001:
    raise Exception(f'TR in {jsonfile} does not match {args.fmri_niigz}')

acqwindow_begin = args.labeling_duration + args.post_labeling_delay
acqwindow_end = tr
slice_delta = (acqwindow_end - acqwindow_begin) / nslices
basetimes = numpy.linspace(acqwindow_begin+slice_delta/2, acqwindow_end-slice_delta/2, num=nslices)

## Save it to original filename
with open(jsonfile, 'w') as f:
    json.dump(jobj, f, indent=4)

