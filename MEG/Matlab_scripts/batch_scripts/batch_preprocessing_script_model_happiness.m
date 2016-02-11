%% Global Variables 

% MUST SET in TERMINAL MNE_NIGHTLY 'setenv MNE_ROOT /usr/pubsw/packages/mne/nightly/'
% MUST SET setenv SUBJECTS_DIR /autofs/space/calvin_001/marvin/1/users/MRI/WMA/recons


%  Necessary for functions


% Protocol Name    
cfg.protocol='happy';
% .Ave file for ERM
cfg.covdir = ('/cluster/transcend/scripts/MEG/descriptors/cov_descriptors/from_calvin_001_marvin');
% .Ave file for Protocol
cfg.protocol_covdir=('/cluster/transcend/scripts/MEG/descriptors/ave_descriptors/from_marvin_001');
% Data Directory
cfg.data_rootdir=('/autofs/space/calvin_002/users/meg/multimodal');
% ERM Directory
cfg.erm_rootdir=('/autofs/space/calvin_002/users/meg/multimodal/erm');




addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/');
%% Default Settings

% AS DEFAULT, ALL FUNCTIONS/SUBFUNCTIONS WILL RUN/PLEASE UNCOMMENT IN ORDER TO DISABLE A PARTICULAR FUNCTION/SUB-FUNCTION(S). IF A MAIN
% FUNCTION IS DISABLED, ALL SUBFUNCTIONS WILL ALSO BE DISABLED 
% 
     cfg.do_erm_and_data_sss_main=[];
%  
%                   cfg.do_sss_hpifit=[];
%                   cfg.do_sss_bad_channels=[];
                  cfg.do_sss_movementcomp_combined=[];
%                 cfg.do_sss_no_movementcomp_combined=[];
               cfg.do_sss_transform_allrunsto_singlerun=[];
%                 cfg.do_sss_decimation_combined=[];
% 
       cfg.do_mne_preproc_main=[];
% 
                  cfg.do_mne_preproc_heartbeat=[];
                      cfg.do_erm_filtering_mne=[];
                    cfg.do_erm_noise_covariance_mne=[];
                 cfg.do_mne_preproc_filtered=[];
%                cfg.do_mne_preproc_grand_average=[];

%        cfg.do_calc_forward_inverse_main=[];
                 cfg.do_calc_forward=[];
%                cfg.do_calc_inverse=[];
%             
   cfg.do_epochMEG_main=[];
cfg.ecg_mag_number=1;
cfg.frame_tag_checker_off=[];
%% Optional Parameters  
cfg.without_movement_option=[];
cfg.removeECG_EOG=1;
%      cfg.start_run_from=2;
%     cfg.frame_tag_checker_off=[];     
%    cfg.no_data_sss=1; 
 %   cfg.no_data_decimation=1;
 %    cfg.erm_sss=1;
 %    cfg.no_erm_decimation=1;
%    cfg.no_data_sss=1;
%     cfg.epochMEG_time=[];
   cfg.mne_preproc_filt.hpf(1)=.3;
    cfg.mne_preproc_filt.lpf(1)=144;
       cfg.mne_preproc_filt.hpf(2)=.3;
    cfg.mne_preproc_filt.lpf(2)=40;
%     cfg.mne_preproc_filt.hpf(2)=2;
%     cfg.mne_preproc_filt.lpf(2)=20;
%      cfg.filt.hpf(2)=2;  
%         cfg.filt.lpf(2)=20;
 %      cfg.clean_eog_only=[];
 %       cfg.no_projector_application_on_erm=[];
%cfg.apply_projections_only=[];
%cfg.manually_checked_proj=[];
%    cfg.eyeballed_eog=[];
% cfg.turnprojoff=[];
% cfg.eog_manual_sign_indicator=[];
cfg.erm_sss=1;
cfg.erm_decimation=1;
%cfg.make_png_only=[];
%cfg.proj_event=1000;
%cfg.perform_sensitivity_map=[];

%       cfg.epochMEG_event_order{1}=[1,2,4,5];
 %     cfg.epochMEG_event_order{2}=[2,5];
 %      cfg.epochMEG_event_order{1}=[1,4];
%              cfg.epochMEG_event_order{1}=[1,2,4,5];

%        cfg.newevents(1)=[90];
%         cfg.epochMEG_cond_number_manual_set=3;  
%          cfg.newevents(2)=[91];
          % cfg.newevents(1)=[13];
                                % Please specify event order,
                                % for example, event=[1,4,2,5];
                                
%       cfg.epochMEG_merge_events=[];                        
                

              

%      cfg.start_run_from=2;
%     cfg.frame_tag_checker_off=[];     
%    cfg.no_data_sss=1; 
%    cfg.no_data_decimation=1;

%    cfg.no_data_sss=1;
%     cfg.epochMEG_merge_events=[];
% cfg.epochMEG_time=[];
%            cfg.epochMEG_event_order{1}=[1,4];
%       cfg.epochMEG_event_order{2}=[2,3];
%          cfg.newevents(1)=[997];
%           cfg.newevents(2)=[998];
    
%% Parameters

%subject={'SAMPLE1';'SAMPLE2';'SAMPLE3';'SAMPLE4'};
subject={'subj_RS_001'};
%visitNo=[SAMPLEVISITNo1;SAMPLEVISITNo2;SAMPLEVISITNo3;SAMPLEVISITNo4];
visitNo=1;
%run=[SAMPLERUNNo1;SAMPLERUNNo2;SAMPLERUNNo3;SAMPLERUNNo4];
run=4;
%erm_run=[SAMPLEERMRUNNo1;SAMPLEERMRUNNo2;SAMPLEERMRUNNo3;SAMPLEERMRUNNo4];
erm_run=1;
%% Batch script Execution


counter=1;
failed_subjects=cell(length(subject),1);


   
    for i=1:length(subject),
  
    try
    fprintf('Processing single subject %s\n',subject{i});
     master_preprocessing_script(subject{i},visitNo(i),run(i),erm_run(i),cfg);

    catch
    fprintf('Subject Failed ! %s\n',subject{i});
    %failed_subjects{counter,1}= subject{i};   
    
    end
    end





clear all