#!/usr/bin/env bash

docker run \
    --mount type=bind,src=$(pwd -P)/INPUTS,dst=/INPUTS \
    --mount type=bind,src=$(pwd -P)/OUTPUTS,dst=/OUTPUTS \
    --mount type=bind,src=$(pwd -P)/freesurfer_license.txt,dst=/opt/freesurfer/license.txt \
    pennlinc/aslprep:25.1.0 \
    --output-spaces T1w MNI152NLin2009cAsym \
    --fs-subjects-dir /INPUTS/freesurfer720 \
    --basil \
    /OUTPUTS/aslBIDS \
    /OUTPUTS/results-basil \
    participant
