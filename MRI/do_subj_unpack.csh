#!/bin/csh -f

#####################################################################################

# Script :do_subj_unpack.csh
# Description:This script scans the dicom files for the subjects entered and spits out 
#         the log file 
# Usage:    pbsubmit -c 'do_subj_unpack.csh <subj> <type> >& <subj>_unpack.log ' -p -m nandita@nmr.mgh.harvard.edu -l nodes=1:ppn=3
       
#####################################################################################

echo " SCRIPT DIR :/space/calvin/1/marvin/1/users/MRI/scripts/ "
echo " SCRIPT EXECUTED : $0"
echo " SCRIPT EXECUTED BY :" `whoami`
echo " DATE EXECUTED :" `date`
echo ""

if ($#argv != 3) then
        echo "Usage: $0 <subjectid> <type> <MRIpath>"
	echo "A directory <MRIpath>/unpack/<type>/<subjid> will be created."
endif

#save command line args in variables
set subj=$1
set type=$2
set mri_dir=$3


echo " SUBJECT is ${subj}"

#set mri_dir=/autofs/cluster/transcend/MRI/WMA
set unpack_dir=${mri_dir}/unpack/${type}/${subj}

mkdir $unpack_dir
#cd $unpack_dir
    
setenv USE_STABLE_5_3_0
source /usr/local/freesurfer/nmr-stable53-env

unpacksdcmdir -src ${mri_dir}/DICOM/${subj}/ -targ ${unpack_dir}/ -scanonly ${unpack_dir}/${subj}_unpack.log






