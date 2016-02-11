#!/bin/bash

subjdirs=$1

for i in ${subjdirs}; 
  do echo $i;
  cd $i;
  mne_sensitivity_map --fwd ${i}_emo1-fwd.fif --proj ${i}_emo1_144fil_proj-inv.fif --map 7 --stc sens-damp;
  for l in lh rh ; 
    do mne_make_movie --${l} --stcin sens-damp-${l}.stc --png ${i}_sens-damp --subject $i --pick 1000 --smooth 5 --fthresh 5e8 --fmid 10e8 --fmax 20e8;
  done ;
  cd ..;
done 

# for i in ${subjdirs};
#   do echo $i;
#   cd $i ;
#   for l in lh rh ; 
#     do mne_make_movie --${l} --stcin sens-damp-${l}.stc --png ${i}_sens-damp --subject $i --pick 1000 --smooth 5 --fthresh 5e8 --fmid 10e8 --fmax 20e8;
#   done ;
#   cd .. ;
# done                                    
