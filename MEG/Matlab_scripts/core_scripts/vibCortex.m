function vibCortex(subj,numepochs,para,visitNo)




% Reading epoch MEG file
if strcmp(para,'tacr')
    ev=load(['/autofs/cluster/transcend/MEG/tacr_new/epochMEG_event13/' subj '_' para '_VISIT_' num2str(visitNo) '_cond_1_0.1-144fil_event13_epochs.mat']);
end
if  strcmp(para,'tacrvib')
    ev=load(['/autofs/space/amiga_001/users/meg/tacrvib/epochMEG_event13/' subj '_' para '_VISIT_' num2str(visitNo) '_cond_1_0.1-144fil_event13_epochs.mat']);
end
% Taking good epochs
ev.all_epochs=ev.all_epochs(:,:,ev.good_epochs);



% Selecting Random Epochs
randperm1=randperm(size(ev.all_epochs,3));
randperm1=randperm1(1:numepochs);
ev.all_epochs=ev.all_epochs(:,:,randperm1);



% Computing source Space
if strcmp(para,'tacr')
fname_inv=['/autofs/cluster/transcend/MEG/tacr_new/' subj '/' num2str(visitNo)  '/' subj '_tacr_0.1_144_fil_loose_new_erm_megreg_0_new_MNE_proj-inv.fif'];
end
if strcmp(para,'tacrvib')
fname_inv=['/autofs/space/amiga_001/users/meg/tacrvib/' subj '/' num2str(visitNo)  '/' subj '_tacrvib_0.1_144_fil_loose_new_erm_megreg_0_new_MNE_proj-inv.fif'];
end

%Setting Parameters
nave=1;
dSPM=1;
data=ev.all_epochs;

%Running labrep cortex
[cortex] = labelrep_cortex(data,fname_inv,nave,dSPM);

% colapsing the time dimension
cortex=squeeze(mean(cortex,2));

%saving
if strcmp(para,'tacr')

save(strcat('/autofs/cluster/transcend/MEG/tacr_new/epochMEG_event13/cortex/',subj,'_tacr_VISIT_',num2str(visitNo),'_cortex.mat'),'cortex');
end

if strcmp(para,'tacrvib')

save(strcat('/autofs/space/amiga_001/users/meg/tacrvib/epochMEG_event13/cortex/',subj,'_tacrvib_VISIT_',num2str(visitNo),'_cortex.mat'),'cortex');
end




