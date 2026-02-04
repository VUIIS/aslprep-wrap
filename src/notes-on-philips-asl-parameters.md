# Setting up ASLprep for Philips scans

## Exam card
Here are the relevant excerpts from the ASL exam card for an example scan:

    EXAM CARD PARAMS                                             BIDS SIDECAR PARAMS
    
    Examcard description:
     patientOrientation   :  PatientPos_HFS
    
    =======GEOMETRY======================================
    Slice orientation  :              TRANSVERSAL
    Slice scan order  :               ASCEND
    
    =======DYNANG========================================
    Dynamic study  :                  INDIVIDUAL
          dyn scans  :                30                         TotalAcquiredPairs                  30
    Arterial Spin labeling  :         pCASL                      ArterialSpinLabelingType            PCASL
          label type  :               PARALLEL
          label distance (mm)  :      93                         LabelingDistance                    -93      (negative due to "F"oot label location)
          label location  :           F
          label duration  :           1650                       LabelingDuration                    1.65     (convert from msec to sec)
          label delay (ms)  :         1600                       PostLabelingDelay                   1.6      (convert from msec to sec)
          vascular crushing  :        NO
          back. supp.  :              YES                        BackgroundSuppression               true
          back. supp. pulses  :       1710 2860 0 0 0            BackgroundSuppressionNumberPulses   2        (count non-zero values)
    
    =======INFO==========================================
    Act. TR/TE (ms)  :                4001 / 16 
    Dyn. scan time  :                 00:08.0 
    Time to k0  :                     00:04.0 

And the M0 exam card:

    =======INFO==========================================
    Act. TR/TE (ms)  :                20000 / 13 


## RepetitionTimePreparation
Needed for both ASL series and M0 image. Just copy from the TR. Don't get sidetracked by the 
Dynamic Scan Time field in the Philips ASL exam card, which reports the total for one control 
PLUS one label scan.

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


## ArterialSpinLabelingType
From `Arterial Spin labeling` line of the exam card. In this case `pCASL` in the exam card 
translates to `PCASL` for BIDS.

## PostLabelingDelay
From `label delay (ms)` in the exam card. Must be converted from msec to sec, e.g. in this example
the value for the BIDS sidecar is `1.6`.

## LabelingDuration
From `label duration` in the exam card. Must be converted from msec to sec, e.g. in this example
the value for the BIDS sidecar is `1.65`.

## BackgroundSuppression
From `back. supp.` in the exam card. In this case `YES` translates to `true` for the BIDS sidecar.

## BackgroundSuppressionNumberPulses
From `back. supp. pulses` in the exam card. Count the non-zero values - in this case `2`.

## TotalAcquiredPairs
30

## LabelingDistance
-93



## Dataset description file

## Context TSV file



## IntendedFor
Must be set for the separate M0 image. Format is `ses-SESSION/perf/FILEPREFIX_asl.nii.gz`.

## M0Type
`Separate` is the only option the current code here can handle.
