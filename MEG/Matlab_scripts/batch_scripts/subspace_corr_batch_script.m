


addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts')

% %  % tacr   
%  subject={ 'AC013';'041901'; '018301';
%      '010401';
%      '010001';
% 
% '017801';
% 
% 
% 
% 
% 
% '042201';
% '042301';
% '015402';
% '015601';
% '051301';
% '009101';
% '012002';
% 
% 
% 
% 'pilotei';
% 
% 
% 
% '007501';
% '013001';
% '038301';
% '038502';
% '040701';
% '042401';
% 
% '051901';
% 
% '042301';
% 'AC003';
% 
% 
% 
% 
% 'AC023';
% 
% 'AC046';
% 'AC047';
% 'AC056';
% 
% 'AC053';
% 'AC058';
% 'AC061';
% 
% 'ac047';
% 
% 'AC067';
% 
% 
% 'AC054';
% 
% 'AC064';
% 
% 'AC068';
% 'AC071';
% 
% 'AC070';
% 'AC072';
% 'AC073';
% 'AC075';
% 
% 'AC0066';
% 
% 
% 'AC076';
% 'AC077';'AC042';'AC069';'014002';'018301';'014901';'012301';'014001';'AC050';'AC063';'AC065'};
% 
% 
% 
% visitNo=[ones(44,1);2;2;2;2;2;2;2;2];
% %subject={'051901';'042401';'AC053';'AC068';'AC070';'AC072';'AC073';'AC075';'AC050';'AC063'};
% %subject={'010001';'017801';'041901';'040201';'AC053';'AC067';'AC054';'AC068';'AC070';'AC072';'AC073';'AC075';'AC069';'AC050';'AC065'};  
% %  wmm   
% % subject={'005801','007501','008801','009101','009102','009901','012301','014001','014002','014901','015001','015601','018201','030801','046503','055201','005901','007501','012002','016201','017801','021301','026801','027202','AC017','AC019','AC021'};
% %subject={'005801','007501','009101','009102','009901','012002','012301','015001','027202'};   
% % emo1
% % subject={'AC002','AC003'};
% cfg.single_subject=[];
%         % If performing ERM, indicates # of erm runs per visitN0...Almost always=1; If different for different subjects, can be a matrix
%         % If multiple dimensions, must match length(cfg.amp_sub_folders)
%         erm_run=ones(52,1);
%         % runs of the data to be processed. If different for different subjects, can be a matrix
%          % If multiple dimensions, must match length(cfg.amp_sub_folders)
%         run=ones(52,1);
% 
%         
% if isfield(cfg,'single_subject'),
%      
%     for i=1:length(subject),
%   
%     try
%     fprintf('Processing single subject %s\n',subject{i});
%     
% 
%   cfg.protocol='tacr';
% % .Ave file for ERM
% cfg.covdir = ('/cluster/transcend/scripts/MEG/descriptors/cov_descriptors/from_calvin_001_marvin');
% % .Ave file for Protocol
% % cfg.protocol_covdir = ('/space/sondre/2/users/meg/wmm');
% cfg.protocol_covdir=('/cluster/transcend/scripts/MEG/descriptors/ave_descriptors/from_marvin_001');
% % Data Directory
% cfg.data_rootdir=('/cluster/transcend/MEG/tacr_new');
% %cfg.data_rootdir=('/autofs/space/amiga_001/users/meg/tacr_new');
% % ERM Directory
% % cfg.erm_rootdir=('/autofs/cluster/transcend/manfred/erm');
% cfg.erm_rootdir=('/autofs/space/amiga_001/users/meg/erm1');
%   
%     
%     
%     visitNo=[ones(44,1);2;2;2;2;2;2;2;2];
% 
%     
%     load(strcat(cfg.data_rootdir,'/',subject{i},'/',num2str(visitNo(i)),'/',subject{i},'_do_calc_inverse_cfg.mat'));
% 
% cfg.protocol='tacr';
% % .Ave file for ERM
% cfg.covdir = ('/cluster/transcend/scripts/MEG/descriptors/cov_descriptors/from_calvin_001_marvin');
% % .Ave file for Protocol
% % cfg.protocol_covdir = ('/space/sondre/2/users/meg/wmm');
% cfg.protocol_covdir=('/cluster/transcend/scripts/MEG/descriptors/ave_descriptors/from_marvin_001');
% % Data Directory
% cfg.data_rootdir=('/cluster/transcend/MEG/tacr_new');
% %cfg.data_rootdir=('/autofs/space/amiga_001/users/meg/tacr_new');
% % ERM Directory
% % cfg.erm_rootdir=('/autofs/cluster/transcend/manfred/erm');
% cfg.erm_rootdir=('/autofs/space/amiga_001/users/meg/erm1');
% cfg.make_png_only=[];
% 
%      do_mne_subspace_correlationship(subj,visitNo,cfg);
% 
%     catch
%     fprintf('Subject Failed ! %s\n',subject{i});
%     %failed_subjects{counter,1}= subject{i};   
%     
%     end
%     end
% 
% end  

%% tacrvib
 subject={  'AC013'; '018301';
     '010401';
     '010001';

'017801';




'041901';
'042201';
'042301';
'015402';
'015601';
'051301';
'009101';
'012002';



'pilotei';



'007501';
'013001';
'038301';
'038502';
'040701';
'042401';

'051901';


'AC003';




'AC023';

'AC046';
'AC047';
'AC056';

'AC053';
'AC058';
'AC061';

'ac047';

'AC067';


'AC054';

'AC064';

'AC068';
'AC071';

'AC070';
'AC072';
'AC073';
'AC075';

'AC0066';


'AC076';
'AC077';'AC042';'AC069';'014002';'018301';'014901';'012301';'014001';'AC050';'AC063';'AC065'};
   cfg.single_subject=[];
        % If performing ERM, indicates # of erm runs per visitN0...Almost always=1; If different for different subjects, can be a matrix
        % If multiple dimensions, must match length(cfg.amp_sub_folders)
        erm_run=ones(52,1);
        % runs of the data to be processed. If different for different subjects, can be a matrix
         % If multiple dimensions, must match length(cfg.amp_sub_folders)
        run=ones(52,1);
%          run=[2,1];
        % visitNo of each of the subject(s). if multiple, can be a matrix
        % If multiple dimensions, must match length(cfg.amp_sub_folders) 
%visitNo=[1];
               visitNo=[ones(44,1);2;2;2;2;2;2;2;2];     
               
               
               
               
               
               
               
               
 if isfield(cfg,'single_subject'),
     
    for i=1:length(subject),
  
    try
    fprintf('Processing single subject %s\n',subject{i});
    

cfg.protocol='tacrvib';
% .Ave file for ERM
cfg.covdir = ('/autofs/space/calvin_001/marvin/1/users/MEG/descriptors/cov_templates');
% .Ave file for Protocol
% cfg.protocol_covdir = ('/space/sondre/2/users/meg/wmm');
cfg.protocol_covdir=('/autofs/space/marvin_001/users/MEG/descriptors/ave_templates');
% Data Directory
cfg.data_rootdir=('/autofs/space/amiga_001/users/meg/tacrvib');
%cfg.data_rootdir=('/autofs/space/amiga_001/users/meg/tacr_new');
% ERM Directory
% cfg.erm_rootdir=('/autofs/cluster/transcend/manfred/erm');
cfg.erm_rootdir=('/autofs/space/amiga_001/users/meg/erm1');


    
    visitNo=[ones(44,1);2;2;2;2;2;2;2;2];

    
    load(strcat(cfg.data_rootdir,'/',subject{i},'/',num2str(visitNo(i)),'/',subject{i},'_do_calc_inverse_cfg.mat'));

    
    cfg.protocol='tacrvib';
% .Ave file for ERM
cfg.covdir = ('/autofs/space/calvin_001/marvin/1/users/MEG/descriptors/cov_templates');
% .Ave file for Protocol
% cfg.protocol_covdir = ('/space/sondre/2/users/meg/wmm');
cfg.protocol_covdir=('/autofs/space/marvin_001/users/MEG/descriptors/ave_templates');
% Data Directory
cfg.data_rootdir=('/autofs/space/amiga_001/users/meg/tacrvib');
%cfg.data_rootdir=('/autofs/space/amiga_001/users/meg/tacr_new');
% ERM Directory
% cfg.erm_rootdir=('/autofs/cluster/transcend/manfred/erm');
cfg.erm_rootdir=('/autofs/space/amiga_001/users/meg/erm1');
cfg.make_png_only=[];


     do_mne_subspace_correlationship(subj,visitNo,cfg);

    catch
    fprintf('Subject Failed ! %s\n',subject{i});
    %failed_subjects{counter,1}= subject{i};   
    
    end
    end

end                
               
               
               
               
               
               
               
               
               
               
               
               
               
               
               
               
               
               
               
