%% Global Variables

    %  Necessary for functions

cfg.protocol='tacrvib';
% .Ave file for ERM
cfg.covdir = ('/cluster/transcend/scripts/MEG/descriptors/cov_descriptors/from_calvin_001_marvin');
% .Ave file for Protocol
% cfg.protocol_covdir = ('/space/sondre/2/users/meg/wmm');
cfg.protocol_covdir=('/cluster/transcend/scripts/MEG/descriptors/ave_descriptors/from_marvin_001');
% Data Directory
cfg.data_rootdir=('/autofs/space/amiga_001/users/meg/tacrvib');
%cfg.data_rootdir=('/autofs/space/amiga_001/users/meg/tacr_new');
% ERM Directory
% cfg.erm_rootdir=('/autofs/cluster/transcend/manfred/erm');
cfg.erm_rootdir=('/autofs/space/amiga_001/users/meg/erm1');


% For calc/forward inverse
cfg.setMRIdir=('/space/sondre/1/users/mri/mit/recon');
addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/');


    
%% Parameters

% Subjects
    % If multiple
     %   cfg.amp_sub_folders=dir(strcat(cfg.data_rootdir,'/*0*'));
     
    % If single
        
 % tacr   
%  subject={'014002';'041901';'AC054';'AC058';'042301';'AC069';'AC003'};
%subject={'AC054';'AC072';'AC073';'AC074';'AC053';'AC067';'040701';'051301';'007501';'013001';'038301';'010401';'010001';'017801';'042201';'AC069';'012301';'014001';'AC065'};
%subject={'AC065'}
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
'AC077';'AC042';'AC069'};'014002';'018301';'014901';'012301';'014001';'AC050';'AC063';'AC065';'043202';'012301';'002901';'050901'};


% %     
%  wmm   
% subject={'005801','007501','008801','009101','009102','009901','012301','014001','014002','014901','015001','015601','018201','030801','046503','055201','005901','007501','012002','016201','017801','021301','026801','027202','AC017','AC019','AC021'};
%subject={'005801','007501','009101','009102','009901','012002','012301','015001','027202'};   
% emo1
% subject={'007501'};
%subject={'043202';'012301';'002901';'050901'};

% subject_needing_correction

% subject={'038301';'040701';'042201';'042301';'043202';'AC003';'AC023';'AC046';'AC053';'AC067';'AC070';'AC076';'AC050';'002901'};
% visitNo=[ones(12,1);2;2];

% subject={'012301'};
% visitNo=3;

% subject={'AC076';'040701';'043202';'AC023';'AC046';'AC067';'AC070';'AC050';'002901'};
% visitNo=[1;1;1;1;1;1;1;2;2];

%  subject={'040701','AC050','AC070'};
%  visitNo=[1,2,1];

% subject={'AC070'};
% visitNo=[1];

%subject={'009101';'AC047'};
%visitNo=[1,2];
%visitNo=[1;3;2;1];
cfg.single_subject=[];
        % If performing ERM, indicates # of erm runs per visitN0...Almost always=1; If different for different subjects, can be a matrix
        % If multiple dimensions, must match length(cfg.amp_sub_folders)
        erm_run=ones(70,1);
        % runs of the data to be processed. If different for different subjects, can be a matrix
         % If multiple dimensions, must match length(cfg.amp_sub_folders)
        run=ones(70,1);
         visitNo=[ones(45,1);2;2;2;2;2;2;2;2;1;3;2;1;2];

%          run=[2,1];
        % visitNo of each of the subject(s). if multiple, can be a matrix
        % If multiple dimensions, must match length(cfg.amp_sub_folders) 
%visitNo=[1];
%               visitNo=[ones(44,1);2;2;2;2;2;2;2;2;1;3;2;1];
                %visitNo=[2];
%         filename=strcat('Batch_intital_parameters_',cfg.protocol,'cfg');
%         save(filename,'cfg','visitNo','run','erm_run');
%% Batch script Execution

if ~isfield(cfg,'create_protocol_spreadsheet')
counter=1;
failed_subjects=cell(length(subject),1);


if isfield(cfg,'single_subject'),
% matlabpool 8  
    %parfor i=1:length(subject),
    for i=2:length(subject),
  
    
    try
    fprintf('Processing single subject %s\n',subject{i});
    
     master_preprocessing_script(subject{i},visitNo(i),run(i),erm_run(i),cfg);

    catch
    fprintf('Subject Failed ! %s\n',subject{i});
    %failed_subjects{counter,1}= subject{i};   
    
    end
    
    end
%matlabpool close
else
        for i=1:length(cfg.amp_sub_folders);
            try
            fprintf('Processing subject %s\n',cfg.amp_sub_folders(i).name)
%             load(filename)
            master_preprocessing_script(cfg.amp_sub_folders(i).name,visitNo(i),run(i),erm_run(i),cfg);
           

            catch
            fprintf('Subject Failed ! %s\n',cfg.amp_sub_folders(i).name)
           % failed_subjects{counter,1}= cfg.amp_sub_folders(i).name; 
%counter=counter+1;
            continue
            end
%        clear all 
       end    
end

end

% cfgsheet=[];
% spreadsheet_start=2;
% for i=1:length(subject)
%      try
% [cfgsheet,spreadsheet_start]=do_output_protocol_chart(subject{i},visitNo(i),run(i),cfgsheet,cfg,spreadsheet_start);
%      catch
%      continue
%      end
% end
% cd(cfg.data_rootdir);
% c=clock;
% filename=strcat(cfg.protocol,'_spreadsheet_',datestr(c),'.txt');
% cell2csv(filename, cfgsheet.output_fields);
% 
