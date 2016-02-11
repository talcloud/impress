function [subj,visitNo,run,cfg]=do_erm_main(subj,visitNo,run,cfg)
if ~isfield(cfg,'do_master_preprocessor_activation')
    cfg.rootdir=('/autofs/space/marvin_001/users/MEG/scripts/kenet/ml/curr/Santosh/SVN/Test');
end
subjdir=[cfg.rootdir '/' subj '/' num2str(visitNo) '/'];
cd(subjdir);
diary(strcat(subj,'_erm_main_.info'));
diary on

%% config file
    % root functions
            %     cfg.do_erm_SSS=[];
            %     cfg.do_erm_decimation=[];
            %     cfg.do_erm_filtering=[];
            %     cfg.do_erm_noise_covariance=[];


    % Necessary for sub-functions: Place set values here
    
%       cfg.rootdir=[];           % cfg.rootdir
%       cfg.covdir=[];            % cfg.covdir
%       cfg.sss=[];               % cfg.sss / Please set to true(1) if sss HAS ALREADY BEEN DONE
%       cfg.filt=[];              % cfg.filt/ Please set filter bands here for do_erm_filtering
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
      
%% Default settings                                
if ~isfield(cfg,'do_master_preprocessor_activation')
% current directory
cfg.covdir = ('/autofs/space/calvin_001/marvin/1/users/MEG/descriptors/cov_templates/');
addpath('/autofs/space/marvin_001/users/MEG/scripts/kenet/ml/curr/Santosh/SVN/');

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
end
%% Actions
fprintf('Starting Specified Actions %s\n',subj); 


if (cfg.do_erm_SSS)
fprintf('Starting erm_sss %s\n',subj);    
cfg=do_erm_SSS(subj,visitNo,run,cfg);
fprintf('Complete ! %s\n',subj); 
end


if (cfg.do_erm_decimation)
fprintf('Starting erm_decimation %s\n',subj);   
cfg=do_erm_decimation(subj,visitNo,run,cfg);
fprintf('Complete ! %s\n',subj);
end


if (cfg.do_erm_filtering)
fprintf('Starting erm_filtering %s\n',subj);    
[cfg]=do_erm_filtering(subj,visitNo,run,cfg); 
fprintf('Complete ! %s\n',subj);
end

if (cfg.do_erm_noise_covariance)
fprintf('Starting erm_noise_covariance %s\n',subj);    
[cfg]=do_erm_noise_covariance(subj,visitNo,run,cfg);

fprintf('Complete ! %s\n',subj);
end

diary off

filename=strcat(subj,'_erm');
save(filename,'cfg','visitNo','run');