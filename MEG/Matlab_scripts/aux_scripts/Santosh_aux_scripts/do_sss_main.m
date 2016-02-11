function [subj,visitNo,run,cfg]=do_sss_main(subj,visitNo,run,cfg)
if ~isfield(cfg,'do_master_preprocessor_activation')
    cfg.rootdir=('/autofs/space/marvin_001/users/MEG/scripts/kenet/ml/curr/Santosh/SVN/Test/SSS_Test');
end
subjdir=[cfg.rootdir '/' subj '/' num2str(visitNo) '/'];
cd(subjdir);
diary(strcat(subj,'_sss_main_.info'));
diary on
%% config file

    % Necessary for the main functions
%     cfg.do_sss_hpifit=[];
%     cfg.do_sss_bad_channels=[];
%     cfg.do_sss_movement_comp=[];
%     cfg.do_sss_without_movement_comp=[];
%     cfg.do_sss_transform_allrunsto_singlerun=[];
%     cfg.do_sss_decimation=[];
   % Necessary for sub-functions: Place set values here
    
%       cfg.rootdir=[];           % cfg.rootdir
%       cfg.covdir=[];            % cfg.covdir
%       cfg.protocol=[];          % cfg.protocol
%% Default settings                                
if ~isfield(cfg,'do_master_preprocessor_activation')
cfg.covdir = ('/autofs/space/marvin_001/users/MEG/descriptors/ave_templates/');
cfg.protocol='fmm';
% current directories
addpath('/autofs/space/marvin_001/users/MEG/scripts/kenet/ml/curr/Santosh/SVN/');
addpath('/autofs/space/marvin_001/users/MEG/scripts/kenet/ml/curr/Santosh/SVN/Private_SSS')
%
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
end    
%% Actions

fprintf('Starting Specified Actions %s\n',subj); 


if (cfg.do_sss_hpifit)
fprintf('Starting sss_hpifit %s\n',subj);    
[cfg]=do_sss_hpifit(subj,visitNo,run,cfg);
fprintf('Complete ! %s\n',subj); 
end


if (cfg.do_sss_bad_channels)
fprintf('Starting sss_bad_channels %s\n',subj);   
[cfg]=do_sss_bad_channels(subj,visitNo,run,cfg);
fprintf('Complete ! %s\n',subj);
end


if (cfg.do_sss_movement_comp)
fprintf('Starting sss_movement_comp %s\n',subj);    
[cfg]=do_sss_movement_comp(subj,visitNo,run,cfg);
fprintf('Complete ! %s\n',subj);
end

if (cfg.do_sss_without_movement_comp)
fprintf('Starting sss_without_movement_comp %s\n',subj);    
[cfg]= do_sss_without_movement_comp(subj,visitNo,run,cfg);
fprintf('Complete ! %s\n',subj);
end

if (cfg.do_sss_transform_allrunsto_singlerun)
fprintf('Starting to Transform multiple runs into a single run %s\n',subj);    
[cfg]=do_sss_transform_allrunsto_singlerun(subj,visitNo,run,cfg); 
fprintf('Complete ! %s\n',subj);
end

if (cfg.do_sss_decimation)
fprintf('Starting to Decimate SSS %s\n',subj);    
do_sss_decimation(subj,visitNo,run,cfg)
fprintf('Complete ! %s\n',subj);
end

filename=strcat(subj,'_sss');
save(filename,'cfg','visitNo','run');
diary off

