#!/usr/bin/env bash

# Nifti inputs
nii_dir=$(pwd)/../INPUTS
t1_niigz="${nii_dir}"/201_cs_T1W_3D_TFE_32_channel.nii.gz
asl_niigz="${nii_dir}"/1202_WIP_SOURCE___ASL_Hippocampus.nii.gz
m0_niigz="${nii_dir}"/1301_pCASL_Hippocampus_3x3x5_m0.nii.gz

# Corresponding json files
t1_json="${t1_niigz%.nii.gz}.json"
asl_json="${asl_niigz%.nii.gz}.json"
m0_json="${m0_niigz%.nii.gz}.json"

# Test subject/session labels
sub=001
ses=001

# BIDS dir
bids_dir=$(pwd)/../OUTPUTS/aslBIDS-hipp
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

# Add slice timing to ASL
#   Slice order can be determined from a few exam card fields. E.g.
#
#        patientOrientation   :  PatientPos_HFS
#        Slice orientation    :  TRANSVERSAL
#        Slice scan order     :  ASCEND
#
#   Translates to k in BIDS terms for a nifti that's in RL / PA / IS data order.
add_slice_timing_asl.py \
    --img_niigz "${perf_dir}/${fstr}_asl.nii.gz" \
    --slice_encoding_direction k \
    --labeling_duration 1.65 \
    --post_labeling_delay 1.6

# Add IntendedFor to M0
add_intendedfor.py \
    --img_niigz "${perf_dir}/${fstr}_m0scan.nii.gz" \
    --intendedfor "ses-${ses}/perf/${fstr}_asl.nii.gz"

# Make ASL context file
create_context_tsv.py \
    --img_niigz "${perf_dir}/${fstr}_asl.nii.gz" \
    --alternating \
    --control_first

# Dataset description
echo '{"Name": "ASL data", "BIDSVersion": "1.10.1"}' > "${bids_dir}/dataset_description.json"

# Add other vars
add_fields.py \
    --jsonfile "${perf_dir}/${fstr}_asl.json" \
    --M0Type Separate \
    --RepetitionTimePreparation 3.75 \
    --PostLabelingDelay 1.6 \
    --LabelingDuration 1.65 \
    --BackgroundSuppression true \
    --BackgroundSuppressionNumberPulses 2 \
    --ArterialSpinLabelingType PCASL \
    --TotalAcquiredPairs 40

add_fields.py \
    --jsonfile "${perf_dir}/${fstr}_m0scan.json" \
    --RepetitionTimePreparation 15


