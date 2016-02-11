
function [cfg]=do_erm_noise_covariance(subj,visitNo,erm_run,cfg)

% Generates filtered variants of SSS data of all subjects for a
% paradigm. Assumes default subject list.
%--------------------------------------
% Dr Engr. Sheraz Khan,  P.Eng, Ph.D.
% Engr. Nandita Shetty,  MS.
%
% Modified By Santosh Ganesan
% Date:   June 15, 2011

% Modified By Fahimeh Mamashli
% Date:   January 08, 2014


%--------------------------------------

%   Generates Noise Covariance Matrix
% Local variables:
%   1) subj = subject name
%   2) visitNo = visit number
%   3) erm_run = erm run number, usually 1
%   4) cfg = data structure with global variables
%   5) cfg.erm_filt // set if erm_filtering parameters are different from data filtering
% OPTIONS:
%   1) cfg.erm_decimation, // if set,cfg.erm_decimation=[], indicates ERM data is decimated. usually set at DATA_+_ERM_DECIMATION
%   2) cfg.mne_preproc_filt:

% PARAMETERS:

% If you want the following files: highpass 1, lowpass 144; highpass 2, lowpass 25; highpass 1, lowpass 40
% cfg.mne_preproc_filt.hpf(1)=1;
% cfg.mne_preproc_filt.lpf(1)=144
% cfg.mne_preproc_filt.hpf(2)=2;
% cfg.mne_preproc_filt.lpf(2)=25;
% cfg.mne_preproc_filt.hpf(3)=1;
% cfg.mne_preproc_filt.lpf(3)=40
% cfg.mne_preproc_filt: if field is not set or empty, erm filtering will occur with the following parameters:
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


%% Error Check
if isfield(cfg,'error_mode')
    
    file= exist(strcat(subj,'_do_erm_noise_covariance_error_cfg.mat'),'file');
    if file~=2
        return
    else
        delete(file);
    end
end
%% Global Variables

if ~isfield(cfg,'erm_rootdir'),
    error('Please enter a root directory in sub-structure cfg.erm_rootdir: Thank you');
end

if ~isfield(cfg,'covdir')
    error('Please enter a covariance directory in sub-structure cfg.covdir: Thank you');
end

if ~isfield(cfg,'mne_preproc_filt') || isempty(cfg.mne_preproc_filt)
    cfg.filt=[];
else
    cfg.filt=cfg.mne_preproc_filt;
end

if isfield(cfg,'erm_filt')
    cfg.filt=cfg.erm_filt;
end

data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
cd(data_subjdir);
diary(strcat(subj,'_erm_noise_covariance_',datestr(clock),'.info')); % Starting Diary
diary on


%% Computation of noise  files.MM

if isfield(cfg,'no_erm_decimation')
    if (cfg.no_erm_decimation~=0),
        warning('ERM data does not appear to be decimated, cfg.erm_decimation is not set ')
    end
end

cfg.noise_cov=cfg.filt;

if isempty(cfg.noise_cov),
    % SETS DEFAULT ERM FILTERING WITH FOLLOWING SETTINGS
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




for irun=1:erm_run,
    
    for inoise=1:length(cfg.noise_cov.hpf),
        
        cfg.mne_raw_tag{irun} = ['--raw ' subj '_erm_' num2str(irun),'_',num2str(cfg.noise_cov.hpf(inoise)),'-',num2str(cfg.noise_cov.lpf(inoise)),'fil_raw.fif ']; % INPUT FILE WITH NOISE COV. VALUES
        
        %% CHECKING TO SEE IF ERM RECORDING DONE WITH NEW MEG ELECTRONICS (10/1/12)
        temp=regexp(cfg.mne_raw_tag{irun},'.fif');
        ermfile=cfg.mne_raw_tag{irun}(7:temp+3);
        
        fiff_file=fiff_setup_read_raw(ermfile);
        cfg.erm_raw_file_sfreq=fiff_file.info.sfreq;
        
        if round(cfg.erm_raw_file_sfreq)-cfg.erm_raw_file_sfreq==0
            cfg.erm_mne_process_raw_digtrig='  --digtrig STI101  ';
        else
            cfg.erm_mne_process_raw_digtrig='  ';
            
        end
        %%
        
        command = ['mne_process_raw --projon  ',' --filteroff  ', cfg.mne_raw_tag{irun} cfg.erm_mne_process_raw_digtrig '--cov ' cfg.covdir,'/', 'erm.cov ' ' --savecovtag ','-cov  ' ' >& ' subj '_',num2str(irun),'_',num2str(cfg.noise_cov.hpf(inoise)),'-',num2str(cfg.noise_cov.lpf(inoise)),'fil-cov.log'];
        
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

filename=strcat(subj,'_do_erm_noise_covariance_cfg');
save(filename,'cfg','visitNo','erm_run','subj');
