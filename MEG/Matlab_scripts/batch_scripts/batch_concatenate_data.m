subject={'AC016';'AC022';'AC030';'AC046';'AC0501';'AC053';'AC054';'AC056';'AC057';'AC061';'AC063';'AC064';'AC065';'AC066';'AC067';'AC068';'AC070';'AC073';'AC076';'AC077';'AC002';'AC003';'AC005';'AC006';'AC012';'AC015';'AC021';'AC026';'AC042';'AC047';'AC048';'AC049';'AC069';'AC071';'AC072';'AC074';'AC075'};
 % subject={'AC003'};     
  
for i=1:length(subject)
try
    fprintf('Processing single subject %s\n',subject{i});

   for cond=1:4               
        for irun=1:3,
            
            cd ('/autofs/cluster/transcend/sheraz/emo1/epochMEG-saccades');
            filename=strcat(subject{i},'_emo1_cond_',num2str(cond),'_run_',num2str(irun),'_ecgClean-20fil_epochs.mat');
            load(filename);
            
             data2d=squeeze(all_epochs);
             data2dgood=data2d(:,good_epochs);
             times=cfg.times;
             
if irun==1

 data1=data2dgood;
elseif irun==2,
    
 data2=data2dgood;
else
        
 data3=data2dgood;
  
 end 
  clear all_epochs data2d data2dgood good_epochs
        end
        
        data_concatenated=cat(2,data1,data2,data3);
        clear all_epochs cfg run data2dgood data1 data2 data3
        
     
        save(strcat('/autofs/cluster/transcend/sheraz/emo1/epochMEG/',subject{i},'_emo1_cond_',num2str(cond),'_CONCATENATED20_epochs.mat'));

   end
    
catch
end
end