#!/bin/csh -f

# FileName    : do_srcspc_setup
# Description : This script prepares the MRI data for source space analysis
# Version     : 2.0
# Usage       : do_srcspc_setup.csh
# Cluster Usage : pbsubmit -c ' /space/calvin/1/marvin/1/users/MRI/scripts/do_srcspc_setup.csh <SUBJECTS_DIR> <subject> >& xxx_srcspc_setup.log' -p -m nandita@nmr.mgh.harvard.edu -l nodes=1:opteron; Note this syntax is for use on the seychelles cluster only. Change accordingly for launchpad.

echo " SCRIPT DIR :/space/calvin/1/marvin/1/users/MRI/scripts/ "
echo " SCRIPT EXECUTED : do_srcspc_setup.csh"
echo " SCRIPT EXECUTED BY :" `whoami`
echo " DATE EXECUTED :" `date`
echo ""


# check if the script was executed ok
if ($#argv != 2) then
        echo "Usage: $0 <subjdir> <subjectid> "
	exit
endif

#save command line args in variables
set subj_dir=$1
set subject=$2

# setenv USE_STABLE_5_0_0
# source /usr/local/freesurfer/nmr-stable50-env

# Use all the newest versions of Freesurfer and MNE:

source /usr/local/freesurfer/nmr-stable51-env

setenv MNE_ROOT /usr/pubsw/packages/mne/nightly/
source ${MNE_ROOT}/bin/mne_setup

echo " SUBJECTS_DIR is ${SUBJECTS_DIR}"
echo " SUBJECT is ${subject}"

setenv SUBJECTS_DIR ${subj_dir}

setenv SUBJECT ${subject}

cd ${SUBJECTS_DIR}/${subject}

# setup the anatomical MRI images

echo ""
echo " setting up the MR images for subject ${subject}"
echo ""

mne_setup_mri --subject ${subject} --mri T1 --overwrite

# 5 generates 10242 sources per hemisphere with a source spacing of 3.1 mm and a surface area per 
# source/mm2 of 9.8   (--cps computes cortical patch statistics)

echo ""
echo "generating 10242  sources per hemisphere  with a source spacing of 3.1mm for subject ${subject} [--ico 5 --cps] "
echo ""

mne_setup_source_space --subject ${subject} --ico 5 --cps --overwrite



# generates BEM meshes using watershed algorithm

echo ""
echo " generating BEM meshes for  subject ${subject} "
echo ""

mne_watershed_bem --subject ${subject} --atlas --overwrite
#/space/orsay/8/megdev/megsw/mne/bin/mne/mne_watershed_bem --subject ${subject} --atlas --overwrite


cd bem

# make symbolic links

echo ""

echo " making symbolic links to  the surfaces"
ln -s watershed/${subject}_inner_skull_surface inner_skull.surf
ln -s watershed/${subject}_outer_skull_surface outer_skull.surf
ln -s watershed/${subject}_outer_skin_surface  outer_skin.surf
echo ""

# generate the BEM geometry file in fif form

echo ""
echo "generating the BEM geometry file in fif form"

mne_setup_forward_model --subject ${subject} --surf --homog --ico 4  --overwrite

echo ""

# high resolution head surface tessellation

echo ""
echo "Generating the high-res head surface tesselation"
echo ""

mkheadsurf -subjid ${subject}

# go to $SUBJECTS_DIR/$SUBJECT/bem. The dense model can only be generated in the dev (check!) environment of MNE

echo ""
echo "Generating the dense head model"
echo ""

cd ${SUBJECTS_DIR}/${subject}/bem

mne_surf2bem --surf ../surf/lh.seghead --id 4 --check --fif ${subject}-head-dense.fif

#mne_make_scalp_surfaces --subject ${subject} # source nightly build

# rename existing head surface file to ${subject}-head-sparse.fif

#mv ${subject}-head.fif ${subject}-head-sparse.fif # rename this model to <subj>-head.fif at the time of calculation of forward solution

mv ${subject}-head-dense.fif ${subject}-head.fif

echo ""
echo "Source space setup for ${subject} is complete. You are now ready to proceed with the co-ordinate frame allignment"
echo ""
