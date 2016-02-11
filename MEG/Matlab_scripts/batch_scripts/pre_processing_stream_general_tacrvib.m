 

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


%!export SUBJECTS_DIR=/autofs/space/calvin_001/marvin/1/users/MRI/WMA/recons/

% For calc/forward inverse
cfg.setMRIdir=('/space/sondre/1/users/mri/mit/recon');
addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/');
%% Default Settings

% % AS DEFAULT, ALL FUNCTIONS/SUBFUNCTIONS WILL RUN/PLEASE UNCOMMENT IN ORDER TO DISABLE A PARTICULAR FUNCTION/SUB-FUNCTION(S). IF A MAIN
% % FUNCTION IS DISABLED, ALL SUBFUNCTIONS WILL ALSO BE DISABLED 
% % 
%          cfg.do_erm_and_data_sss_main=[];
% %  
% %                   cfg.do_sss_hpifit=[];
% %                   cfg.do_sss_bad_channels=[];
% %                   cfg.do_sss_movementcomp_combined=[];
% %                  cfg.do_sss_no_movementcomp_combined=[];
% %                 cfg.do_sss_transform_allrunsto_singlerun=[];
% %                 cfg.do_sss_decimation_combined=[];
% % 
% %       cfg.do_mne_preproc_main=[];
% % 
%                   cfg.do_mne_preproc_heartbeat=[];
% %                   cfg.do_erm_filtering_mne=[];
% %                 cfg.do_erm_noise_covariance_mne=[];
%                  cfg.do_mne_preproc_filtered=[];
%                  cfg.do_mne_preproc_grand_average=[];
% 
% %        cfg.do_calc_forward_inverse_main=[];
%                  cfg.do_calc_forward=[];
% %                cfg.do_calc_inverse=[];
% %             
%    cfg.do_epochMEG_main=[];
% %      cfg.start_run_from=2;
%      cfg.frame_tag_checker_off=[];     
% %    cfg.no_data_sss=1; 
% %    cfg.no_data_decimation=1;
% %      cfg.erm_sss=1;
% %     cfg.no_erm_decimation=1;
% %    cfg.no_data_sss=1;
% %     cfg.epochMEG_time=[];
%     cfg.mne_preproc_filt.hpf(1)=2;
%     cfg.mne_preproc_filt.lpf(1)=20;
%      cfg.filt.hpf(1)=2;  
%         cfg.filt.lpf(1)=20;
%  %      cfg.clean_eog_only=[];
%  %       cfg.no_projector_application_on_erm=[];
% cfg.apply_projections_only=[];
% % cfg.manually_checked_proj=[];
% %    cfg.eyeballed_eog=[];
%  cfg.turnprojoff=[];
% %  cfg.eog_manual_sign_indicator=[];
% cfg.erm_sss=1;
% cfg.erm_decimation=1;
% cfg.make_png_only=[];
% %cfg.proj_event=1000;
% 

 subject={ 'AC013';'041901'; '018301';
     '010401';
     '010001';

'017801';





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

'042301';
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
'AC077';'AC042';'AC069';'014002';'018301';'014901';'012301';'014001';'AC050';'AC063';'AC065';'043202';'012301';'002901';'050901';'AC047'};

% subject={'002901';
%     '010401';
%     '014002';
%     '038301';
%     '040701';
%     '042201';
%     '042301';
%     '042401';
%     '043202';
%     '050901';
%     '051301';
%     '051901';
%     'AC003';
%     'AC013';
%     'AC023';
%     'AC047';
%     'AC050';
%     'AC053';
%     'AC054';
%     'AC058';
%     'AC061';
%     'AC063';
%     'AC065';
%     'AC067';
%     'AC068';
%     'AC069';
%     'AC070';
%     'AC072';
%     'AC073';
%     'AC075';
%     'AC076';
%     'AC077'};
%subject={'012301';'002901';'050901'};
%visitNo=[3;2;1];
 visitNo=[ones(45,1);2;2;2;2;2;2;2;2;1;3;2;1;2];
% visitNo=[2;1;2;1;1;1;1;1;1;1;1;1;1;1;1;1;2;1;1;1;1;2;2;1;1;1;1;1;1;1;1;1];

cfg.single_subject=[];

        erm_run=ones(70,1);

        run=ones(70,1);



addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/batch_scripts')

%% Batch script Execution

if ~isfield(cfg,'create_protocol_spreadsheet')

counter=1;
failed_subjects=cell(length(subject),1);


if isfield(cfg,'single_subject'),
    % for i=2
    for i=1:length(subject),
  
    try
    fprintf('Processing single subject %s\n',subject{i});
 data_subjdir=[cfg.data_rootdir '/' subject{i} '/' num2str(visitNo(i)) '/'];
cd(data_subjdir)   

load(strcat(cfg.data_rootdir,'/',subject{i},'/',num2str(visitNo(i)),'/',subject{i},'_do_calc_forward_cfg.mat'));



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













% if isfield(cfg,'epochMEG_event_order')
%     cfg=rmfield(cfg,'epochMEG_event_order');
% 
% end
% %cfg.epochMEG_event_order{1}=[1,2,4,5];
% if isfield(cfg,'newevents')
%     cfg=rmfield(cfg,'newevents');
% 
% end
% 
% if isfield(cfg,'epochMEG_merge_events')
%     cfg=rmfield(cfg,'epochMEG_merge_events');
% 
% end

%cfg.epochMEG_event_order(1)=[13];
%cfg.epochMEG_merge_events=[];  



% if isfield(cfg,'do_epochMEG_main')
% cfg=rmfield(cfg,'do_epochMEG_main');
% end
% [cfg]=do_mne_preproc_grand_average(subject{i},visitNo,run,cfg);
 
if isfield(cfg,'mne_preproc_filt')
 cfg=rmfield(cfg,'mne_preproc_filt');
end
if isfield(cfg,'filt')
  cfg=rmfield(cfg,'filt');
end
    cfg.mne_preproc_filt.hpf(1)=2;
    cfg.mne_preproc_filt.lpf(1)=20;
     cfg.filt.hpf(1)=2;  
        cfg.filt.lpf(1)=20;

if isfield(cfg,'perform_sensitivity_map')
  cfg=rmfield(cfg,'perform_sensitivity_map');
end       

        cd ('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/');
%addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/Private_epochMEG/')
s = warning('off', 'all');
%cfg.epochMEG_cond_number_manual_set=1;
%[cfg]=do_epochMEG(subject{i},visitNo,run,cfg);
 
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

[cfg]=do_calc_inverse(subj,visitNo,run,cfg,1);
    catch
    fprintf('Subject Failed ! %s\n',subject{i});
    failed_subjects{counter,1}= subject{i};   
    
    end
 clear cfg   
   visitNo=[ones(45,1);2;2;2;2;2;2;2;2;2;1;3;2;1;2];


cfg.single_subject=[];

        erm_run=ones(70,1);

        run=ones(70,1);


    
    end

  
end

end
