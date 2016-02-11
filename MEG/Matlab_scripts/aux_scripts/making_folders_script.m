
subject={'007501';
    
'008801';
'005801';
'009101';
'009102';
'010401';
'012301';
'013001';
'014901';
'015601';
'016201';
'030801';
'018201';
'040701';
'AC002';
'AC005';
'AC012';
'AC015';
'AC023';
'AC026';
'AC042';
'AC047';
'AC048';
'AC069';
'005901';
'011301';
'011302';
'013703';
'014001';
'014002';
'018301';
'018901';
'021301';
'026801';
'027202';
'AC028';
'AC050';
'AC053';
'AC058';
'AC065';
'AC066';
'038301';
'038502';
'041901';
'042201';
'042301';
};
 visitNo=[1;2;1;3;2;2;1;1;2;2;1;2;1;1;1;2;1;1;1;1;1;1;1;1;2;1;1;1;2;2;2;2;1;1;1;1;1;1;1;1;1;1;1;1;1;1];
%% making folders
% for i=1:length(subject)
% 
% %folderName=unique_subjects{i,1};
% try
%     parentdir=['/autofs/space/calvin_002/users/meg/fmmn/',subject{i},'/'];
%     [status,message,messageid] = mkdir(parentdir,num2str(visitNo(i)));
%   %  display('Processing Subject...');
% catch
%    fprintf('Subject Failed ! %s\n',subject{i});
%  
% continue
% end
% end
%% Moving files



for i=2:length(subject)

%folderName=unique_subjects{i,1};
try
    parentdir=['/autofs/space/calvin_002/users/meg/fmmn/',subject{i},'/'];
    childdir=['/autofs/space/calvin_002/users/meg/fmmn/',subject{i},'/',num2str(visitNo(i))];
    command=['mv ',parentdir, subject{i},'_fmmn_?_raw.fif   ',childdir];
    [st,w] = unix(command);   
    command2=['mv ',parentdir, subject{i},'_fmmn_?_sss.fif   ',childdir];
    [st,w] = unix(command2);
    fprintf('Processing Subject ! %s\n',subject{i});

if st~=0
     fprintf('Subject Failed ! %s\n',subject{i});
  
    
end
    
  %  display('Processing Subject...');
catch
   fprintf('Subject Failed ! %s\n',subject{i});
 
continue
end
end












