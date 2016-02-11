
function [cfg]=do_erm_filtering(subj,visitNo,erm_run,cfg)

% Generates filtered variants of SSS data of all subjects for a
% paradigm. Assumes default subject list.
%--------------------------------------
% Dr Engr. Sheraz Khan,  P.Eng, Ph.D.
% Engr. Nandita Shetty,  MS.
%
% Modified By Santosh Ganesan
% Date:   June 15, 2011
%--------------------------------------

%   Filters EMPTY ROOM DATA
%   Local variables:
%   1) subj = subject name
%   2) visitNo = visit number
%   3) erm_run = erm run number, usually 1
%   4) cfg = data structure with global variables
% OPTIONS:
%   1) cfg.erm_decimation, // if set,cfg.erm_decimation=[], indicates ERM data is decimated. usually set at DATA_+_ERM_DECIMATION
%   2) cfg.mne_preproc_filt:

% PARAMETERS:

% If you want the following files: highpass 1, lowpass 144; highpass 2, lowpass 25; highpass 1, lowpass 40
% cfg.mne_preproc_filt.hpf(1)=1;
% cfg.mne_preproc_filt.lpf(1)=144;
% cfg.mne_preproc_filt.hpf(2)=2;
% cfg.mne_preproc_filt.lpf(2)=25;
% cfg.mne_preproc_filt.hpf(3)=1;
% cfg.mne_preproc_filt.lpf(3)=40;
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

%   3) cfg.removeECG_EOG // if set (cfg.removeECG_EOG=1), indicates removing heartbeat only, cfg.removeECG_EOG=2 indicates removing heartbeat and blinks, default: cfg.removeECG_EOG=2
%   4) cfg.erm_sss // if set (cfg.erm_sss=[]), filtering will be done on ERM SSS file, otherwise, will be done on raw ERM file
%   5) cfg.erm_filt // set if erm_filtering parameters are different from data filtering
%% Error Check
if isfield(cfg,'error_mode')
    
    file= exist(strcat(subj,'_do_erm_filtering_error_cfg.mat'),'file');
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
diary(strcat(subj,'_erm_filtering_',datestr(clock),'.info')); % Starting Diary
diary on

%% Setting Filter Bands


if ~isfield(cfg,'erm_decimation'),
    warning('ERM data does not appear to be decimated, cfg.erm_decimation is not set ')
end

if isempty(cfg.filt) % SETS DEFAULT ERM FILTERING WITH FOLLOWING SETTINGS
    % 1-144  HZ
    % .1-25  HZ
    %  1-40  Hz
    % .1-144 Hz
    % .3-40  Hz
    
    cfg.filt.hpf(1)=1;
    cfg.filt.lpf(1)=144;
    cfg.filt.hpf(2)=.1;
    cfg.filt.lpf(2)=25;
    cfg.filt.hpf(3)=1;
    cfg.filt.lpf(3)=40;
    cfg.filt.hpf(4)=.1;
    cfg.filt.lpf(4)=144;
    cfg.filt.hpf(5)=.3;
    cfg.filt.lpf(5)=40;
    cfg.filt.hpf(6)=2;
    cfg.filt.lpf(6)=20;
    for default=1:6.
        fprintf(' highpass    %d to lowpass %d\n', cfg.filt.hpf(default),cfg.filt.lpf(default));
    end
end

if(length(cfg.filt.lpf)~=length(cfg.filt.hpf))
    
    error(' There is something funky with the low pass and high settings you have entered, Please recheck');
else
    fprintf('Starting to Filtering %s\n',subj);
end

%% Filtering files

for irun=1:erm_run,
    
    if ~isfield(cfg,'removeECG_EOG') % IF FIELD IS NOT SET, DEFAULT IS EOG & ECG CLEAN BOTH PERFORMED
        cfg.removeECG_EOG=2;
        fprintf('cfg.removeECG_EOG is not set, automatically setting to ecgeogClean_applied  %s\n',subj);
        
    end
    
    if cfg.removeECG_EOG(irun)==2,
        cfg.erm_filtering_file_tag{irun}='ecgeogClean_applied';
    elseif cfg.removeECG_EOG==1,
        cfg.erm_filtering_file_tag{irun}='ecgClean_applied';
    else
        cfg.erm_filtering_file_tag{irun}='';
    end
    
    
    
    if isfield(cfg,'erm_sss')
        if isempty(cfg.erm_filtering_file_tag{irun});
            cfg.mne_dec_tag{irun} = ['--raw ' subj '_erm_',num2str(irun),'_sss.fif ']; % FILE NAME IF ERM HAS SSS PERFORMED
            erm_subjdir=[cfg.erm_rootdir '/' subj '/' num2str(visitNo) '/'];
            addpath(erm_subjdir);
            erm_filename=strcat(subj,'_erm_',num2str(irun),'_sss.fif ');
            erm_filepath=[cfg.erm_rootdir '/' subj '/' num2str(visitNo) '/',erm_filename];
            movefile(erm_filepath,data_subjdir,'f')
        else
            cfg.mne_dec_tag{irun} = ['--raw ' subj '_erm_',num2str(irun),'_sss_',cfg.erm_filtering_file_tag{irun},'_raw.fif ']; % FILE NAME IF ERM HAS SSS PERFORMED
        end
    else
           erm_subjdir=[cfg.erm_rootdir '/' subj '/' num2str(visitNo) '/'];
           addpath(erm_subjdir);
           cfg.mne_dec_tag{irun} = ['--raw ' erm_subjdir subj '_erm_',num2str(irun),'_decsss_raw.fif ']; % FILE NAME IF ERM HAS NO SSS PERFORMED
    end
    %% CHECKING TO SEE IF ERM RECORDING DONE WITH NEW MEG ELECTRONICS (10/1/12)
    temp=regexp(cfg.mne_dec_tag{irun},'.fif');
    ermfile=cfg.mne_dec_tag{irun}(7:temp+3);
    
    fiff_file=fiff_setup_read_raw(ermfile);
    cfg.erm_raw_file_sfreq=fiff_file.info.sfreq;
    
    if round(cfg.erm_raw_file_sfreq)-cfg.erm_raw_file_sfreq==0
        cfg.erm_mne_process_raw_digtrig='  --digtrig STI101  ';
    else
        cfg.erm_mne_process_raw_digtrig='  ';
        
    end
    %%
    for ifilter=1:length(cfg.filt.hpf),
        
        if cfg.filt.hpf(ifilter)<=1,
            filtersize= ' --filtersize 8192 '; % FILTERSIZE IF HPF <1
            fprintf('\n HPF <=1, --filtersize 8192  \n')
        else
            filtersize= ' --filtersize 4096 '; % DEFAULT FILTERSIZE
            fprintf('\n Default FILTERSIZE --filtersize 4096  \n')
        end
        % FILTERING DATA FILES
        command = ['mne_process_raw ' cfg.mne_dec_tag{irun} cfg.erm_mne_process_raw_digtrig ' --projoff '  filtersize ' --highpass',' ',num2str(cfg.filt.hpf(ifilter)),' ','--lowpass',' ',num2str(cfg.filt.lpf(ifilter)),' ',...
            ' --save ' subj '_erm_' num2str(irun),'_',num2str(cfg.filt.hpf(ifilter)),'-',num2str(cfg.filt.lpf(ifilter)),'fil.fif  >& ',subj,'_',cfg.protocol,'_erm_filtering.log '];
        
        [st,wt] = unix(command);
        
        plotfft_fm([subj '_erm_' num2str(irun),'_',num2str(cfg.filt.hpf(ifilter)),'-',num2str(cfg.filt.lpf(ifilter)),'fil_raw.fif'])
        
        
        fprintf(1,'\n Command executed: %s \n',command);
        fprintf(1,'\n Run: %d\n', irun);
        fprintf(1,'\n filtering: highpass  %d to lowpass %d\n',cfg.filt.hpf(ifilter),cfg.filt.lpf(ifilter));
        
        if st ~=0
            error('ERROR : error in computing highpass  %d to lowpass %d\n',cfg.filt.hpf(ifilter),cfg.filt.lpf(ifilter))
        end
        
        fprintf(1,'\n Success!: highpass  %d to lowpass %d\n',cfg.filt.hpf(ifilter),cfg.filt.lpf(ifilter));
        
        
        
    end
    if isempty(cfg.erm_filtering_file_tag{irun});
        rmpath(erm_subjdir);
        
    end
end

fprintf('\n Changing permissions of files created by this script \n')
[success,messageid]=system(['setgrp acqtal *'])
[success,messageid]=system(['chmod 775 *'])

diary off  % Ending Diary

filename=strcat(subj,'_do_erm_filtering_cfg');
save(filename,'cfg','visitNo','erm_run','subj');
