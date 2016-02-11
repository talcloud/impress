#!/bin/csh -f

#####################################################################################

# Script :do_wma_fsrecon.csh
# Description: This scripts reconstructs the brain and sets up the MRI for source-space analysis          
#Cluster Usage: pbsubmit -c '/autofs/space/calvin_001/marvin/1/users/MRI/scripts/do_wma_fsrecon.csh <subj> <type> <MRIdir> >& <subj>_fsrecon.log ' -p -m nandita@nmr.mgh.harvard.edu -l nodes=1:ppn=3 (on launchpad) for seychelles, use nodes=1:opteron
 #####################################################################################


echo " SCRIPT DIR :/space/calvin/1/marvin/1/users/MRI/scripts/ "
echo " SCRIPT EXECUTED : $0"
echo " SCRIPT EXECUTED BY :" `whoami`
echo " DATE EXECUTED :" `date`
echo ""

# check if the script was executed ok
if ($#argv != 4) then
        echo " THE SCRIPT WAS NOT EXECUTED CORRECTLY "
        echo ""
        echo "Usage: $0 <subjectid> <type> <MRIdir> <run>"
        echo "Arguments received: $*"
        exit
endif

# subject id will be set to the ID provided by user
set subj=$1
set type=$2
set mri_dir=$3
set run=$4
#set run=`echo $4 | tr , \\n`

#set mri_dir=/autofs/space/calvin_001/marvin/1/users/MRI/WMA
set script_dir=/autofs/cluster/transcend/scripts/MRI

# set path to the raw dicom data
set dicom_dir=${mri_dir}/DICOM

# set path to the dir that will save the freesurfer recons
set recon_dir=${mri_dir}/recons

set unpack_dir=${mri_dir}/unpack/${type}/${subj}

setenv SUBJECTS_DIR ${recon_dir}
setenv SUBJECT ${subj}

# setenv USE_STABLE_5_0_0
# source /usr/local/freesurfer/nmr-stable50-env

source /usr/local/freesurfer/nmr-stable53-env

if ( { mkdir -m o-w -p ${unpack_dir} } ) then
    echo -n " Unpacking the data for subject ${dicom_dir} ... "
    unpacksdcmdir -src ${dicom_dir}/${subj}/ -targ ${unpack_dir}/ -scanonly ${unpack_dir}/${subj}_unpack.log |& tee ${mri_dir}/unpack/log/${subj}_unpack.log
    echo "done"
else
    echo "Folder ${unpack_dir} exists already, skipping ..."
endif

set mprage=`grep -e 'MEMPRAGE.*  ok  256 256 176   1' ${unpack_dir}/${subj}_unpack.log | awk '{print $8}'`
echo "The MPRAGE dicom set is ${mprage}"
#set mprage_num to the number of MPRAGE runs
set mprage_num=${#mprage}
echo "The number of MPRAGE runs is ${mprage_num}"
if ( $run == 0 ) set run=`seq -s, ${mprage_num}`

set infiles=""
foreach i (${run:as/,/ /})
    set infiles="$infiles -i ${dicom_dir}/${subj}/${mprage[$i]}"
end
#echo Using: $infiles

#recon-all -subject ${subj} ${infiles} -use-gpu -autorecon-all -qcache -no-isrunning |& tee ${SUBJECTS_DIR}/log/fsrecon/${subj}_fsrecon.log
#recon-all -subject ${subj} ${infiles} -autorecon-all -qcache -force -no-isrunning |& tee ${SUBJECTS_DIR}/log/fsrecon/${subj}_fsrecon.log
recon-all -subject ${subj} ${infiles} -autorecon-all -qcache -no-isrunning |& tee ${SUBJECTS_DIR}/log/fsrecon/${subj}_fsrecon.log
if ( $? ) then
    echo "Seems that recon-all failed. Stopping pipeline execution here!"
    echo "MNE source space setup and label definitions won't be run."
    exit
endif

${script_dir}/do_srcspc_setup.csh ${recon_dir} ${subj}

set templ=(aparc aparc.a2009s)
set labdir=(2005_labels 2009_labels)

foreach i (1 2)
    foreach hemi (lh rh)
	mri_annotation2label --subject ${subj} --hemi ${hemi} --outdir ${recon_dir}/${subj}/${labdir[$i]} --annotation ${templ[$i]} --surface white
    end
end

echo "###################### The End ######################"
