pwelch_all_lout('/autofs/cluster/transcend/MEG/sqz/visual/050901/1_old/050901_erm_1_0.1-144fil_raw.fif');
close all
pwelch_all_lout('/autofs/cluster/transcend/MEG/sqz/visual/050901/1_old/050901_erm_1_0.1-144fil_raw.fif');
close all
pwelch_all_lout('/autofs/cluster/transcend/MEG/sqz/visual/050901/1_old/050901_sqz_visual_1_raw.fif');
pwelch_all_lout('/autofs/cluster/transcend/MEG/sqz/visual/050901/1_old/050901_sqz_visual_1_0.1_144fil_raw.fif');
pwelch_all_lout('/autofs/cluster/transcend/MEG/sqz/visual/050901/1_old/050901_sqz_visual_1_raw.fif');
close all
pwelch_all_lout('/autofs/cluster/transcend/MEG/sqz/visual/050901/1_old/050901_sqz_visual_1_sss.fif');
close all
clc
cd /autofs/cluster/transcend/MEG/sqz/visual/epochMEG
load('050901_sqz_visual_VISIT_1_run_1_cond_1_0.1-144fil_epochs.mat')
cd TimeFrequency/
ind=1:306;
ind(3:3:306)=[]
dat=all_epochs(ind,:good_epochs);
dat=all_epochs(ind,:,good_epochs);
time=cfg.times;
fs=mean(1./diff(time))
cd realtimeMEG/
cd TimeFrequency/
chan=findbadchannel('/autofs/cluster/transcend/MEG/sqz/visual/050901/1_old/050901_sqz_visual_1_sss.fif',[1343]);
chan=findchannel('/autofs/cluster/transcend/MEG/sqz/visual/050901/1_old/050901_sqz_visual_1_sss.fif',[1343]);
chan=findchannel('/autofs/cluster/transcend/MEG/sqz/visual/050901/1_old/050901_sqz_visual_1_sss.fif',[1343])
chan=findchannel('/autofs/cluster/transcend/MEG/sqz/visual/050901/1_old/050901_sqz_visual_1_sss.fif',[1343 2033]);
chan=findchannel('/autofs/cluster/transcend/MEG/sqz/visual/050901/1_old/050901_sqz_visual_1_sss.fif',[1343 2033])
chan=findchannel('/autofs/cluster/transcend/MEG/sqz/visual/050901/1_old/050901_sqz_visual_1_sss.fif',[1343 2033 1443 1822])
TF=computeTF(dat(chan,:,:),time,[]);
cfg.startTime=-0.25;
cfg.endTime=0;
cfg.times=time;
size(TF.fourierspctrm)
[Total,Induced,Evoked,PLF,ITC]=ComputeAutoTF(TF.fourierspctrm,cfg);
imagesc(squeeze(ITC(1,:,:)));
imagesc(TF.times,TF.freq,squeeze(ITC(1,:,:)));axis xy
imagesc(TF.times,TF.freq,squeeze(Total(1,:,:)));axis xy
imagesc(TF.times,TF.freq,squeeze(Evoked(1,:,:)));axis xy
cfg.Total=1;
[Total,Induced,Evoked,PLF,ITC]=ComputeAutoTF(TF.fourierspctrm,cfg);
imagesc(TF.times,TF.freq,squeeze(Total(1,:,:)));axis xy
imagesc(TF.times,TF.freq,squeeze(Total(2,:,:)));axis xy
cfg.Evoked=1;
cfg.Total_subtract=0;
cfg.Total=1;
[Total,Induced,Evoked,PLF,ITC]=ComputeAutoTF(TF.fourierspctrm,cfg);
imagesc(TF.times,TF.freq,squeeze(Total(1,:,:)));axis xy
imagesc(TF.times,TF.freq,squeeze(Total(2,:,:)));axis xy
imagesc(TF.times,TF.freq,squeeze(Total(1,:,:)));axis xy
imagesc(TF.times,TF.freq,squeeze(Evoked(1,:,:)));axis xy
cfg1.freq        = 8:90;
cfg1.cycles  = 7;
TF=computeTF(dat(chan,:,:),time,cfg1);
cfg.Evoked=1;
cfg.Total=1;
cfg.startTime=-0.25;
cfg.endTime=0;
cfg.times=time;
[Total,Induced,Evoked,PLF,ITC]=ComputeAutoTF(TF.fourierspctrm,cfg);
imagesc(TF.times.*1000,TF.freq,squeeze(Total(2,:,:)));axis xy;xlim([-200 1500])
imagesc(TF.times.*1000,TF.freq,squeeze(Total(1,:,:)));axis xy;xlim([-200 1500])
chan=findchannel('/autofs/cluster/transcend/MEG/sqz/visual/050901/1_old/050901_sqz_visual_1_sss.fif',[1343 2033 1443 1822])
imagesc(TF.times.*1000,TF.freq,squeeze(Evoked(1,:,:)));axis xy;xlim([-200 1500])
imagesc(TF.times.*1000,TF.freq,log10(squeeze(Evoked(1,:,:))));axis xy;xlim([-200 1500])
imagesc(TF.times.*1000,TF.freq,log10(squeeze(ITC(1,:,:))));axis xy;xlim([-200 1500])
imagesc(TF.times.*1000,TF.freq,(squeeze(ITC(1,:,:))));axis xy;xlim([-200 1500])
imagesc(TF.times.*1000,TF.freq,(squeeze(PLF(1,:,:))));axis xy;xlim([-200 1500])
imagesc(TF.times.*1000,TF.freq,(squeeze(PLF(2,:,:))));axis xy;xlim([-200 1500])
imagesc(TF.times.*1000,TF.freq,(squeeze(PLF(3,:,:))));axis xy;xlim([-200 1500])
imagesc(TF.times.*1000,TF.freq,(squeeze(PLF(4,:,:))));axis xy;xlim([-200 1500])
imagesc(TF.times.*1000,TF.freq,(squeeze(Total(4,:,:))));axis xy;xlim([-200 1500])