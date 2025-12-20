#!/bin/bash

# Initialize defaults
export out_dir=/OUTPUTS

# Parse options
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
    --asl_dcm)
        export asl_dcm="$2"; shift; shift;;
    --m0_dcm)
        export m0_dcm="$2"; shift; shift;;
    --examcard_dcm)
        export examcard_dcm="$2"; shift; shift;;
    --out_dir)
        export out_dir="$2"; shift; shift;;
    --sliceorder)
        export sliceorder="$2"; shift; shift;;
    --asl_type)
        export asl_type="$2"; shift; shift;;
    --post_labeling_delay)
        export post_labeling_delay="$2"; shift; shift;;
    --bkgnd_suppression)
        export bkgnd_suppression="$2"; shift; shift;;
    *)
        echo Unknown input "$1"; shift ;;
    esac
done

# Assumptions for json
# M0Type: Separate
# TotalAcquiredPairs: Calculate from nifti


# Convert images to nifti
dcm2niix -o /OUTPUTS -f asl "${asl_dcm}"
dcm2niix -o /OUTPUTS -f m0 "${m0_dcm}"

# Make aslcontext.tsv with label info for asl.nii.gz
