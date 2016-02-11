%% Global Variables

cfg.protocol='fmmn';
% .Ave file for ERM
cfg.covdir = ('/cluster/transcend/scripts/MEG/descriptors/cov_descriptors/from_calvin_001_marvin');
% .Ave file for Protocol
% cfg.protocol_covdir = ('/space/sondre/2/users/meg/wmm');
cfg.protocol_covdir=('/cluster/transcend/scripts/MEG/descriptors/ave_descriptors/from_marvin_001');
% Data Directory
cfg.data_rootdir=('/autofs/space/calvin_002/users/meg/fmmn');
%cfg.data_rootdir=('/autofs/space/amiga_001/users/meg/tacr_new');
% ERM Directory
% cfg.erm_rootdir=('/autofs/cluster/transcend/manfred/erm');
cfg.erm_rootdir=('/autofs/space/amiga_001/users/meg/erm1');


%!export SUBJECTS_DIR=/autofs/space/calvin_001/marvin/1/users/MRI/WMA/recons/

% For calc/forward inverse
cfg.setMRIdir=('/space/sondre/1/users/mri/mit/recon');
addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/');
%%
%        cfg.epochMEG_event_order(1)=[90];
%       cfg.epochMEG_event_order(2)=[91];
%       cfg.epochMEG_event_order(3)=[13];


% tacr
%subject={'005801','007501','009101','009102','009901','012002','012301','013703','015001','027202','011202','010302','010302','008801','014001','014002','014901','015601','030801','055201','007501','026801','AC017','AC019','AC021','046503','018201','005901','011302','016201','017801','021301','058501','059601'};

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
% 'AC077';'AC042';'AC069';'014002';'018301';'014901';'012301';'014001';'AC050';'AC063';'AC065';'043202';'012301';'002901';'050901';'AC047'};
%  visitNo=[ones(45,1);2;2;2;2;2;2;2;2;1;3;2;1;2];
%         erm_run=ones(59,1);
% run=ones(59,1);

%% fmm and fmmn
% 
% subject={
%     
% '008801';
% '005801';
% '007501';
% '009101';
% '009102';
% '010401';
% '012301';
% '013001';
% '014901';
% '015601';
% '016201';
% '030801';
% '018201';
% '040701';
% 'AC002';
% 'AC005';
% 'AC012';
% 'AC015';
% 'AC023';
% 'AC026';
% 'AC042';
% 'AC047';
% 'AC048';
% 'AC069';
% '005901';
% '011301';
% '011302';
% '013703';
% '014001';
% '014002';
% '018301';
% '018901';
% '021301';
% '026801';
% '027202';
% 'AC028';
% 'AC050';
% 'AC053';
% 'AC058';
% 'AC065';
% 'AC066';
% '038301';
% '038502';
% '041901';
% '042201';
% '042301';
% 
% '002901';
% '051901';
% '054602';
% '056901';
% '063201';
% '063901';
% '058501';
% '048102';
% '042901';
% '048901';
% 
% 
% };
 visitNo=[2;1;1;2;2;2;1;1;2;1;1;2;1;1;1;1;1;1;1;1;1;1;1;1;2;1;1;1;2;2;2;2;1;1;1;1;1;1;1;1;1;1;1;1;1;1  ; 2;1;1;1;1;1;1;1;1;1];
 erm_run=ones(70,1);
 run=[1;1;1;1;ones(52,1)];

  subject={'015601'
    % '030801';
    % '058501';
     };
%      'AC005';
%      '018301';
%      '063201';
%     % '063901';
%      '056901';
%      '054602';
%      'AC005';
%     
% % '048901';
% % '042901';
% % '051901';
%  %'002901';
%  %'058501';
%  };
% 
% visitNo=[1;2;1;1;1;1;1;1];
% erm_run=ones(70,1);
% run=[1;1;1;1;1;1;1;1;1];



%%
 %erm_run=ones(52,1);
%         run=[2;2;2;2;2;2;2;2;2;2;ones(21,1);2;1];
    
    
 %       visitNo=[ones(34,1)];
cfgsheet=[];
spreadsheet_start=2;
for i=1:length(subject)
     try
         
   fprintf('Processing subject %s\n',subject{i});      
[cfgsheet,spreadsheet_start]=do_output_protocol_chart(cfg.data_rootdir,subject{i},visitNo(i),run(i),cfgsheet,cfg,spreadsheet_start);
     catch
     continue
     end
end
cd(cfg.data_rootdir);
c=clock;
filename=strcat(cfg.protocol,'_spreadsheet_',datestr(c),'.txt');
cell2csv(filename, cfgsheet.output_fields);
    