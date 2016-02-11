function [subj,visitNo,run,cfg]=do_erm_and_data_sss_main(subj,visitNo,run,erm_run,cfg)
%% Global variables
if ~isfield(cfg,'data_rootdir'),
error('Please enter a root directory in sub-structure cfg.data_rootdir: Thank you');
end
%%

data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
cd(data_subjdir);
diary(strcat(subj,'_erm_and_data_sss_main_.info'));
diary on
% current directories
addpath('/autofs/cluster/transcend/Santosh/SVN_v1/');
addpath('/autofs/cluster/transcend/Santosh/SVN_v1/Private_SSS');
%% Main config file

    % root functions
 

%     cfg.do_sss_hpifit=[];
%     cfg.do_sss_bad_channels=[];
%     cfg.do_sss_movementcomp_combined=[];
%     cfg.do_sss_no_movementcomp_combined=[];/autofs/space/marvin_001/users/MEG/scripts/kenet/ml/curr/Santosh/SVN
%     cfg.do_sss_transform_allrunsto_singlerun=[];
%     cfg.do_sss_decimation_combined=[];
%     cfg.do_erm_filtering=[];
%     cfg.do_erm_noise_covariance=[];
%% ERM config file


    % Necessary for sub-functions: Place set values here
    
%       cfg.erm_rootdir=[];     % cfg.erm_rootdir
%       cfg.covdir=[];          % cfg.covdir
%       cfg.erm_sss=[];         % cfg.erm_sss / Please set to true(1) if erm_sss HAS ALREADY BEEN DONE
%       cfg.erm_decimation=[];  % cfg.erm_decimation / Please set to true(1) if erm_decimation HAS ALREADY BEEN DONE
%       cfg.filt=[];            % cfg.filt/ Please set filter bands here for do_erm_filtering
                                % IF EMPTY, DEFAULT FILTERING WILL BE ACCOMPLISHED
                                % at highpass 1 Hz and lowpass of 144 Hz
                                % The structure is as follows:
                                
                                % cfg.filt.lpf(1)=40;
                                % cfg.filt.hpf(2)=2;
                                % cfg.filt.lpf(1)=98;
                                % cfg.filt.hpf(2)=0;
                                
                                % Filter Bands set between 2-40Hz & 0-98 Hz
      
      
                                
%       cfg.noise_cov=[];         % cfg.noise/ Please set filter bands here for do_erm_noise_covariance
                                % IF EMPTY, VALUES FROM CFG.FILT WILL BE USED
                                % IF CFG.FILT IS ALSO EMPTY, then DEFAULT
                                % VALUES AT HIGHPASS 1 HZ & LOWPASS OF 144 HZ
                                % The structure is as follows:
                                
                                % cfg.noise.lpf(1)=144;
                                % cfg.noise.hpf(2)=1;
                                % cfg.noise.lpf(1)=98;
                                % cfg.noise.hpf(2)=0;
                                
                                % Filter Bands set between 1-144Hz & 0-98 Hz
                                
%       cfg.without_movement_option=[];
      
                                % Set this to true if manually want to
                                % perform sss without movement compensation
                                
%% SSS config file

% Necessary for SSS sub-functions: Place set values here
    
%       cfg.data_rootdir=[];      % cfg.data_rootdir
%       cfg.covdir=[];            % cfg.covdir
%       cfg.protocol=[];          % cfg.protocol


%% Default SSS settings                                

if ~isfield (cfg,'current')
    if ~isfield(cfg,'do_sss_hpifit')
        cfg.do_sss_hpifit=1;
        fprintf('Performing sss_hpifit %s\n',subj);
    else
        cfg.do_sss_hpifit=0;
        fprintf('Not Performing sss_hpifit %s\n',subj);
    end
    
    if ~isfield(cfg,'do_sss_bad_channels')
        cfg.do_sss_bad_channels=1;
        fprintf('Performing sss_bad_channels %s\n',subj);
    else
        cfg.do_sss_bad_channels=0;
        fprintf('Not Performing sss_bad_channels %s\n',subj);
    end
   
    if ~isfield(cfg,'do_sss_movementcomp_combined')
        cfg.do_sss_movementcomp_combined=1;
        fprintf('Performing sss_movement_comp, if needed %s\n',subj);  
    else
        cfg.do_sss_movementcomp_combined=0;
        fprintf('Not Performing sss_movement_comp, if needed %s\n',subj);
    end
 
    if ~isfield(cfg,'do_sss_no_movementcomp_combined')
        cfg.do_sss_no_movementcomp_combined=1;
        fprintf('Performing sss_without_movement_comp, if needed %s\n',subj);   
    else
        cfg.do_sss_no_movementcomp_combined=0;
        fprintf('Not Performing sss_without_movement_comp, if needed %s\n',subj); 
    end
   
    if ~isfield(cfg,'do_sss_transform_allrunsto_singlerun')
        cfg.do_sss_transform_allrunsto_singlerun=1;
        fprintf('Performing Transformation of multiple runs into a single run, if needed %s\n',subj);  
    else
        cfg.do_sss_transform_allrunsto_singlerun=0;
        fprintf('Not Performing Transformation of multiple runs into a single run, if needed %s\n',subj);  
    end
    
    if ~isfield(cfg,'do_sss_decimation_combined')
        cfg.do_sss_decimation_combined=1;
        fprintf('Performing decimation  %s\n',subj);  
    else
        cfg.do_sss_decimation_combined=0;
        fprintf('Not Performing decimation  %s\n',subj); 
    end
    
%     if ~isfield(cfg,'do_erm_filtering')
%         cfg.do_erm_filtering=1;
%         fprintf('Performing erm_filtering  %s\n',subj);
%     else
%         cfg.do_erm_filtering=0;
%         fprintf('Not Performing erm_filtering  %s\n',subj);
%     end
%  
%     if ~isfield(cfg,'do_erm_noise_covariance')
%         cfg.do_erm_noise_covariance=1;
%         fprintf('Performing erm_noise_covariance  %s\n',subj);
%     else
%         cfg.do_erm_noise_covariance=0;
%         fprintf('Not Performing erm_noise_covariance  %s\n',subj);
%     end
end   
%% Actions
fprintf('Starting Specified Actions %s\n',subj); 

if (cfg.do_sss_hpifit)
    try
        fprintf('Starting sss_hpifit %s\n',subj);    
        [cfg]=do_sss_hpifit(subj,visitNo,run,cfg);
        fprintf('Complete ! %s\n',subj);

    catch ME
        cfg.current=ME.stack.name;
        filename=strcat(subj,'_do_sss_hpifit_error_cfg');
        save(filename,'cfg','visitNo','run','erm_run','subj','ME');
   
    end
end


if (cfg.do_sss_bad_channels)
    try
        fprintf('Starting sss_bad_channels %s\n',subj);   
        [cfg]=do_sss_bad_channels(subj,visitNo,run,cfg);
        fprintf('Complete ! %s\n',subj);

    catch ME
        cfg.current=ME.stack.name;
        filename=strcat(subj,'_do_sss_bad_channels_error_cfg');
        save(filename,'cfg','visitNo','run','erm_run','subj','ME');
   
    end    
end


if (cfg.do_sss_movementcomp_combined)
    try
        fprintf('Starting sss_movement_comp %s\n',subj);    
        [cfg]=do_sss_movementcomp_combined(subj,visitNo,run,erm_run,cfg);
        fprintf('Complete ! %s\n',subj);

    catch ME
        cfg.current=ME.stack.name;
        filename=strcat(subj,'_do_sss_movementcomp_combined_error_cfg');
        save(filename,'cfg','visitNo','run','erm_run','subj','ME');
    
    end
end
if (cfg.do_sss_no_movementcomp_combined)
    try
        fprintf('Starting sss_without_movement_comp %s\n',subj);    
        [cfg]= do_sss_no_movementcomp_combined(subj,visitNo,run,erm_run,cfg);
        fprintf('Complete ! %s\n',subj);

    catch ME
        cfg.current=ME.stack.name;
        filename=strcat(subj,'_do_sss_no_movementcomp_combined_error_cfg');
        save(filename,'cfg','visitNo','run','erm_run','subj','ME');
    
    end
end


if (cfg.do_sss_transform_allrunsto_singlerun)
    try
        fprintf('Starting to Transform multiple runs into a single run %s\n',subj);    
        [cfg]=do_sss_transform_allrunsto_singlerun(subj,visitNo,run,cfg); 
        fprintf('Complete ! %s\n',subj);

    catch ME
        cfg.current=ME.stack.name;
        filename=strcat(subj,'_do_sss_transform_allrunsto_singlerun_error_cfg');
        save(filename,'cfg','visitNo','run','erm_run','subj','ME');
 
    end
    
end

if (cfg.do_sss_decimation_combined)
   try
        fprintf('Starting erm_decimation %s\n',subj);   
        [cfg]=do_sss_decimation_combined(subj,visitNo,run,erm_run,cfg);
        fprintf('Complete ! %s\n',subj);

   catch ME
        cfg.current=ME.stack.name;
        filename=strcat(subj,'_do_sss_decimation_combined_error_cfg');
        save(filename,'cfg','visitNo','run','erm_run','subj','ME'); 

   end
       
end
% if (cfg.do_erm_filtering)
%     try
%         fprintf('Starting erm_filtering %s\n',subj);    
%         [cfg]=do_erm_filtering(subj,visitNo,erm_run,cfg); 
%         fprintf('Complete ! %s\n',subj);
% 
%     catch ME
%         cfg.current=ME.stack.name;
%         filename=strcat(subj,'_do_erm_filtering_error_cfg');
%         save(filename,'cfg','visitNo','run','erm_run','subj','ME');  
%   
%     end
% end
% 
% if (cfg.do_erm_noise_covariance)
%     try
%         fprintf('Starting erm_noise_covariance %s\n',subj);    
%         [cfg]=do_erm_noise_covariance(subj,visitNo,erm_run,cfg);
%         fprintf('Complete ! %s\n',subj);
% 
%     catch ME
%         cfg.current=ME.stack.name;
%         filename=strcat(subj,'_do_erm_noise_covariance_error_cfg');
%         save(filename,'cfg','visitNo','run','erm_run','subj','ME');
%     
%     end
% end
% 







diary off

filename=strcat(subj,'_sss_cfg');
save(filename,'cfg','visitNo','run','erm_run','subj');