
cd /autofs/space/marvin_001/users/Santosh/

subjASD={'AC002';'AC012' ;'AC026';	'AC049';'AC071'};

subjTD={ 'AC0501';	'AC053';	'AC054';'AC057'	 ;'AC061'}; 

close all

for indexSub=1:length(subjTD)

 d1=load(strcat('/autofs/space/sondre_002/users/meg/emo1/labrep/',subjTD{indexSub},'_emo1_',num2str(1),'_alligned_40fil_labrep.mat'),'EEG','data_aligned');

% d1=load(strcat('/space/sondre/2/users/meg/emo1/labrepnew/',subjTD{indexSub},'_',num2str(1),'_fussiform_labrep.mat'),'labrep','times','Fs');
% d2=load(strcat('/space/sondre/2/users/meg/emo1/labrepnew/',subjTD{indexSub},'_',num2str(2),'_fussiform_labrep.mat'),'labrep','times','Fs');
% d3=load(strcat('/space/sondre/2/users/meg/emo1/labrepnew/',subjTD{indexSub},'_',num2str(3),'_fussiform_labrep.mat'),'labrep','times','Fs');
% d4=load(strcat('/space/sondre/2/users/meg/emo1/labrepnew/',subjTD{indexSub},'_',num2str(4),'_fussiform_labrep.mat'),'labrep','times','Fs');

% labrep=cat(2,d2.labrep,d3.labrep,d4.labrep);

% figure;
% indexINF=find(mean(labrep,2)==inf);
% labrep(indexINF,:)=[];
% times(indexINF)=[];

times=d1.EEG.times;
% index_time1=find(times > -200);
% index_time1(1)
% index_time2=find(times > 500);
% index_time2(1)
plot(times(182:602),mean(d1.data_aligned(182:602,:),2),'r')
hold on
times=d2.EEG.times;
d2= load(strcat('/autofs/space/sondre_002/users/meg/emo1/labrep/',subjTD{indexSub},'_emo1_alligned_40fil_labrep.mat'),'EEG','data_aligned');

plot(times(165:585),mean(d2.data_aligned(165:585,:),2),'g')
% plot(d2.times,mean(d2.labrep,2),'r');
% plot(d3.times,mean(d3.labrep,2),'g');
% plot(d4.times,mean(d4.labrep,2),'k');
% plot(d4.times,mean(labrep,2),'m');
 hold off

axis tight;
xlabel('Time (ms)');
ylabel('nA-m');
title(strcat('TD-',subjTD{indexSub}));
grid minor;
legend('Houses','All Faces');
print('-djpeg', strcat('/autofs/space/marvin_001/users/Santosh/Good_Subjects/',subjTD{indexSub},'.jpg'));
close all;


    
    
end


for indexSub=1:length(subjASD)

 d1=load(strcat('/autofs/space/sondre_002/users/meg/emo1/labrep/',subjASD{indexSub},'_emo1_',num2str(1),'_alligned_40fil_labrep.mat'),'EEG','data_aligned');
% 
% d1=load(strcat('/space/sondre/2/users/meg/emo1/labrepnew/',subjASD{indexSub},'_',num2str(1),'_fussiform_labrep.mat'),'labrep','times','Fs');
% d2=load(strcat('/space/sondre/2/users/meg/emo1/labrepnew/',subjASD{indexSub},'_',num2str(2),'_fussiform_labrep.mat'),'labrep','times','Fs');
% d3=load(strcat('/space/sondre/2/users/meg/emo1/labrepnew/',subjASD{indexSub},'_',num2str(3),'_fussiform_labrep.mat'),'labrep','times','Fs');
% d4=load(strcat('/space/sondre/2/users/meg/emo1/labrepnew/',subjASD{indexSub},'_',num2str(4),'_fussiform_labrep.mat'),'labrep','times','Fs');

% labrep=cat(2,d2.labrep,d3.labrep,d4.labrep);
% 
% figure;
times=d1.EEG.times;
plot(times(182:602),mean(d1.data_aligned(182:602,:),2),'r')
hold on
times=d2.EEG.times;
d2= load(strcat('/autofs/space/sondre_002/users/meg/emo1/labrep/',subjASD{indexSub},'_emo1_alligned_40fil_labrep.mat'),'EEG','data_aligned');

plot(times(165:585),mean(d2.data_aligned(165:585,:),2),'g')
% hold on
% plot(d2.times,mean(d2.labrep,2),'r');
% plot(d3.times,mean(d3.labrep,2),'g');
% plot(d4.times,mean(d4.labrep,2),'k');
% plot(d4.times,mean(labrep,2),'m');
hold off

axis tight;
xlabel('Time (ms)');
ylabel('nA-m');
title(strcat('ASD-',subjASD{indexSub}));
grid minor;
legend('Houses','All Faces');
print('-djpeg', strcat('/autofs/space/marvin_001/users/Santosh/Good_Subjects/',subjASD{indexSub},'.jpg'));
close all;


    
    
end




