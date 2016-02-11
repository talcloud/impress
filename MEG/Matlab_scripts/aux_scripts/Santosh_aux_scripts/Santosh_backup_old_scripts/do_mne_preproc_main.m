function [subj,visitNo,run,cfg]=do_mne_preproc_main(subj,visitNo,run,erm_run,cfg)
%% Global variables
if ~isfield(cfg,'data_rootdir'),
error('Please enter a root directory in sub-structure cfg.data_rootdir: Thank you');
end
%%
% current directories
addpath('/autofs/space/marvin_001/users/MEG/scripts/kenet/ml/curr/Santosh/SVN/');
addpath('/autofs/space/marvin_001/users/MEG/scripts/kenet/ml/curr/Santosh/SVN/Private_Mne_Preproc/')
data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
cd(data_subjdir);
diary(strcat(subj,'_mne_preproc_main_.info'));
diary on
%% config file

    % Necessary for the main functions
%    1) cfg.do_mne_preproc_heartbeat=[];
    
%        cfg.removeECG_EOG=[];  % Please set removeECG_EOG here. 
                                % 0=no ECG or EOG removed
                                % 1=remove ECG only
                                % 2=remove ECG & EOG
                                % If no value is given, 
                                % cfg.removeECG_EOG DEFAULT is set to 
                                % to remove both ECG and EOG!
                                % The structure is as follows: 
                                
    
    
    
%    2) cfg.do_mne_preproc_filtered=[];
    
%      cfg.mne_preproc_filt=[]; % cfg.filt/ Please set filter bands here for do_mne_preproce_filtered
                                % IF EMPTY, DEFAULT FILTERING WILL BE ACCOMPLISHED
                                % at highpass 1 Hz and lowpass of 144 Hz
                                
                                % The structure is as follows:
                                % cfg.mne_preproc_filt.lpf(1)=40;
                                % cfg.mne_preproc_filt.hpf(2)=2;
                                % cfg.mne_preproc_filt.lpf(1)=98;
                                % cfg.mne_preproc_filt.hpf(2)=0;
                                % Filter Bands set between 2-40Hz & 0-98 Hz
     
                                 
                                
                                
    %----------------------------------------------------------------------
 
    
    
%    3) cfg.do_mne_preproc_grand_average=[];
    
%        cfg.removeECG_EOG=[];    % Please set removeECG_EOG here. 
                                % 0=no ECG or EOG removed
                                % 1=remove ECG only
                                % 2=remove ECG & EOG
                                % If no value is given, 
                                % cfg.removeECG_EOG DEFAULT is set to 
                                % to remove both ECG and EOG!
                                % The structure is as follows: 
                                % if cfg.removeECG_EOG is EMPTY, is set to 
                                % to remove both ECG and EOG!
                              
    
   % Necessary for sub-functions: Place set values here
    
%     cfg.data_rootdir=[];      % cfg.data_rootdir
%     cfg.protocol_covdir=[];   % cfg.protocol_covdir
%     cfg.protocol=[];          % cfg.protocol
%% Default settings                                

if ~isfield (cfg,'current')
    if ~isfield(cfg,'do_mne_preproc_heartbeat')
        cfg.do_mne_preproc_heartbeat=1;
        fprintf('Performing mne preproc heartbeat %s\n',subj);   
    else
        cfg.do_mne_preproc_heartbeat=0;
        fprintf('Not Performing mne preproc heartbeat %s\n',subj);
    end
    
    
    if ~isfield(cfg,'do_erm_filtering_mne')
        cfg.do_erm_filtering=1;
        fprintf('Performing erm_filtering  %s\n',subj);
    else
        cfg.do_erm_filtering=0;
        fprintf('Not Performing erm_filtering  %s\n',subj);
    end
 
    if ~isfield(cfg,'do_erm_noise_covariance_mne')
        cfg.do_erm_noise_covariance=1;
        fprintf('Performing erm_noise_covariance  %s\n',subj);
    else
        cfg.do_erm_noise_covariance=0;
        fprintf('Not Performing erm_noise_covariance  %s\n',subj);
    end
    
    
    
    
    
    if ~isfield(cfg,'do_mne_preproc_filtered')
        cfg.do_mne_preproc_filtered=1;
        fprintf('Performing mne_preproc_filtering %s\n',subj);
    else
        cfg.do_mne_preproc_filtered=0;
        fprintf('Not Performing mne_preproc_filtering %s\n',subj);
    end
   
    if ~isfield(cfg,'do_mne_preproc_grand_average')
        cfg.do_mne_preproc_grand_average=1;
        fprintf('Performing Grand average, %s\n',subj); 
    else
        cfg.do_mne_preproc_grand_average=0;
        fprintf('Performing Grand average, %s\n',subj);
    end
 
end         
%% Actions

fprintf('Starting Specified Actions %s\n',subj); 


if (cfg.do_mne_preproc_heartbeat)
    try
        fprintf('Starting mne_prproc heartbeat %s\n',subj);    
        [cfg]=do_mne_preproc_heartbeat(subj,visitNo,run,cfg);
        fprintf('Complete ! %s\n',subj);
 
    catch ME
        cfg.current=ME.stack.name;
        filename=strcat(subj,'_do_mne_preproc_heartbeat_error_cfg');
        save(filename,'cfg','visitNo','run','subj','ME');
    end
end


if (cfg.do_erm_filtering)
    try
        fprintf('Starting erm_filtering %s\n',subj);    
        [cfg]=do_erm_filtering(subj,visitNo,erm_run,cfg); 
        fprintf('Complete ! %s\n',subj);

    catch ME
        cfg.current=ME.stack.name;
        filename=strcat(subj,'_do_erm_filtering_error_cfg');
        save(filename,'cfg','visitNo','run','erm_run','subj','ME');    
    end
end

if (cfg.do_erm_noise_covariance)
    try
        fprintf('Starting erm_noise_covariance %s\n',subj);    
        [cfg]=do_erm_noise_covariance(subj,visitNo,erm_run,cfg);
        fprintf('Complete ! %s\n',subj);

    catch ME
        cfg.current=ME.stack.name;
        filename=strcat(subj,'_do_erm_noise_covariance_error_cfg');
        save(filename,'cfg','visitNo','run','erm_run','subj','ME'); 
    end
end




if (cfg.do_mne_preproc_filtered)
    try
        fprintf('Starting mne_preproc_filtered %s\n',subj);   
        [cfg]=do_mne_preproc_filtered(subj,visitNo,run,cfg);
        fprintf('Complete ! %s\n',subj);

    catch ME
        cfg.current=ME.stack.name;
        filename=strcat(subj,'_do_mne_preproc_filtered_error_cfg');
        save(filename,'cfg','visitNo','run','subj','ME');
    end   
end


if (cfg.do_mne_preproc_grand_average)
    try
        fprintf('Starting mne_preproc_grand_avg %s\n',subj);    
        [cfg]=do_mne_preproc_grand_average(subj,visitNo,run,cfg);
        fprintf('Complete ! %s\n',subj);

    catch ME
        cfg.current=ME.stack.name;
        filename=strcat(subj,'_do_mne_preproc_grand_average_error_cfg');
        save(filename,'cfg','visitNo','run','subj','ME');
    end    
end


      
filename=strcat(subj,'_mne_preproc_cfg');
save(filename,'cfg','visitNo','run','subj');
diary off
