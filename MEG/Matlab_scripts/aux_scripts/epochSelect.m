
function epochSelect(subj,visit,protocol,nepochs,offset)


%%
dat=load(strcat('/autofs/cluster/transcend/sheraz/MIT/',protocol,'/epochMEG_our_center/',subj,'_',protocol,'_VISIT_',num2str(visit),'_cond_2_0.3-40fil_epochs.mat'));

%%

file=dat.all_epochs;
data=file(:,1:781,dat.good_epochs);

data=data(:,:,1:nepochs);


data=data(:,1:781,:);
meandata=mean(data,3);
[l,w]=size(meandata);
fname =strcat('/autofs/cluster/transcend/sheraz/MIT/',protocol,'/',subj,'/',num2str(visit),'/',subj,'_',protocol,'_1_0.3_40fil-ave.fif');
[dat] = fiff_read_evoked(fname,2);

dat.evoked.epochs(1:length(l),1:781)=double(meandata(1:length(l),1:781));

dat.evoked.nave=nepochs;
dat.info.highpass=0.3;
dat.info.lowpass=40;


fname =strcat('/autofs/cluster/transcend/sheraz/MIT/',protocol,'/epochMEG_our_center/',subj,'_',protocol,'_cond_2_RUN_2_0.3-40fil-',num2str(nepochs),'-epochs-ave.fif');
fiff_write_evoked(fname,dat)


times=dat.evoked.times(1:781)-offset;
fs=dat.info.sfreq;

save(strcat('/autofs/cluster/transcend/sheraz/MIT/fmm/epochMEG_our_center/',subj,'-',protocol,'_cond_2_RUN_2_0.3-40fil-',num2str(nepochs),'-epoch.mat'),'data','times','fs');

