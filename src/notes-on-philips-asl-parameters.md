# Setting up ASLprep for Philips scans

## Dataset description file

## Context TSV file



## IntendedFor
Must be set for the separate M0 image. Format is `ses-SESSION/perf/FILEPREFIX_asl.nii.gz`.

## SliceEncodingDirection
Slice order can be determined from a few exam card fields. E.g.

    patientOrientation   :  PatientPos_HFS
    Slice orientation    :  TRANSVERSAL
    Slice scan order     :  ASCEND

This is head-first supine positioning, axial slices, ascending slice order. It translates to the positive
direction on the third voxel axis ('k' for SliceEncodingDirection in BIDS terms) for a Nifti file that's
in RL / PA / IS data order.

## SliceTiming
Slices are assumed centered in the time window after LabelingDuration + PostLabelingDelay.
See `add_slice_timing_asl.py` for details.

## M0Type
`Separate` is the only option the current code here can handle.

## RepetitionTimePreparation
Needed for both ASL series and M0 image. Just copy from the TR. Don't get sidetracked by the 
Dynamic Scan Time field in the Philips ASL exam card, which reports the total for one control 
PLUS one label scan.

## PostLabelingDelay
From the exam card:

    label delay (ms)  :         1600 

Must be converted from msec to sec, e.g. in this example the value for the BIDS sidecar is `1.6`.

## LabelingDuration
From the exam card:

    label duration  :           1650

Must be converted from msec to sec, e.g. in this example the value for the BIDS sidecar is `1.65`.



## BackgroundSuppression
true

## BackgroundSuppressionNumberPulses
2

## ArterialSpinLabelingType
PCASL

## TotalAcquiredPairs
30

## LabelingDistance
-93

