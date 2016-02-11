%% Global Variables

    %  Necessary for functions

cfg.protocol='fmm';
% .Ave file for ERM
cfg.covdir = ('/cluster/transcend/scripts/MEG/descriptors/cov_descriptors/from_calvin_001_marvin');
% .Ave file for Protocol
% cfg.protocol_avedir = ('/space/sondre/2/users/meg/wmm');
cfg.protocol_avedir=('/cluster/transcend/scripts/MEG/descriptors/ave_descriptors/from_marvin_001');
% Data Directory
cfg.data_rootdir=('/cluster/transcend/sheraz/MIT/fmm');
%cfg.data_rootdir=('/autofs/space/amiga_001/users/meg/tacr_new');
% ERM Directory
% cfg.erm_rootdir=('/autofs/cluster/transcend/manfred/erm');
cfg.erm_rootdir=('/autofs/space/amiga_001/users/meg/erm1');


%!export SUBJECTS_DIR=/autofs/space/calvin_001/marvin/1/users/MRI/WMA/recons/

% For calc/forward inverse
cfg.setMRIdir=('/space/sondre/1/users/mri/mit/recon');
addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/');
%% Default Settings

% AS DEFAULT, ALL FUNCTIONS/SUBFUNCTIONS WILL RUN/PLEASE UNCOMMENT IN ORDER TO DISABLE A PARTICULAR FUNCTION/SUB-FUNCTION(S). IF A MAIN
% FUNCTION IS DISABLED, ALL SUBFUNCTIONS WILL ALSO BE DISABLED 
% 
% cfg.do_erm_and_data_sss_main=[];
% %  
%                 cfg.do_sss_hpifit=[];
                 cfg.do_sss_bad_channels=[];
                 cfg.do_sss_movementcomp_combined=[];
                 cfg.do_sss_no_movementcomp_combined=[];
                 cfg.do_sss_transform_allrunsto_singlerun=[];
                 cfg.do_sss_decimation_combined=[];
% 
   cfg.do_mne_preproc_main=[];
% 
%                  cfg.do_mne_preproc_heartbeat=[];
%                  cfg.do_erm_filtering_mne=[];
%                  cfg.do_erm_noise_covariance_mne=[];
%                  cfg.do_mne_preproc_filtered=[];
%                  cfg.do_mne_preproc_grand_average=[];
%  
     cfg.do_calc_forward_inverse_main=[];
%                 cfg.do_calc_forward=[];
%                cfg.do_calc_inverse=[];
%             
   cfg.do_epochMEG_main=[];

%% Optional Parameters  

%    cfg.start_run_from=2;
     cfg.frame_tag_checker_off=[]; 
     cfg.bad_channel_use_whole_file=[];
     cfg.no_data_decimation=1;
     cfg.no_erm_decimation=1;
    cfg.no_data_sss=1;
%    cfg.epochMEG_time=[];
    cfg.mne_preproc_filt.hpf(1)=.5;
    cfg.mne_preproc_filt.lpf(1)=40;
    cfg.mne_preproc_filt.hpf(2)=.5;  
    cfg.mne_preproc_filt.lpf(2)=144;
    cfg.removeECG_EOG=1;
   cfg.erm_sss=1;
cfg.epochMEG_event_order=[1,2];
%      cfg.clean_eog_only=[];
%      cfg.no_projector_application_on_erm=[];
%      cfg.apply_projections_only=[];
%      cfg.manually_checked_proj=[];
%      cfg.eyeballed_eog=[];
%      cfg.perform_sensitivity_map=[];
%      cfg.ecg_mag_number=1;
%      cfg.turnprojoff=[];
%      cfg.eog_manual_sign_indicator=[];
%      cfg.erm_sss=1;
%      cfg.erm_decimation=1;
%      cfg.make_png_only=[];
%      cfg.removeECG_EOG=1;
%      cfg.apply_subspace_on_mag_only=[];

%      cfg.implement_baseline_correction=[];
%      cfg.epoch_folder_name='event_13_pt5_144';
%      cfg.grand_avg_manual_filename='merge13';
%      cfg.use_specific_file_for_epoching.hpf=2;
%      cfg.use_specific_file_for_epoching.lpf=20;
%      cfg.epochMEG_cond_number_manual_set=3;  
%      cfg.use_epoching_with_nonmerge_eventfile=[];
%      cfg.grand_avg_manual_filename='event_13';
%      cfg.offset=300;
%      cfg.proj_event=1000;
%      cfg.do_epochMEG=1;
%      cfg.epochMEG_merge_events=[];  
%      cfg.epochMEG_time=[-.3,1];        % Please enter tmin & tmax in the following format:
                                         % cfg.epochMEG_time=[tmin,tmax];
                                        
%      cfg.epochMEG_event_order{1}=[1,4,2,5];
%      cfg.epochMEG_event_order{2}=[2,5];
%      cfg.newevents(1)=[90];
%      cfg.newevents(2)=[91];
%      cfg.epochMEG_eventfilename=[];
       
                                % If Input =1, eventfile name is 'ecgClean'
                                % If Input =2, eventfile name is 'ecgeogClean'
                                % If Input =3, eventfile name is 'sss'
                                % Eventfile Example Convention
                                % Eventfile=<subject_protocol_run_cfg.epochMEG_run_eventfilename_raw-eve.fif>

       
                                % If cfg.epochMEG_filename parameter is left
                                % EMPTY, then the parameter is equal to cfg.removeECG_EOG, output from do_mne_preproc_filtered
                                
        
                                
%       cfg.epochMEG_filt=[];   % cfg.epochMEG_filt/ Please set value of the filter bands here for do_epochMEG
                                % IF EMPTY, will take on values of
                                % cfg.mne_preproc_filt, whose DEFAULT
                                % FILTERING IS AT
                                % at highpass 1 Hz and lowpass of 144 Hz
                                
                                % The structure is as follows:
                                % cfg.epochMEG_filt.lpf(1)=40;
                                % cfg.epochMEG_filt.hpf(2)=2;
                                % cfg.epochMEG_filt.lpf(1)=98;
                                % cfg.epochMEG_filt.hpf(2)=0;
                                % Filter Bands set between 2-40Hz & 0-98 Hz   
                            
                                
%      cfg.start_run_from=2;


%% Parameters

 subject={
  'BEM005'};

visitNo=[2];
erm_run=[1,1];
run=[2];  
  
%% Batch script Execution
cfg.single_subject=[];
if ~isfield(cfg,'create_protocol_spreadsheet')

counter=1;
failed_subjects=cell(length(subject),1);


if isfield(cfg,'single_subject'),
   %matlabpool 8  
   for i=1:length(subject)
   % for i=1:1,
   % parfor i=1:length(subject),
  
    try
    fprintf('Processing single subject %s\n',subject{i});
    master_preprocessing_script(subject{i},visitNo(i),run(i),erm_run(i),cfg);
    %labrep_tacr(subject{i},visitNo(i))
    catch
    fprintf('Subject Failed ! %s\n',subject{i});
    failed_subjects{counter,1}= subject{i};  
    data_subjdir=[cfg.data_rootdir '/' subject{i} '/' num2str(visitNo(i)) '/'];
    movefile('*.info',data_subjdir)
    end
    end
 %   matlabpool close

else
        for i=1:length(cfg.amp_sub_folders);
            try
            fprintf('Processing subject %s\n',cfg.amp_sub_folders(i).name)
%             load(filename)
            master_preprocessing_script(cfg.amp_sub_folders(i).name,visitNo(i),run(i),erm_run(i),cfg);
           

            catch
            fprintf('Subject Failed ! %s\n',cfg.amp_sub_folders(i).name)
            failed_subjects{counter,1}= cfg.amp_sub_folders(i).name; 
            counter=counter+1;
            continue
            end
%        clear all 
       end    
end

end


clear all