function  vibranksum(subj,VISIT)




cd /cluster/transcend/MEG/tacr_new/epochMEG_event13/cortex
tacr=load([subj '_tacr_VISIT_' num2str(VISIT) '_cortex.mat'],'cortex');

cd /autofs/space/amiga_001/users/meg/tacrvib/epochMEG_event13/cortex
tacrvib=load([subj '_tacrvib_VISIT_' num2str(VISIT) '_cortex.mat'],'cortex');



statRanksum=zeros(size(tacrvib.cortex,1),1);

for i=1:size(tacrvib.cortex,1)
   statRanksum(i)=myranksum(tacrvib.cortex(i,:),tacr.cortex(i,:)); 
    
end


cd /autofs/space/amiga_001/users/meg/tacrvib/stc_merge


lh=mne_read_stc_file([subj '_0.1_144fil-merge-ave-set-2_visit_' num2str(VISIT) '-lh.stc']);
rh=mne_read_stc_file([subj '_0.1_144fil-merge-ave-set-2_visit_' num2str(VISIT) '-rh.stc']);



lh.data=zeros(10242,2);
rh.data=zeros(10242,2);

lh.tmin=0;
lh.tstep=1;

rh.tmin=0;
rh.tstep=1;

rh.data(:,1)=statRanksum(10243:end,1);
rh.data(:,2)=statRanksum(10243:end,1);
lh.data(:,1)=statRanksum(1:10242,1);
lh.data(:,2)=statRanksum(1:10242,1);

cd /cluster/transcend/sheraz/data/tacrRanksum

mne_write_stc_file([subj '_ranksum-rh.stc'],rh);
mne_write_stc_file([subj '_ranksum-lh.stc'],lh);





command = ['mne_make_movie  --stcin  ' strcat(subj,'_ranksum') ' --subject ' subj ' --morph fsaverage --smooth 5   --stc  ' strcat(subj,'_ranksum-morph')];

[st] = unix(command);

if st ~=0
error('ERROR : error in generating morph stc file')
end
