#!/bin/sh

# Will only run if <freesurfershell> has been sourced previously!!!!!!
# Set SUBJECTS_DIR to respective folder !!!

#export SUBJECTS_DIR=~/MRI/WMA/recons/
#export SUBJECTS_DIR=~/MRI/ping/recons/
export doublebufferflag=1

cd /tmp
prefix=$1

# (while read s ; do echo -e "resize_window 800\nscale_brain 
1.5\nredraw\nsave_tiff /tmp/${s}.tif\nexit" | tksurfer $s lh pial 
-annotation aparc -delink ; done) < ~/subjects_for_color_brain_pics.txt
for s in ${prefix} ; do echo -e "resize_window 800\nscale_brain 
1.5\nredraw\nsave_tiff /tmp/${s}.tif\nexit" | tksurfer $s lh pial 
-annotation aparc -delink ; done

for i in "${prefix}".tif;do convert -transparent black -background 
gray80 -flatten -repage +0-100 -crop 800x600+0+0 -repage 0x0 $i 
${i//.tif/.png};done

for i in "${prefix}".png;do sed -e "s/<PICNAMEHERE>/${i}/" 
brain_temp.tex > ${i//.png/.tex};done

for i in "${prefix}".tex;do pdflatex $i;done

