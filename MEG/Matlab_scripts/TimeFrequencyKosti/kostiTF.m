cd /autofs/cluster/transcend/MEG/sqz/final/epochMEG
load('083701_sqz_visual_VISIT_1_run_1_cond_4_0.5-55fil_epochs.mat')
dat=all_epochs([138 167],:,:);
cfgTF=[];
cfgTF.freq=7:50;
cfgTF.cycles=7;
TF=computeTF(dat,cfg.times,cfgTF);

cfgTF=[];
cfgTF.times=TF.times;
cfgTF.startTime=-0.2; % baseline you need
cfgTF.endTime=0; % baseline you need
cfg.Total_subtract=1;
cfg.Induced_subtract=1;
cfg.Evoked=1;
[Total,Induced,Evoked,PLF,ITC]=ComputeAutoTF(TF.fourierspctrm,cfgTF);
figure;imagesc(TF.times,TF.freq,squeeze(PLF(1,:,:)));axis xy
figure;imagesc(TF.times,TF.freq,squeeze(Total(1,:,:)));axis xy
figure;imagesc(TF.times,TF.freq,squeeze(Evoked(1,:,:)));axis xy

figure;imagesc(TF.times,TF.freq,squeeze(PLF(2,:,:)));axis xy
figure;imagesc(TF.times,TF.freq,squeeze(Total(2,:,:)));axis xy
figure;imagesc(TF.times,TF.freq,squeeze(Evoked(2,:,:)));axis xy

save('kostiTF.mat','TF','dat','PLF','Total','Evoked')