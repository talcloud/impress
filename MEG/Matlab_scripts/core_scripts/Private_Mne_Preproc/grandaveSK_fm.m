function grandaveSK_fm(cfg,subj,run)


for igrand_avg=1:length(cfg.mne_preproc_grand_average.hpf)
    
    try
    for iRun=1:run  
ave(iRun)=fiff_read_evoked_all(strcat(subj,'_',cfg.protocol,'_',num2str(iRun),'_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'_',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil-ave.fif'));
    end



Nevents=length(ave(1).evoked);


combinedNave=zeros(Nevents,1);
for iEvents=1:Nevents
    for iRun=1:run  
combinedNave(iEvents,1)=combinedNave(iEvents,1)+ave(iRun).evoked(iEvents).nave;
    end
end


ii=1;
for iRun=1:run
nProj=length(ave(iRun).info.projs);
projs(ii:(ii+nProj-1))=ave(iRun).info.projs;
ii=ii+nProj;
end



trans=ave(1).info.dev_head_t.trans;

data=zeros(Nevents,size(ave(1).evoked(1).epochs,1),size(ave(1).evoked(1).epochs,2));
for iEvents=1:Nevents
    for iRun=1:run  
data(iEvents,1:306,:)=squeeze(data(iEvents,1:306,:))+ave(iRun).evoked(iEvents).epochs(1:306,:);
data(iEvents,307:end,:)=ave(1).evoked(iEvents).epochs(307:end,:);
    end
end

data(:,1:306,:)=data(:,1:306,:)./run;

gaveName=strcat(subj,'_',cfg.protocol,'_',cfg.preproc_filtered_file_tag{run},'_',num2str(run),'_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'_',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'_fil_gave.fif');
aveCombined=ave(1);

aveCombined.info.dev_ctf_t=trans;
aveCombined.info.filename=gaveName;
aveCombined.info.projs=projs;

for iEvents=1:Nevents
aveCombined.evoked(iEvents).nave=combinedNave(iEvents,1);
aveCombined.evoked(iEvents).epochs=squeeze(data(iEvents,:,:));
end
fiff_write_evoked(gaveName,aveCombined);
        fprintf('Manual computation of MNE Grand average was SUCCESSFUL ')
    catch
        fprintf('Manual computation of MNE Grand average has failed; WARNING: AVE OR GRAND AVE FILES MAY NOT HAVE BEEN GENERATED ')
        continue
        
    end
end