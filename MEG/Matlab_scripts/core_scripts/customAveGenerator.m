function customAveGenerator(subj,numepochs_1_2,numepochs_3,para,visitNo)



% Reading merge ave file
if strcmp(para,'tacrvib')
    template=fiff_read_evoked(['/autofs/space/amiga_001/users/meg/tacrvib/' subj '/' num2str(visitNo)  '/' subj '_tacrvib_1_2_20fil-merge-ave.fif'],1);
elseif strcmp(para,'tacr')
    template=fiff_read_evoked(['/autofs/cluster/transcend/MEG/tacr_new/' subj '/' num2str(visitNo)  '/' subj '_tacr_1_2_20fil-merge-ave.fif'],1);
    
end
% Reading merge ave file
if strcmp(para,'tacrvib')
    ev1=load(['/autofs/space/amiga_001/users/meg/tacrvib/epochMEG/' subj '_' para '_VISIT_' num2str(visitNo) '_cond_1_2-20fil_epochs.mat']);
    ev2=load(['/autofs/space/amiga_001/users/meg/tacrvib/epochMEG/' subj '_' para '_VISIT_' num2str(visitNo) '_cond_2_2-20fil_epochs.mat']);
    ev3=load(['/autofs/space/amiga_001/users/meg/tacrvib/epochMEG/' subj '_' para '_VISIT_' num2str(visitNo) '_cond_3_2-20fil_epochs.mat']);
elseif strcmp(para,'tacr')
    ev1=load(['/autofs/cluster/transcend/MEG/tacr_new/epochMEG/' subj '_' para '_VISIT_' num2str(visitNo) '_cond_1_2-20fil_epochs.mat']);
    ev2=load(['/autofs/cluster/transcend/MEG/tacr_new/epochMEG/' subj '_' para '_VISIT_' num2str(visitNo) '_cond_2_2-20fil_epochs.mat']);
    ev3=load(['/autofs/cluster/transcend/MEG/tacr_new/epochMEG/' subj '_' para '_VISIT_' num2str(visitNo) '_cond_3_2-20fil_epochs.mat']);
end
% Taking good epochs
ev1.all_epochs=ev1.all_epochs(:,:,ev1.good_epochs);
ev2.all_epochs=ev2.all_epochs(:,:,ev2.good_epochs);
ev3.all_epochs=ev3.all_epochs(:,:,ev3.good_epochs);


% Selecting Random Epochs
randperm1=randperm(size(ev1.all_epochs,3));
randperm1=randperm1(1:numepochs_1_2);

randperm2=randperm(size(ev2.all_epochs,3));
randperm2=randperm2(1:numepochs_1_2);

randperm3=randperm(size(ev3.all_epochs,3));
randperm3=randperm3(1:numepochs_3);


ev1.all_epochs=ev1.all_epochs(:,:,randperm1);
ev2.all_epochs=ev2.all_epochs(:,:,randperm2);
ev3.all_epochs=ev3.all_epochs(:,:,randperm3);


%Averaging across epochs
ev1.all_epochs=mean(ev1.all_epochs,3);
ev2.all_epochs=mean(ev2.all_epochs,3);
ev3.all_epochs=mean(ev3.all_epochs,3);

% Generating the data structure
data.info=template.info;
data.evoked(1)=template.evoked(1);
data.evoked(2)=template.evoked(1);
data.evoked(3)=template.evoked(1);


data.evoked(1).first=round(ev1.cfg.times(1).*template.info.sfreq);
data.evoked(2).first=round(ev2.cfg.times(1).*template.info.sfreq);
data.evoked(3).first=round(ev3.cfg.times(1).*template.info.sfreq);


data.evoked(1).last=round(ev1.cfg.times(end).*template.info.sfreq);
data.evoked(2).last=round(ev2.cfg.times(end).*template.info.sfreq);
data.evoked(3).last=round(ev3.cfg.times(end).*template.info.sfreq);



data.evoked(1).times=ev1.cfg.times;
data.evoked(2).times=ev2.cfg.times;
data.evoked(3).times=ev3.cfg.times;


data.evoked(1).nave=numepochs_1_2;
data.evoked(2).nave=numepochs_1_2;
data.evoked(3).nave=numepochs_3;


data.evoked(1).epochs=zeros(size(template.evoked.epochs,1),size(ev1.all_epochs,2));
data.evoked(2).epochs=zeros(size(template.evoked.epochs,1),size(ev2.all_epochs,2));
data.evoked(3).epochs=zeros(size(template.evoked.epochs,1),size(ev3.all_epochs,2));



data.evoked(1).epochs(1:306,:)=double(ev1.all_epochs);
data.evoked(2).epochs(1:306,:)=double(ev2.all_epochs);
data.evoked(3).epochs(1:306,:)=double(ev3.all_epochs);





if strcmp(para,'tacrvib')
    data.evoked(1).comment='Short';
    data.evoked(2).comment='Long';
    data.evoked(3).comment='Vibration';

elseif strcmp(para,'tacr')
    
    data.evoked(1).comment='Short';
    data.evoked(2).comment='Long';
    data.evoked(3).comment='No Vibration';  

end




% Writing the evoked file


if strcmp(para,'tacrvib')
fname=['/autofs/space/amiga_001/users/meg/tacrvib/' subj '/' num2str(visitNo)  '/' subj '_tacrvib_1_2_20fil-events_short_long_vib-ave.fif'];
data.info.filename=fname;
fiff_write_evoked(fname,data)

elseif strcmp(para,'tacr')
fname=['/autofs/cluster/transcend/MEG/tacr_new/' subj '/' num2str(visitNo)  '/' subj '_tacr_1_2_20fil-events_short_long_vib-ave.fif'];
data.info.filename=fname;
fiff_write_evoked(fname,data)  
end












