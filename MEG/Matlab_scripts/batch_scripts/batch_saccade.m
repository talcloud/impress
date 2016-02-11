addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts');
addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/Private_epochMEG/')

cfg.protocol='emo1';
cfg.epochMEG_time(1)=-1.1;
cfg.epochMEG_time(2)=1.1;
counter=1;

subject={'AC016';'AC022';'AC030';'AC046';'AC0501';'AC053';'AC054';'AC056';'AC057';'AC061';'AC063';'AC064';'AC065';'AC066';'AC067';'AC068';'AC070';'AC073';'AC076';'AC077';'AC002';'AC003';'AC005';'AC006';'AC012';'AC015';'AC021';'AC026';'AC042';'AC047';'AC048';'AC049';'AC069';'AC071';'AC072';'AC074';'AC075'};

%subject={'AC030';'AC046';'AC0501';'AC056';'AC057';'AC061';'AC076';'AC077';'AC002';'AC005';'AC012';'AC026';'AC042';'AC047';'AC048';'AC049'};


 for i=1:length(subject),
  
   % for i=1:1
    try
    fprintf('Processing single subject %s\n',subject{i});
    
 %    master_preprocessing_script(subject{i},visitNo(i),run(i),erm_run(i),cfg);
[cfg]=saccades_epoching(subject{i},cfg);
    catch
    fprintf('Subject Failed ! %s\n',subject{i});
    failed_subjects{counter,1}= subject{i};   
    counter=counter+1;
    end
    
end