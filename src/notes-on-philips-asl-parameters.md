# Setting up ASLprep for Philips scans

## For the ASL series BIDS sidecar

Here are the relevant excerpts from the ASL exam card for an example scan, along with how they
translate to the BIDS .json format sidecar:

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
    Act. TR/TE (ms)  :                4001 / 16                  RepetitionTimePreparation           4.001    (convert from msec to sec)
    Dyn. scan time  :                 00:08.0                    (Dyn scan time includes label AND control, so ignore it)
    Time to k0  :                     00:04.0 

### M0Type
`Separate` is the only option the current code here can handle.

### SliceEncodingDirection
Slice encoding direction can be determined from a few exam card fields. E.g.

    patientOrientation   :  PatientPos_HFS
    Slice orientation    :  TRANSVERSAL
    Slice scan order     :  ASCEND

This is head-first supine positioning, axial slices, ascending slice order. It translates to the positive
direction on the third voxel axis (`k` for `SliceEncodingDirection` in BIDS terms) for a Nifti file that's
in RL / PA / IS data order.

### SliceTiming
Slices are assumed centered in the time window after `LabelingDuration + PostLabelingDelay`.
See `add_slice_timing_asl.py` for details.



## For the M0 scan BIDS sidecar

From the M0 exam card, only `RepetitionTimePreparation` is needed:

    =======INFO==========================================
    Act. TR/TE (ms)  :                20000 / 13                 RepetitionTimePreparation           20       (convert from msec to sec)

### IntendedFor
Must be set for the separate M0 image. Format is `ses-SESSION/perf/FILEPREFIX_asl.nii.gz`.


## Additional files

### Dataset description file
Example minimum contents for `dataset_description.json` in the BIDS root:

    {"Name": "ASL data", "BIDSVersion": "1.10.1"}

### Context TSV file
Contents of the label file are scan specific, with a one-line header plus one row per volume. Example:

    volume_type
    control
    label
    control
    label
    ...

See `create_context_tsv.py` for details.
