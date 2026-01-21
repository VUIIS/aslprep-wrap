#!/usr/bin/env python

import argparse
import json
import nibabel
import shutil

parser = argparse.ArgumentParser()
parser.add_argument('--img_niigz')
parser.add_argument('--slicetiming')
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

if args.slicetiming in ['Philips_ASCEND_k']:
    basetimes = [x / nslices * tr for x in range(0,nslices)]
    jobj['SliceEncodingDirection'] = 'k'
    jobj['SliceTiming'] = basetimes
else:
    raise Exception(f'Cannot handle slice timing of {args.slicetiming}')

## Save it to original filename
with open(jsonfile, 'w') as f:
    json.dump(jobj, f, indent=4)

