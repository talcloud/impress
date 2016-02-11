function  vibranksum_fft(subj,VISIT)




cd /cluster/transcend/MEG/tacr_new/epochMEG_event13/cortex
tacr=load([subj '_tacr_VISIT_' num2str(VISIT) '_fft_cortex.mat'],'cortex','f');

cd /autofs/space/amiga_001/users/meg/tacrvib/epochMEG_event13/cortex
tacrvib=load([subj '_tacrvib_VISIT_' num2str(VISIT) '_fft_cortex.mat'],'cortex','f');



statRanksum=zeros(size(tacrvib.cortex,1),size(tacrvib.cortex,2));

for i=1:size(tacrvib.cortex,1)
    for j=1:size(tacrvib.cortex,2)
    
      statRanksum(i,j)=myranksum(squeeze(tacrvib.cortex(i,j,:)),squeeze(tacr.cortex(i,j,:))); 
   
    end
end


cd /autofs/space/amiga_001/users/meg/tacrvib/stc_merge


lh=mne_read_stc_file([subj '_0.1_144fil-merge-ave-set-2_visit_' num2str(VISIT) '-lh.stc']);
rh=mne_read_stc_file([subj '_0.1_144fil-merge-ave-set-2_visit_' num2str(VISIT) '-rh.stc']);

lhvertices=size(lh.data,1);
rhvertices=size(rh.data,1);

rh.data=zeros(rhvertices,2);
lh.data=zeros(lhvertices,2);


lh.tmin=0;
lh.tstep=1000;

rh.tmin=0;
rh.tstep=1000;

rh.data=double(statRanksum((lhvertices+1):end,:));
lh.data=double(statRanksum(1:lhvertices,:));



cd /cluster/transcend/sheraz/data/tacrRanksum

mne_write_stc_file([subj '_ranksum-rh.stc'],rh);
mne_write_stc_file([subj '_ranksum-lh.stc'],lh);





command = ['mne_make_movie  --stcin  ' strcat(subj,'_ranksum') ' --subject ' subj ' --morph fsaverage --smooth 5   --stc  ' strcat(subj,'_ranksum-morph')];

[st] = unix(command);

if st ~=0
error('ERROR : error in generating morph stc file')
end
