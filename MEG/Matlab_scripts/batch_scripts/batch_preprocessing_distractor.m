%% Global Variables

    %  Necessary for functions

cfg.protocol='distractor';
cfg.covdir = ('/cluster/transcend/scripts/MEG/descriptors/cov_descriptors/from_calvin_001_marvin');
% .Ave file for Protocol
% cfg.protocol_covdir = ('/space/sondre/2/users/meg/wmm');
cfg.protocol_avedir=('/cluster/transcend/scripts/MEG/descriptors/ave_descriptors/from_marvin_001');
% Data Directory
cfg.data_rootdir=('/cluster/transcend/MEG/distractor');
%cfg.data_rootdir=('/autofs/space/amiga_001/users/meg/tacr_new');
% ERM Directory
% cfg.erm_rootdir=('/autofs/cluster/transcend/manfred/erm');
cfg.erm_rootdir=('/autofs/space/amiga_001/users/meg/erm1');


%!export SUBJECTS_DIR=/autofs/space/calvin_001/marvin/1/users/MRI/WMA/recons/

% For calc/forward inverse
%cfg.setMRIdir=('/space/sondre/1/users/mri/mit/recon');
addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/');
%% Default Settings

% AS DEFAULT, ALL FUNCTIONS/SUBFUNCTIONS WILL RUN/PLEASE UNCOMMENT IN ORDER TO DISABLE A PARTICULAR FUNCTION/SUB-FUNCTION(S). IF A MAIN
% FUNCTION IS DISABLED, ALL SUBFUNCTIONS WILL ALSO BE DISABLED 


%   cfg.do_erm_and_data_sss_main=[];
%  
 %                  cfg.do_sss_hpifit=[];
  %                cfg.do_sss_bad_channels=[];
 %                  cfg.do_sss_movementcomp_combined=[];
%                 cfg.do_sss_no_movementcomp_combined=[];
               cfg.do_sss_transform_allrunsto_singlerun=[];
%                 cfg.do_sss_decimation_combined=[];
% 
%      cfg.do_mne_preproc_main=[];
% 
%                 cfg.do_mne_preproc_heartbeat=[];
%                     cfg.do_erm_filtering_mne=[];
%                  cfg.do_erm_noise_covariance_mne=[];
%                  cfg.do_mne_preproc_filtered=[];
%                cfg.do_mne_preproc_grand_average=[];
% 
%        cfg.do_calc_forward_inverse_main=[];
%                 cfg.do_calc_forward=[];
%                cfg.do_calc_inverse=[];
%             
            
%       cfg.do_epochMEG_main=[];
%      cfg.start_run_from=2;
     cfg.frame_tag_checker_off=[];     
%    cfg.no_data_sss=1; 
%     cfg.no_data_decimation=1;
%        cfg.erm_sss=1;
%     cfg.erm_decimation=1;
%    cfg.no_data_sss=1;
  
%     cfg.mne_preproc_filt.hpf(1)=1;
%     cfg.mne_preproc_filt.lpf(1)=144;
%% Parameters
%subject={'040401';'054401';'056901';'063201';'063901'};
subject={'043202';'054401_rescan';'054602';'056901';'063201';'063901';'manfred'};
run=[1,1,1,1,1,1,1,1];
visitNo=[1;2;1;1;1;1;1;1];


%subject={'043202';'054602';'056001';'056601';'056901';'063201';'063901';'040401';'054401'};
erm_run=ones(70,1);
%run=ones(2,1,1,1,1,2,1,2,1);
%visitNo=[1;1;1;1;1;1;1;1;2];
cfg.single_subject=[];

%% Optional Parameters
cfg.epochMEG_event_order(1)=1;
cfg.epochMEG_event_order(2)=2;
cfg.epochMEG_event_order(3)=3;
cfg.epochMEG_event_order(4)=4;
cfg.epochMEG_event_order(5)=5;
cfg.perform_sensitivity_map=[];

%% Batch script Execution

if ~isfield(cfg,'create_protocol_spreadsheet')
counter=1;
failed_subjects=cell(length(subject),1);


if isfield(cfg,'single_subject'),
%matlabpool 8  
    %parfor i=1:length(subject),
    for i=1:length(subject),
  
   % for i=1:1
    try
    fprintf('Processing single subject %s\n',subject{i});
    
     master_preprocessing_script(subject{i},visitNo(i),run(i),erm_run(i),cfg);

    catch
    fprintf('Subject Failed ! %s\n',subject{i});
    failed_subjects{counter,1}= subject{i};   
    
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
