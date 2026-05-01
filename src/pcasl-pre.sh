#!/bin/bash

# Initialize defaults
export out_dir=/OUTPUTS

# Parse options
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
    --t1_niigz)
        export t1_niigz="$2"; shift; shift;;
    --asl_niigz)
        export asl_niigz="$2"; shift; shift;;
    --m0_niigz)
        export m0_niigz="$2"; shift; shift;;
    --freesurfer_dir)
        export freesurfer_dir="$2"; shift; shift ;;
    --SliceEncodingDirection)
        export SliceEncodingDirection="$2"; shift; shift;;
    --LabelingDuration)
        export LabelingDuration="$2"; shift; shift;;
    --PostLabelingDelay)
        export PostLabelingDelay="$2"; shift; shift;;
    --M0Type)
        export M0Type="$2"; shift; shift;;
    --RepetitionTimePreparationASL)
        export RepetitionTimePreparationASL="$2"; shift; shift;;
    --RepetitionTimePreparationM0)
        export RepetitionTimePreparationM0="$2"; shift; shift;;
    --BackgroundSuppression)
        export BackgroundSuppression="$2"; shift; shift;;
    --BackgroundSuppressionNumberPulses)
        export BackgroundSuppressionNumberPulses="$2"; shift; shift;;
    --TotalAcquiredPairs)
        export TotalAcquiredPairs="$2"; shift; shift;;
    --LabelingDistance)
        export LabelingDistance="$2"; shift; shift;;
    --subject_label)
        export subject_label="$2"; shift; shift;;
    --session_label)
        export session_label="$2"; shift; shift;;
    --out_dir)
        export out_dir="$2"; shift; shift;;
    *)
        echo Unknown input "$1"; shift ;;
    esac
done

# json files corresponding to .nii.gz
t1_json="${t1_niigz%.nii.gz}.json"
asl_json="${asl_niigz%.nii.gz}.json"
m0_json="${m0_niigz%.nii.gz}.json"

# Subject/session labels with BIDS-incompatible characters removed
sub=${subject_label//-/}
sub=${sub//_/}
ses=${session_label//-/}
ses=${ses//_/}

# Rename FS subject dir
mkdir -p /OUTPUTS/freesurfer
mv "${freesurfer_dir}" /OUTPUTS/freesurfer/sub-${sub}_ses-${ses}

# BIDS dir
bids_dir=${out_dir}/aslBIDSinput
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
    --slice_encoding_direction ${SliceEncodingDirection} \
    --labeling_duration ${LabelingDuration} \
    --post_labeling_delay ${PostLabelingDelay}

# Add IntendedFor to M0
add_intendedfor.py \
    --img_niigz "${perf_dir}/${fstr}_m0scan.nii.gz" \
    --intendedfor "ses-${ses}/perf/${fstr}_asl.nii.gz"

# Make ASL context file, assuming alternating label with control first
create_context_tsv.py \
    --img_niigz "${perf_dir}/${fstr}_asl.nii.gz" \
    --alternating \
    --control_first

# Dataset description
echo '{"Name": "ASL data", "BIDSVersion": "1.10.1"}' > "${bids_dir}/dataset_description.json"

# Add other vars
add_fields.py \
    --jsonfile "${perf_dir}/${fstr}_asl.json" \
    --ArterialSpinLabelingType PCASL \
    --M0Type ${M0Type} \
    --RepetitionTimePreparation ${RepetitionTimePreparationASL} \
    --PostLabelingDelay ${PostLabelingDelay} \
    --LabelingDuration ${LabelingDuration} \
    --BackgroundSuppression ${BackgroundSuppression} \
    --BackgroundSuppressionNumberPulses ${BackgroundSuppressionNumberPulses} \
    --TotalAcquiredPairs ${TotalAcquiredPairs} \
    --LabelingDistance ${LabelingDistance}

add_fields.py \
    --jsonfile "${perf_dir}/${fstr}_m0scan.json" \
    --RepetitionTimePreparation ${RepetitionTimePreparationM0}


