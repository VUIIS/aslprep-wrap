#!/usr/bin/env bash

# Nifti inputs
nii_dir=$(pwd)/../INPUTS
t1_niigz="${nii_dir}"/201_WIP_cs_2.8_T1W_3D_TFE.nii.gz
asl_niigz="${nii_dir}"/902_WIP_SOURCE_-_ASL_Wholebrain.nii.gz
m0_niigz="${nii_dir}"/1001_WIP_ASL_Wholebrain_M0.nii.gz

# Corresponding json files
t1_json="${t1_niigz%.nii.gz}.json"
asl_json="${asl_niigz%.nii.gz}.json"
m0_json="${m0_niigz%.nii.gz}.json"

# Test subject/session labels
sub=001
ses=001

# BIDS dir
bids_dir=$(pwd)/../OUTPUTS/aslBIDS
mkdir -p "${bids_dir}"

# ASL data dirs
ses_dir="${bids_dir}/sub-${sub}/ses-${ses}"
anat_dir="${ses_dir}/anat"
perf_dir="${ses_dir}/perf"
mkdir -p "${anat_dir}" "${perf_dir}"

# File org
fstr="sub-${sub}_ses-${ses}"
cp "${t1_niigz}" "${anat_dir}/${fstr}_T1w.nii.gz"
cp "${t1_json}" "${anat_dir}/${fstr}_T1w.json"
cp "${asl_niigz}" "${perf_dir}/${fstr}_asl.nii.gz"
cp "${asl_json}" "${perf_dir}/${fstr}_asl.json"
cp "${m0_niigz}" "${perf_dir}/${fstr}_m0scan.nii.gz"
cp "${m0_json}" "${perf_dir}/${fstr}_m0scan.json"

# Add slice timing to ASL, M0
add_slice_timing.py --img_niigz "${perf_dir}/${fstr}_asl.nii.gz" --slicetiming Philips_ASCEND_k
add_slice_timing.py --img_niigz "${perf_dir}/${fstr}_m0scan.nii.gz" --slicetiming Philips_ASCEND_k

# Add IntendedFor to M0
add_intendedfor.py \
    --img_niigz "${perf_dir}/${fstr}_m0scan.nii.gz" \
    --intendedfor "ses-${ses}/perf/${fstr}_asl.nii.gz"

# Make ASL context file
create_context_tsv.py \
    --img_niigz "${perf_dir}/${fstr}_asl.nii.gz" \
    --alternating \
    --control_first

# Add other vars

