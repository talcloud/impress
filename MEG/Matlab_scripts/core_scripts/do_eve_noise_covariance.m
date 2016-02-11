
function [cfg]=do_eve_noise_covariance(subj,visitNo,run,cfg)

% Generates filtered variants of SSS data of all subjects for a
% paradigm. Assumes default subject list.
%--------------------------------------
% Dr Engr. Sheraz Khan,  M.Eng, Ph.D.
% Engr. Nandita Shetty,  MS.
%
% Modified By Santosh Ganesan
% Date:   June 15, 2011

% Modified By Fahimeh Mamashli, Ph.D.
% Date:   January 07, 2014
%--------------------------------------

%   Generates Noise Covariance Matrix
% Local variables:
%   1) subj = subject name
%   2) visitNo = visit number
%   3) run = run number
%   4) cfg = data structure with global variables
%   
%  
% PARAMETERS:

% If you want the following files: highpass 1, lowpass 144; highpass 2, lowpass 25; highpass 1, lowpass 40
% cfg.mne_preproc_filt.hpf(1)=1;
% cfg.mne_preproc_filt.lpf(1)=144
% cfg.mne_preproc_filt.hpf(2)=2;
% cfg.mne_preproc_filt.lpf(2)=25;
% cfg.mne_preproc_filt.hpf(3)=1;
% cfg.mne_preproc_filt.lpf(3)=40
% cfg.mne_preproc_filt: if field is not set or empty, filtering will occur with the following parameters:
% cfg.mne_preproc_filt.hpf(1)=1;
% cfg.mne_preproc_filt.lpf(1)=144;
% cfg.mne_preproc_filt.hpf(2)=.1;
% cfg.mne_preproc_filt.lpf(2)=25;
% cfg.mne_preproc_filt.hpf(3)=1;
% cfg.mne_preproc_filt.lpf(3)=40;
% cfg.mne_preproc_filt.hpf(4)=.1;
% cfg.mne_preproc_filt.lpf(4)=144;
% cfg.mne_preproc_filt.hpf(5)=.3;
% cfg.mne_preproc_filt.lpf(5)=40;

% a desciptor file for the covariance needs to be provided. 
% cfg.covdescname


%% Error Check
if isfield(cfg,'error_mode')
    
    file= exist(strcat(subj,'_do_eve_noise_covariance_error_cfg.mat'),'file');
    if file~=2
        return
    else
        delete(file);
    end
end
%% Global Variables

if ~isfield(cfg,'data_rootdir'),
    error('Please enter a root directory in sub-structure cfg.data_rootdir: Thank you');
end

if ~isfield(cfg,'protocol'),
    error('Please enter a protocol name in sub-structure cfg.protocol: Thank you');
end

if ~isfield(cfg,'covdir')
    error('Please enter a covariance directory in sub-structure cfg.covdir: Thank you');
end

if ~isfield(cfg,'covdescname')
    error('Please enter the covariance descriptor name: Thank you');
end

if ~isfield(cfg,'mne_preproc_filt') || isempty(cfg.mne_preproc_filt)
    cfg.filt=[];
else
    cfg.filt=cfg.mne_preproc_filt;
end

%     if isfield(cfg,'erm_filt')
%             cfg.filt=cfg.erm_filt;
%     end

if ~isfield(cfg,'start_run_from')
    cfg.start_run_from=run; % field allows flexibility to start pre-processing not from run 1
end

data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
cd(data_subjdir);
diary(strcat(subj,'_eve_noise_covariance_',datestr(clock),'.info')); % Starting Diary
diary on


%% Computation of noise  files.MM


cfg.noise_cov=cfg.filt;

if isempty(cfg.noise_cov),
    
    % SETS DEFAULT FILTERING WITH FOLLOWING SETTINGS
    % 1-144  HZ
    % .1-25  HZ
    %  1-40  Hz
    % .1-144 Hz
    % .3-40  Hz
    
    cfg.noise_cov.hpf(1)=1;
    cfg.noise_cov.lpf(1)=144;
    cfg.noise_cov.hpf(2)=.1;
    cfg.noise_cov.lpf(2)=25;
    cfg.noise_cov.hpf(3)=1;
    cfg.noise_cov.lpf(3)=40;
    cfg.noise_cov.hpf(4)=.1;
    cfg.noise_cov.lpf(4)=144;
    cfg.noise_cov.hpf(5)=.3;
    cfg.noise_cov.lpf(5)=40;
    cfg.noise_cov.hpf(6)=2;
    cfg.noise_cov.lpf(6)=20;
    
    for default=1:6
        fprintf(' Default highpass    %d to lowpass %d\n', cfg.noise_cov.hpf(default),cfg.noise_cov.lpf(default));
    end
end


fprintf('computing noise files %s\n',subj);

       
       
for irun=cfg.start_run_from:run      
    
   % CHECKING TO SEE IF SSS RECORDING DONE WITH NEW MEG ELECTRONICS (1/7/14)

    rawfile=[data_subjdir subj  '_' cfg.protocol '_' num2str(irun) '_raw.fif'];
    addpath(data_subjdir);  
    
    fiff_file_raw=fiff_setup_read_raw(rawfile);
    cfg.raw_file_sfreq=fiff_file_raw.info.sfreq;
    
    if round(cfg.raw_file_sfreq)-cfg.raw_file_sfreq==0
        cfg.mne_process_raw_digtrig='  --digtrig STI101 --digtrigmask 0xff  '; % km: added --digtrigmask for 8 bits
    else
        cfg.mne_process_raw_digtrig='  --digtrigmask 0xff '; % km: added --digtrigmask for 8 bits
        
    end
    
    
    for inoise=1:length(cfg.noise_cov.hpf),
        
        
        cfg.mne_raw_tag{irun} = ['--raw ' subj '_' cfg.protocol '_' num2str(irun),'_',num2str(cfg.noise_cov.hpf(inoise)),'_',num2str(cfg.noise_cov.lpf(inoise)),'fil_raw.fif ']; % INPUT FILE WITH NOISE COV. VALUES
        
        command = ['mne_process_raw --projon  ',' --filteroff  ', cfg.mne_raw_tag{irun} cfg.mne_process_raw_digtrig '--cov ' cfg.covdir,'/', cfg.covdescname '.cov ' ' --savecovtag ','-cov  ' ' >& ' subj '_',num2str(irun),'_',num2str(cfg.noise_cov.hpf(inoise)),'_',num2str(cfg.noise_cov.lpf(inoise)),'fil_evecov.log'];
        
        [st,wt] = unix(command);
        fprintf(1,'\n Command executed: %s \n',command);
        fprintf(1,'\n Run: %d\n', irun);
        fprintf(1,'\n computing noise files:  %d to  %d\n',(cfg.noise_cov.hpf(inoise)),(cfg.noise_cov.lpf(inoise)));
        
        if st ~=0
            error('ERROR : error in computing noise file  %d to %d\n',(cfg.noise_cov.hpf(inoise)),(cfg.noise_cov.lpf(inoise)));
        end
        
        fprintf(1,'\n Success!:  %d to  %d\n',(cfg.noise_cov.hpf(inoise)),(cfg.noise_cov.lpf(inoise)));
        
        
    end
end

fprintf('\n Changing permissions of files created by this script \n')
[success,messageid]=system(['setgrp acqtal *'])
[success,messageid]=system(['chmod 775 *'])

diary off  % Ending Diary

filename=strcat(subj,'_do_eve_noise_covariance_cfg');
save(filename,'cfg','visitNo','run','subj');
