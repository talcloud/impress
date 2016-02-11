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
%% Default Settings

% AS DEFAULT, ALL FUNCTIONS/SUBFUNCTIONS WILL RUN/PLEASE UNCOMMENT IN ORDER TO DISABLE A PARTICULAR FUNCTION/SUB-FUNCTION(S). IF A MAIN
% FUNCTION IS DISABLED, ALL SUBFUNCTIONS WILL ALSO BE DISABLED 
% 
        cfg.do_erm_and_data_sss_main=[];
%  
                   cfg.do_sss_hpifit=[];
                   cfg.do_sss_bad_channels=[];
                   cfg.do_sss_movementcomp_combined=[];
                  cfg.do_sss_no_movementcomp_combined=[];
                 cfg.do_sss_transform_allrunsto_singlerun=[];
%                 cfg.do_sss_decimation_combined=[];
% 
%       cfg.do_mne_preproc_main=[];
% 
                  cfg.do_mne_preproc_heartbeat=[];
%                       cfg.do_erm_filtering_mne=[];
%                       cfg.do_erm_noise_covariance_mne=[];
%                   cfg.do_mne_preproc_filtered=[];
%                    cfg.do_mne_preproc_grand_average=[];
  
%        cfg.do_calc_forward_inverse_main=[];
%                 cfg.do_calc_forward=[];
%                cfg.do_calc_inverse=[];
%             
%    cfg.do_epochMEG_main=[];
%      cfg.start_run_from=2;
     cfg.frame_tag_checker_off=[];     
%    cfg.no_data_sss=1; 
%    cfg.no_data_decimation=1;
%      cfg.erm_sss=1;
%     cfg.no_erm_decimation=1;
%    cfg.no_data_sss=1;
%     cfg.epochMEG_time=[];
   cfg.mne_preproc_filt.hpf(1)=.5;
    cfg.mne_preproc_filt.lpf(1)=144;
     cfg.filt.hpf(1)=.5;  
        cfg.filt.lpf(1)=144;
 %       cfg.clean_eog_only=[];
 %       cfg.no_projector_application_on_erm=[];
cfg.apply_projections_only=[];
   cfg.manually_checked_proj=[];
 %    cfg.eyeballed_eog=[];
% cfg.turnprojoff=[];
 %cfg.eog_manual_sign_indicator=[];
cfg.erm_sss=1;
cfg.erm_decimation=1;
cfg.make_png_only=[];
cfg.perform_sensitivity_map=[];
cfg.use_specific_file_for_epoching.hpf=2;
cfg.use_specific_file_for_epoching.lpf=20;
%% Optional Parameters            
           cfg.do_epochMEG=1;
   % Necessary para meters: Place set values here
    
%       cfg.data_rootdir=[];      % cfg.rootdir
%       cfg.protocol=[];          % cfg.protocol
      % emo1 cfg.epochMEG_time=[-.3,1];        % Please enter tmin & tmax in the following format:
                                        % cfg.epochMEG_time=[tmin,tmax];
                                        
     % wmm     cfg.epochMEG_time=[-.4,1.2];                              
%       cfg.epochMEG_time=[-.2,2]; 
      cfg.epochMEG_event_order{1}=[1,4];
      cfg.epochMEG_event_order{2}=[2,5];
  %  cfg.epochMEG_cond_number_manual_set=3;  
  % cfg.grand_avg_manual_filename='event_13'; 
        cfg.newevents(1)=[90];
          cfg.newevents(2)=[91];
%           cfg.newevents(3)=[13];
                                % Please specify event order,
                                % for example, event=[1,4,2,5];
                                
      cfg.epochMEG_merge_events=[];                        
                
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
        
 % tacr   
%  subject={'014002';'041901';'AC054';'AC058';'042301';'AC069';'AC003'};
%subject={'AC054';'AC072';'AC073';'AC074';'AC053';'AC067';'040701';'051301';'007501';'013001';'038301';'010401';'010001';'017801';'042201';'AC069';'012301';'014001';'AC065'};
%subject={'AC065'}
%  subject={
%    
%    '007501';
%    '010001';
%    '012002';
%    '032902';
%    '038202';
%    '038301';
%    '038502';
%    '040701';
%    '041901';
%    '042201';
%    '042401';
%    '043202';
%    '051301';
%    '051901';
%    '056601';
%    '063401';
%    'AC003';
%    'AC013';
%    'AC046';
%    'AC047';
%    'AC056';
%    'AC058';
%    'AC061';
%    'AC067';
%    'AC068';
%    'AC069';
%    'AC070';
%    'AC077';
%    '002901';
%    'AC063';
%    'AC065';
%    'AC047';
%    'AC050';
%    '054401_rescan';
%    '014001';
%    '014002';
%    '014901';
%    '012301';
%  };
%          visitNo=[ones(28,1);2;2;2;2;2;2;2;2;2;3];
subject={
    '009101'
    '010401'
    '014002'
    '017801'
    '018301'
    '032901'
    '040401'
    '050901'
    'AC053'
    'AC054'
    'AC071'
    'AC072'
    'AC073'
    'AC075'
    'AC076'
    };
         visitNo=[1;1;2;1;2;1;1;1;1;1;1;1;1;1;1;];

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
 %        visitNo=[ones(45,1);2;2;2;2;2;2;2;2;1;3;2;1;2];

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
  %  parfor i=40:length(subject),
     for i=1:length(subject),
  
    
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