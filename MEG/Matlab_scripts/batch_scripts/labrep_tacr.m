function labrep_tacr(subj,visit)

addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts')
protocol={'tacr','tacrvib'};

for i=1:1
dat=load(strcat('/autofs/cluster/transcend/MEG/',protocol{i},'/epochMEG/',subj,'_',protocol{i},'_VISIT_',num2str(visit),'_cond_3_0.5-144fil_epochs.mat'));
data=dat.all_epochs(:,:,dat.good_epochs);
times=dat.cfg.times;
clear dat;
fname_inv = strcat('/autofs/cluster/transcend/MEG/',protocol{i},'/',subj,'/',num2str(visit),'/',subj,'_',protocol{i},'_0.5_144_fil_fixed_new_erm_megreg_0_new_MNE_proj-inv.fif');
inv = mne_read_inverse_operator(fname_inv);
%label_rh=strcat('/autofs/cluster/transcend/MEG/tacr_new/',subj,'/',num2str(visit),'/','pac-rh.label');
label_lh=strcat('/autofs/cluster/transcend/MEG/',protocol{1},'/',subj,'/',num2str(visit),'/','s1-lh.label');

%%
nave=1;
dSPM=1;
tacr = labelrep_cortex(data,fname_inv,nave,dSPM);
clear data
%%
%labrep_pac_rh = labelmean(label_rh,inv,tacr,0);
labrep_s1_lh = labelmean(label_lh,inv,tacr,0);


% figure;
% plot(times,mean(labrep_pac_rh,3),'r')
% title(strcat(subj,'-',protocol{i},'-','RH'))
% print(gcf,'-dpng','-r300',strcat(subj,'-',protocol{i},'-','RH.png'))
figure;
temp=mean(labrep_s1_lh,3);
plot(times,temp(:,1:length(times)),'k')
title(strcat(subj,'-',protocol{i},'-','LH'))
path=strcat('/autofs/cluster/transcend/MEG/',protocol{i},'/LH_subjects_for_grant/');
cd(path);
print(gcf,'-dpng','-r300',strcat(subj,'-',protocol{i},'-','LH-cond-3.png'))
close all
save(strcat('/autofs/cluster/transcend/MEG/',protocol{i},'/labrep_s1_subjects_for_grant/',subj,'-',protocol{i},'-labrep_cond_3.mat'),'labrep_s1_lh','times');
end

cd('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/batch_scripts') 