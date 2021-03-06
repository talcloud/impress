#!/bin/bash

#####################################################################################

# Script :copymri_plusping.sh
# Description:This script finds the DICOMs, copies them locally, and does surface reconstruction
# Sheraz Khan : sheraz@nmr.mgh.harvard.edu
# Manfred Kitzbichler: conversion to Bash and general cleanup
# Modified by Santosh Ganesan to select either transcend or ping subjects 
# Martinos Center
# Boston
       
#####################################################################################

script_dir="/space/calvin/1/marvin/1/users/MRI/scripts/"

echo " SCRIPT DIR :" $script_dir
echo " SCRIPT EXECUTED :" $0
echo " SCRIPT EXECUTED BY :" $(whoami)
echo " DATE EXECUTED :" $(date)
echo ""

if [ $# -lt 5 ]
    then echo "Usage: $0 <subjectid> <type> <visit> <run(s)> <email> [<ping_subject>]"
    echo -e "\twhere <run(s)> can be multiple comma separated numbers"
    echo -e "\t<ping_subject> is optional and will process ping subject in PING MRI DIRECTORY if declared ping"
    echo -e "\t(useful if somebody messed up the subject ID fields during scanning)"
    exit
fi

#save command line args in variables
dcmsubj=$1
type=$2
visit=$3
run=$4
email=$5


echo " SUBJECT is ${subj}"

dcm_dir=$(findsession ${dcmsubj} | sed -n -e 's/PATH   :  //gp' | sed -n -e "${visit}p")


if [ $# -eq 6 ]
    then mri_dir=/space/calvin/1/marvin/1/users/MRI/${6}/
    else mri_dir=/space/calvin/1/marvin/1/users/MRI/WMA/
fi

echo " DICOM path from findsession :" $dcm_dir
if mkdir ${mri_dir}/DICOM/${subj}; then 
    echo -n " Copying DICOMs to ${mri_dir}/DICOM/${subj} ... "
    cp -rp ${dcm_dir}/* ${mri_dir}/DICOM/${subj}/
    echo "done"
else
    echo "Folder ${mri_dir}/DICOM/${subj} exists already, skipping ..."
fi

export SUBJECTS_DIR=${mri_dir}/recons/

echo -n " Running unpack ... "
${script_dir}/do_subj_unpack.csh ${subj} ${type} ${mri_dir} >& ${mri_dir}/unpack/log/${subj}_unpack.log
 echo "done"

COMMAND="${script_dir}/do_wma_fsrecon.csh ${subj} ${type} ${mri_dir} ${run}"
echo -e "Sending this command to the cluster:\n\t" \"$COMMAND\"

ssh -i ${script_dir}/id_rsa_pbs_sheraz sheraz@launchpad pbsubmit -p -o "-j\ oe" -m ${email} -l nodes=1:ppn=3 -c \"$COMMAND\"

#ssh -i id_rsa_pbs_sheraz sheraz@launchpad pbsubmit -p -o "-j\ oe" -m ${email} -q GPU -l nodes=1:GPU:ppn=3 -c \"$COMMAND\"
#ssh -i id_rsa_pbs_santosh santosh@launchpad pbsubmit -p -o "-j\ oe" -m ${email} -l nodes=1:ppn=3 -c \"$COMMAND\"
