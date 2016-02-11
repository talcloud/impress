%% Global Variables 

    %  Necessary for functions

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
%% Default Settings

% AS DEFAULT, ALL FUNCTIONS/SUBFUNCTIONS WILL RUN/PLEASE UNCOMMENT IN ORDER TO DISABLE A PARTICULAR FUNCTION/SUB-FUNCTION(S). IF A MAIN
% FUNCTION IS DISABLED, ALL SUBFUNCTIONS WILL ALSO BE DISABLED 
% 
 %    cfg.do_erm_and_data_sss_main=[];
%  
 %                  cfg.do_sss_hpifit=[];
 %                  cfg.do_sss_bad_channels=[];
%                   cfg.do_sss_movementcomp_combined=[];
%                 cfg.do_sss_no_movementcomp_combined=[];
%                cfg.do_sss_transform_allrunsto_singlerun=[];
%                 cfg.do_sss_decimation_combined=[];
% 
%       cfg.do_mne_preproc_main=[];
% 
         %       cfg.do_mne_preproc_heartbeat=[];
         %           cfg.do_erm_filtering_mne=[];
          %        cfg.do_erm_noise_covariance_mne=[];
           %       cfg.do_mne_preproc_filtered=[];
            %   cfg.do_mne_preproc_grand_average=[];

%       cfg.do_calc_forward_inverse_main=[];
%                 cfg.do_calc_forward=[];
%                cfg.do_calc_inverse=[];
%             
%   cfg.do_epochMEG_main=[];
%      cfg.start_run_from=2;
     cfg.frame_tag_checker_off=[];     
 %  cfg.no_data_sss=1; 
 %   cfg.no_data_decimation=1;
 %    cfg.erm_sss=1;
%     cfg.no_erm_decimation=1;
%    cfg.no_data_sss=1;
%     cfg.epochMEG_time=[];
   cfg.mne_preproc_filt.hpf(1)=.1;
    cfg.mne_preproc_filt.lpf(1)=144;
     cfg.filt.hpf(1)=.1;  
        cfg.filt.lpf(1)=144;

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
%cfg.erm_sss=1;
%cfg.erm_decimation=1;
%cfg.make_png_only=[];
%cfg.proj_event=1000;
cfg.perform_sensitivity_map=[];
cfg.implement_baseline_correction=[];
cfg.removeECG_EOG=1;
cfg.force_ecgdet_ch171=1;
cfg.use_specific_file_for_epoching.hpf=2;
cfg.use_specific_file_for_epoching.lpf=20;
cfg.ecg_mag_number=1;
cfg.ecg_grad_number=1;
%% Optional Parameters            
           cfg.do_epochMEG=1;
   % Necessary parameters: Place set values here
    
%       cfg.data_rootdir=[];      % cfg.rootdir
%       cfg.protocol=[];          % cfg.protocol
      % emo1 cfg.epochMEG_time=[-.3,1];        % Please enter tmin & tmax in the following format:
                                        % cfg.epochMEG_time=[tmin,tmax];
                                        
     % wmm     cfg.epochMEG_time=[-.4,1.2];                              
%       cfg.epochMEG_time=[-.2,2]; 
%       cfg.epochMEG_event_order{1}=[1,2,4,5];
 %     cfg.epochMEG_event_order{2}=[2,5];
 %      cfg.epochMEG_event_order{1}=[1,4];
              cfg.epochMEG_event_order(1)=[1];
cfg.epochMEG_event_order(2)=[2];
%        cfg.newevents(1)=[90];
%         cfg.epochMEG_cond_number_manual_set=3;  
%          cfg.newevents(2)=[91];
%           cfg.newevents(1)=[13];
                                % Please specify event order,
                                % for example, event=[1,4,2,5];
                                
 %      cfg.epochMEG_merge_events=[];                        
                
   % Optional parameters:                           
      cfg.epochMEG_baseline=[]; % Please enter tmin & tmax in the following format:
                                % cfg.epochMEG_baseline=[bmin bmax]
                                % If EMPTY, BASELINE CORRECTION WILL NOT BE
                                % IMPLEMENTED
                                
 
      
  
     
                                
                                % Filename Example Convention
                                
                                % Filename=<subject_protocol_run_(insert-highpass-setting)-(insert-lowpass-setting)fil_raw.fif>
                                
                                % If cfg.epochMEG_filename parameter is left
                                % EMPTY, then the parameter is equal to cfg.fil_fif, output from do_mne_preproc_filtered
       
       cfg.epochMEG_eventfilename=[];
       
                                % If Input =1, eventfile name is 'ecgClean'
                                % If Input =2, eventfile name is 'ecgeogClean'
                                % If Input =3, eventfile name is 'sss'
                                % Eventfile Example Convention
                                % Eventfile=<subject_protocol_run_cfg.epochMEG_run_eventfilename_raw-eve.fif>

       
                                % If cfg.epochMEG_filename parameter is left
                                % EMPTY, then the parameter is equal to cfg.removeECG_EOG, output from do_mne_preproc_filtered
                                
        
                                
        cfg.epochMEG_filt=[];   % cfg.epochMEG_filt/ Please set value of the filter bands here for do_epochMEG
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
     cfg.frame_tag_checker_off=[];     
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

% Subjects
    % If multiple
     %   cfg.amp_sub_folders=dir(strcat(cfg.data_rootdir,'/*0*'));
     
    % If single
        
 %fmmn
%    subject={
%        'AC065';
%     '008801';
%      '009101';
%      'AC005';
%      '018301';
%      '063201';
%    %  '063901';
%      '056901';
%      '054602';
%     'AC005';
% % '048901';
% % '042901';
% % '051901';
%  %'002901';
%  %'058501';
% };

%visitNo=[1;2;1;1;1;1;1;1];
%erm_run=ones(70,1);
%run=[1;1;1;1;1;1;1;1;1];
% subject={'007501';
%     
% '008801';
% '005801';
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
% };
%  visitNo=[1;2;1;3;2;2;1;1;2;2;1;2;1;1;1;2;1;1;1;1;1;1;1;1;2;1;1;1;2;2;2;2;1;1;1;1;1;1;1;1;1;1;1;1;1;1];
%  erm_run=ones(70,1);
%  run=[2;2;2;2;ones(42,1)];
 cfg.removeECG_EOG=1;
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
% 'AC077';'AC042';'AC069';'014002';'018301';'014901';'012301';'014001';'AC050';'AC063';'AC065';'043202';'012301';'002901';'050901'};
%subject={'AC015';'005801';'007501';'009101';'009102';'009901';'012002';'012301';'013703';'015001';'027202';'011202';'010302';'010302';'008801';'014001';'014002';'014901';'015601';'030801';'055201';'007501';'026801';'AC017';'AC019';'AC021';'046503';'018201';'005901';'011302';'016201';'017801';'021301';'058501';'059601'};

% visitNo=[ones(35,1);2;2;2;2;2;2;2;2;1;3;2;1];
% erm_run=ones(70,1);
 %run=ones(70,1);
% subject={'007501';
%     
% '008801';
% '005801';
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
%  visitNo=[1;2;1;3;2;2;1;1;2;1;1;2;1;1;1;2;1;1;1;1;1;1;1;1;2;1;1;1;2;2;2;2;1;1;1;1;1;1;1;1;1;1;1;1;1;1  ; 2;1;1;1;1;1;1;1;1;1];
  erm_run=ones(70,1);
%  run=[2;1;2;2;ones(52,1)];

subject={
 %'AC065';
 '042201';
 %'027202';
 %'011301';
 %'058501';
 %'009101';
 %'AC058';
 };
visitNo=[1;1;1;1];
run=[1;1;1;1];

 cfg.removeECG_EOG=1;

cfg.single_subject=[];
        % If performing ERM, indicates # of erm runs per visitN0...Almost always=1; If different for different subjects, can be a matrix
        % If multiple dimensions, must match length(cfg.amp_sub_folders)
     %   erm_run=ones(70,1);
        % runs of the data to be processed. If different for different subjects, can be a matrix
         % If multiple dimensions, must match length(cfg.amp_sub_folders)
     %   run=ones(70,1);
         %run=[3,3];
        % visitNo of each of the subject(s). if multiple, can be a matrix
        % If multiple dimensions, must match length(cfg.amp_sub_folders) 
        %visitNo=[ones(44,1);2;2;2;2;2;2;2;2];
       %visitNo=[ones(13,1);2;2];
     % visitNo=[1;2];
%         filename=strcat('Batch_intital_parameters_',cfg.protocol,'cfg');
%         save(filename,'cfg','visitNo','run','erm_run');

% visitNo=[ones(45,1);2;2;2;2;2;2;2;2;1;3;2;1;2];


%% Batch script Execution

if ~isfield(cfg,'create_protocol_spreadsheet')

counter=1;
failed_subjects=cell(length(subject),1);


if isfield(cfg,'single_subject'),
    % for i=2
   for i=1:length(subject),
    %parfor i=1:length(subject)
    %    matlabpool 3
    try
    fprintf('Processing single subject %s\n',subject{i});
     master_preprocessing_script(subject{i},visitNo(i),run(i),erm_run(i),cfg);

    catch
    fprintf('Subject Failed ! %s\n',subject{i});
    failed_subjects{counter,1}= subject{i};   
    
    end
    %matlabpool close
    end

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
% visitNo=[ones(44,1);2;2;2;2;2;2;2;2];
% cfgsheet=[];
% spreadsheet_start=2;
% for i=1:length(subject1)
%      try
% [cfgsheet,spreadsheet_start]=do_output_protocol_chart(subject1{i},visitNo(i),run(i),cfgsheet,cfg,spreadsheet_start);
%      catch
%      continue
%      end
% end
% cd(cfg.data_rootdir);
% c=clock;
% filename=strcat(cfg.protocol,'_spreadsheet_',datestr(c),'.txt');
% cell2csv(filename, cfgsheet.output_fields);


clear all