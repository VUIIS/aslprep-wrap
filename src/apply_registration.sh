#!/usr/bin/env bash
#
# Apply an affine transform from aslprep xfm.txt to a nifti image

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in      
        --xfm_txt)     export xfm_txt="$2";    shift; shift ;;
        --in_niigz)    export in_niigz="$2";   shift; shift ;;
        --out_dir)     export out_dir="$2";    shift; shift ;;
        *) echo "Input ${1} not recognized"; shift ;;
    esac
done

# Create FSL format .mat file from ANTS/ITK format xfm.txt
parstr=$(grep -e '^Parameters\: ' "${xfm_txt}")
IFS=' ' pars=($parstr)
cat << EOF > "${out_dir}"/reg.mat
${pars[1]} ${pars[2]} ${pars[3]} ${pars[10]} 
${pars[4]} ${pars[5]} ${pars[6]} ${pars[11]} 
${pars[7]} ${pars[8]} ${pars[9]} ${pars[12]} 
0 0 0 1
EOF

# Get image sform and store as fsl .mat
sform=$(fslorient -getsform "${in_niigz}")
IFS=$' ' pars=($sform)
cat << EOF > "${out_dir}"/sform.mat
${pars[0]} ${pars[1]} ${pars[2]} ${pars[3]} 
${pars[4]} ${pars[5]} ${pars[6]} ${pars[7]} 
${pars[8]} ${pars[9]} ${pars[10]} ${pars[11]} 
0 0 0 1
EOF

# Concatenate mats
convert_xfm -omat "${out_dir}"/new_sform.mat -concat "${out_dir}"/reg.mat "${out_dir}"/sform.mat

# Output image filename
out_niigz="${out_dir}"/$(basename "${in_niigz}" .nii.gz)Reg2T1.nii.gz

# Convert mat to vec and apply to image
IFS=$' \n' vec=$(cat "${out_dir}"/new_sform.mat)
cp "${in_niigz}" "${out_niigz}"
fslorient -setsform ${vec[@]} "${out_niigz}"

