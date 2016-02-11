function TF=computeTF(data_sensorspace,times,cfg)

nVert=size(data_sensorspace,1);
nTime=size(data_sensorspace,2);
nEpochs=size(data_sensorspace,3);

cfg.fs=mean(1./diff(times));

if ~isfield(cfg,'freq')
cfg.freq        = 1:55;
end
if ~isfield(cfg,'cycles')
cfg.cycles  = 5; %5 cycles
end
if ~isfield(cfg,'wavetype')
cfg.wavetype  = 'morlet'; %5 cycles
end

nFreq=length(cfg.freq);
cfg.W = computeWavelets_2(cfg.fs,cfg.freq,cfg.cycles,cfg.wavetype);
TF=zeros(nVert,nEpochs,nFreq,nTime);

for i=1:nVert
TF(i,:,:,:) = computeWaveletTransform_2(squeeze(data_sensorspace(i,:,:)),cfg);
end


TF.fourierspctrm=permute(TF,[2 1 3 4]);
TF.freq=cfg.freq;
TF.times=times;
TF.cycles=cfg.cycles;
TF.wavetype=cfg.wavetype;

