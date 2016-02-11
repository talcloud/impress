function grandaveSK_orig(s,p,nrun)


for iRun=1:nrun  
ave(iRun)=fiff_read_evoked_all(strcat(s,'_',p,'_',num2str(iRun),'_ecgClean-20fil-ave.fif'));
end



Nevents=length(ave(1).evoked);


combinedNave=zeros(Nevents,1);
for iEvents=1:Nevents
    for iRun=1:nrun  
combinedNave(iEvents,1)=combinedNave(iEvents,1)+ave(iRun).evoked(iEvents).nave;
    end
end


nProj=length(ave(1).info.projs);
for iRun=1:nrun
projs(((iRun-1)*3+1):((iRun-1)*3+1+(nProj-1)))=ave(iRun).info.projs;
end



trans=ave(1).info.dev_head_t.trans;

data=zeros(Nevents,size(ave(1).evoked(1).epochs,1),size(ave(1).evoked(1).epochs,2));
for iEvents=1:Nevents
    for iRun=1:nrun  
data(iEvents,1:306,:)=squeeze(data(iEvents,1:306,:))+ave(iRun).evoked(iEvents).epochs(1:306,:);
data(iEvents,307:end,:)=ave(1).evoked(iRun).epochs(307:end,:);
    end
end

data(:,1:306,:)=data(:,1:306,:)./nrun;

gaveName=strcat(s,'_',p,'_ecgClean-20fil-gave.fif');
aveCombined=ave(1);

aveCombined.info.dev_ctf_t=trans;
aveCombined.info.filename=gaveName;
aveCombined.info.projs=projs;

for iEvents=1:Nevents
aveCombined.evoked(iEvents).nave=combinedNave(iEvents,1);
aveCombined.evoked(iEvents).epochs=squeeze(data(iEvents,:,:));
end
fiff_write_evoked(gaveName,aveCombined);