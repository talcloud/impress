#!/bin/csh -f

cd /autofs/space/marvin_003/users/Manoach/source_space/
foreach subj (mano004 mano005 mano007 mano008 mano009 mano010 mano011 mano012 mano013 manoA01 manoA02 manoA03 manoA05 manoA07 manoA08 manoA09 manoA10 manoA11 manoA13)

scp ${subj}/*ir_raw.fif /autofs/space/union_018/users/nandita/roi/${subj}

end
