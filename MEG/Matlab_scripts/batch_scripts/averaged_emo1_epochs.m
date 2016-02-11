subject={'AC016';'AC022';'AC030';'AC046';'AC0501';'AC053';'AC054';'AC056';'AC057';'AC061';'AC063';'AC064';'AC065';'AC066';'AC067';'AC068';'AC070';'AC073';'AC076';'AC077';'AC002';'AC003';'AC005';'AC006';'AC012';'AC015';'AC021';'AC026';'AC042';'AC047';'AC048';'AC049';'AC069';'AC071';'AC072';'AC074';'AC075'};


All_matrix=zeros(37,4,1322);

for isubject=1:37
    
    for icond =1:4

        cd ('/autofs/cluster/transcend/sheraz/emo1/epochMEG')
       load  (strcat(subject{isubject},'_emo1_cond_',num2str(icond),'_CONCATENATED20_epochs.mat'),'times','data_concatenated');
       if sum(isnan(data_concatenated(:)))>0
        isubject
        icond
        pause
       end
       
       temp = mean(data_concatenated,2);
       
       All_matrix(isubject,icond,:)=temp(1:1322);
       
      clear temp  
        
    end
    
end
 
times=times(1:1322);

save(strcat('/autofs/cluster/transcend/sheraz/emo1/average_epochs/AVERAGED_emo1_epochs.mat'),'All_matrix','times');


