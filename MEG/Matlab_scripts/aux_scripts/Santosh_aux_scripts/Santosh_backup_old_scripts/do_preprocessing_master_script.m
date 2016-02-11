[subj,visitNo,run,cfg]=do_preprocessing_master_script(subj,visitNo,run,cfg);

% Activate Master Script
cfg.do_master_preprocessor_activation=[];

% Main function/script directory
addpath('/autofs/space/marvin_001/users/MEG/scripts/kenet/ml/curr/Santosh/SVN/');

%% Settings  ERM
% Main Path where input ERM files are stored
cfg.rootdir=('/autofs/space/marvin_001/users/MEG/scripts/kenet/ml/curr/Santosh/SVN/Test');

% .Ave file for ERM
cfg.covdir = ('/autofs/space/calvin_001/marvin/1/users/MEG/descriptors/cov_templates/');


   if ~isfield(cfg,'do_erm_SSS')
        cfg.do_erm_SSS=1;
   end
    
   if ~isfield(cfg,'do_erm_decimation')
        cfg.do_erm_decimation=1;
   end
   
   if ~isfield(cfg,'do_erm_filtering')
        cfg.do_erm_filtering=1;
   end
 
   if ~isfield(cfg,'do_erm_noise_covariance')
   cfg.do_erm_noise_covariance=1;
   end
%% Actions ERM   
[subj,visitNo,run,cfg]=do_erm_main(subj,visitNo,run,cfg);   

% Remove ERM covariance directory and clear workspace
rmpath('/autofs/space/calvin_001/marvin/1/users/MEG/descriptors/cov_templates/')
clear all;

%% Main Prerocessing Settings  

% Main Path where input SSS files are stored
cfg.rootdir=('/autofs/space/marvin_001/users/MEG/scripts/kenet/ml/curr/Santosh/SVN/Test/SSS_Test');

% .Ave file for Protocol
cfg.covdir = ('/autofs/space/marvin_001/users/MEG/descriptors/ave_templates/');

% Protocol Name
cfg.protocol='fmm';

%% Settings SSS

% SSS private directory
addpath('/autofs/space/marvin_001/users/MEG/scripts/kenet/ml/curr/Santosh/SVN/Private_SSS/')

    if ~isfield(cfg,'do_sss_hpifit')
        cfg.do_sss_hpifit=1;
        fprintf('Performing sss_hpifit %s\n',subj);    
    end
    
    if ~isfield(cfg,'do_sss_bad_channels')
        cfg.do_sss_bad_channels=1;
        fprintf('Performing sss_bad_channels %s\n',subj);   
    end
   
    if ~isfield(cfg,'do_sss_movement_comp')
        cfg.do_sss_movement_comp=1;
        fprintf('Performing sss_movement_comp, if needed %s\n',subj);    
    end
 
    if ~isfield(cfg,'do_sss_without_movement_comp')
        cfg.do_sss_without_movement_comp=1;
        fprintf('Performing sss_without_movement_comp, if needed %s\n',subj);    
    end
   
    if ~isfield(cfg,'do_sss_transform_allrunsto_singlerun')
        cfg.do_sss_transform_allrunsto_singlerun=1;
        fprintf('Performing Transformation of multiple runs into a single run, if needed %s\n',subj);    
    end
    
    if ~isfield(cfg,'do_sss_decimation')
        cfg.do_sss_decimation=1;
        fprintf('Performing decimation  %s\n',subj);    
    end
%% Actions SSS
[subj,visitNo,run,cfg]=do_sss_main(subj,visitNo,run,cfg);

% Remove SSS private directory and clear workspace
rmpath('/autofs/space/marvin_001/users/MEG/scripts/kenet/ml/curr/Santosh/SVN/Private_SSS/')


%% Settings MNE Preproc


% MNE Preproc private directory
addpath('/autofs/space/marvin_001/users/MEG/scripts/kenet/ml/curr/Santosh/SVN/Private_Mne_Preproc/')


    if ~isfield(cfg,'do_mne_preproc_heartbeat')
        cfg.do_mne_preproc_heartbeat=1;
        fprintf('Performing mne preproc heartbeat %s\n',subj);    
    end
    
    if ~isfield(cfg,'do_mne_preproc_filtered')
        cfg.do_mne_preproc_filtered=1;
        fprintf('Performing mne_preproc_filtering %s\n',subj);   
    end
   
    if ~isfield(cfg,'do_mne_preproc_grand_average')
        cfg.do_mne_preproc_grand_average=1;
        fprintf('Performing Grand average, %s\n',subj);    
    end
    
%% Actions MNE Preproc

[subj,visitNo,run,cfg]=do_mne_preproc_main(subj,visitNo,run,cfg);

% Remove MNE Preproc private directory
rmpath('/autofs/space/marvin_001/users/MEG/scripts/kenet/ml/curr/Santosh/SVN/Private_Mne_Preproc/');


%% Settings Calc. Forward/Inverse

% ERM Directory
erm_directory=('/autofs/space/marvin_001/users/MEG/scripts/kenet/ml/curr/Santosh/SVN/Test');
cfg.ermdir = [erm_directory,'/', subj, '/', num2str(visitNo) '/'];


% Calc. Forward/Inverse private directory
%

cfg.setMRIdir='setenv SUBJECTS_DIR /autofs/space/calvin_001/marvin/1/users/MRI/WMA/recons';

    if ~isfield(cfg,'do_calc_forward')
        cfg.do_calc_forward=1;
        fprintf('Performing calc_forward %s\n',subj);    
    end
    
    if ~isfield(cfg,'do_calc_inverse')
        cfg.do_calc_inverse=1;
        fprintf('Performing calc_inverse %s\n',subj);   
    end
    
%% Actions Calc. Forward/Inverse

 [subj,visitNo,run,cfg]=do_calc_forward_inverse_main(subj,visitNo,run,cfg);

%%
 
 
clear all;
    