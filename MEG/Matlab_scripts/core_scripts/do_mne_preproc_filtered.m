function [cfg]=do_mne_preproc_filtered(subj,visitNo,run,cfg)

%   Sheraz Khan <sheraz@nmr.mgh.harvard.edu>
%   Santosh Ganesan <santosh@nmr.mgh.harvard.edu>
%   FILTERS PROTOCOL DATA
%   Local variables:
%   1) subj = subject name
%   2) visitNo = visit number
%   3) run = run number
%   4) cfg = data structure with global variables
% OPTIONS:
% 1) cfg.2-20_epoching // if set, automatically epochs data 2-20. This field is passed through filtering, grand average, and epoching modules.
% 2) cfg.mne_preproc_filt:

% PARAMETERS:

% If you want the following files: highpass 1, lowpass 144; highpass 2, lowpass 25; highpass 1, lowpass 40
% cfg.mne_preproc_filt.hpf(1)=1;
% cfg.mne_preproc_filt.lpf(1)=144;
% cfg.mne_preproc_filt.hpf(2)=2;
% cfg.mne_preproc_filt.lpf(2)=25;
% cfg.mne_preproc_filt.hpf(3)=1;
% cfg.mne_preproc_filt.lpf(3)=40;
% cfg.mne_preproc_filt: if field is not set or empty, protocol data filtering will occur with the following parameters:
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

% 3) cfg.removeECG_EOG // if set (cfg.removeECG_EOG=1), indicates removing heartbeat only, cfg.removeECG_EOG=2 indicates removing heartbeat and blinks, default: cfg.removeECG_EOG=2
% 4) cfg.start_run_from // if set, with multiple runs, will start sss from that run. For example, cfg.start_run_from=2, function will begin from run 2


%% Error Check
if isfield(cfg,'error_mode')
    
    file= exist(strcat(subj,'_do_mne_preproc_filtered_error_cfg.mat'),'file');
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

if ~isfield(cfg,'start_run_from')
    cfg.start_run_from=1;
end

if ~isfield(cfg,'removeECG_EOG'), % IF FIELD IS NOT SET, DEFAULT IS EOG & ECG CLEAN BOTH PERFORMED
    for irun=cfg.start_run_from:run, % field allows flexibility to start pre-processing not from run 1
        cfg.removeECG_EOG(irun)=2;
    end
    fprintf('\n Remove ECG_EOG is not set %s\n',subj);
    fprintf('\n Default will be used/ Removal of ECG & EOG! %s\n',subj);
    fprintf('\n ECG_EOG=2! %s\n',subj);
end
data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
cd(data_subjdir) % cd to the fif dir
%% MNE Preproc Filtered

diary(strcat(subj,'_mne_preproc_filtered_',datestr(clock),'.info')); % Starting Diary
diary on

if ~isfield(cfg,'mne_preproc_filt') % IF FIELD EMPTY, DEFAULT PREPROCESSING SETTINGS ARE
    
    % SETS DEFAULT DATA FILTERING WITH FOLLOWING SETTINGS
    % 1-144  HZ
    % 2-20   HZ
    cfg.mne_preproc_filt.hpf(1)=1;
    cfg.mne_preproc_filt.lpf(1)=144;
    fprintf(' highpass    %d to lowpass %d\n', cfg.mne_preproc_filt.hpf(1),cfg.mne_preproc_filt.lpf(1));
    cfg.mne_preproc_filt.hpf(2)=2;
    cfg.mne_preproc_filt.lpf(2)=20;
    fprintf(' highpass    %d to lowpass %d\n', cfg.mne_preproc_filt.hpf(2),cfg.mne_preproc_filt.lpf(2));
    
else
    
    if isfield(cfg,'2-20_epoching')  % SET FIELD IF YOU WANT TO EPOCH ALL FILES WITH 2-20 HZ SETTINGS
        cfg.mne_preproc_filt.hpf(length(cfg.mne_preproc_filt.hpf)+1)=2;
        cfg.mne_preproc_filt.lpf(length(cfg.mne_preproc_filt.lpf)+1)=20;
    end
end




if (length(cfg.mne_preproc_filt.lpf)~=length(cfg.mne_preproc_filt.hpf))
    
    error(' There is something funky with the low pass and high pass settings you have entered, Please recheck');
else
    fprintf('Starting to Filtering %s\n',subj);
end





for irun=cfg.start_run_from:run, % field allows flexibility to start pre-processing not from run 1
    
    
    if (cfg.removeECG_EOG(irun)==1),
        cfg.preproc_filtered_file_tag='ecgClean';
        cfg.mne_preproc_raw_tag{irun} = ['--raw ' subj '_' cfg.protocol '_',num2str(irun),'_',cfg.preproc_filtered_file_tag,'_raw.fif ']; % takes as input noncleaned, ecg cleaned, or ecg-eog cleaned data files
        
    elseif (cfg.removeECG_EOG(irun)==2),
        cfg.preproc_filtered_file_tag='ecgeogClean';
        cfg.mne_preproc_raw_tag{irun} = ['--raw ' subj '_' cfg.protocol '_',num2str(irun),'_',cfg.preproc_filtered_file_tag,'_raw.fif ']; % takes as input noncleaned, ecg cleaned, or ecg-eog cleaned data files
        
    else
        cfg.preproc_filtered_file_tag='sss';
        cfg.mne_preproc_raw_tag{irun} = ['--raw ' subj '_' cfg.protocol '_',num2str(irun),'_',cfg.preproc_filtered_file_tag,'.fif ']; % takes as input noncleaned, ecg cleaned, or ecg-eog cleaned data files
        
    end
    
    %% CHECKING TO SEE IF SSS RECORDING DONE WITH NEW MEG ELECTRONICS (10/1/12)
    temp=regexp(cfg.mne_preproc_raw_tag{irun},'.fif');
    sssfile=cfg.mne_preproc_raw_tag{irun}(7:temp+3);
    
    fiff_file_raw=fiff_setup_read_raw(sssfile);
    cfg.raw_file_sfreq=fiff_file_raw.info.sfreq;
    
    if round(cfg.raw_file_sfreq)-cfg.raw_file_sfreq==0
        cfg.mne_process_raw_digtrig='  --digtrig STI101 --digtrigmask 0xff ';  % km: added --digtrigmask 0xff for 8 bits
    else
        cfg.mne_process_raw_digtrig=' --digtrigmask 0xff  ';
        
    end
    %%
    %cfg.mne_preproc_raw_tag{irun} = ['--raw ' subj '_' cfg.protocol '_',num2str(irun),'_',cfg.preproc_filtered_file_tag,'_raw.fif ']; % takes as input noncleaned, ecg cleaned, or ecg-eog cleaned data files
    
    try
        for ifilter=1:length(cfg.mne_preproc_filt.hpf),
            fprintf(1,'\n filtering: highpass  %d to lowpass %d\n',cfg.mne_preproc_filt.hpf(ifilter),cfg.mne_preproc_filt.lpf(ifilter));
            cfg.fil_fif{irun}=[subj, '_', cfg.protocol,'_',num2str(irun),'_',num2str(cfg.mne_preproc_filt.hpf(ifilter)),'_',num2str(cfg.mne_preproc_filt.lpf(ifilter)),'fil.fif ']; % output file name
            
            if (cfg.mne_preproc_filt.hpf(ifilter))<=1
                cfg.filterlength=8192; % FILTERSIZE IF HPF <1
            else
                
                cfg.filterlength=4096; % DEFAULT FILTERSIZE
            end
            % MNE PRE-PROCESSING FILTER COMMAND
            
            if isfield(cfg,'manual_event_file_name')
                
                cfg.mne_process_raw_digtrig=[' --events ' cfg.manual_event_file_name];
            end
            
            command = ['mne_process_raw ' cfg.mne_preproc_raw_tag{irun} cfg.mne_process_raw_digtrig ' --lowpass  ', num2str(cfg.mne_preproc_filt.lpf(ifilter)),' --highpass  ',num2str(cfg.mne_preproc_filt.hpf(ifilter)),...
                '  --filtersize  ' num2str(cfg.filterlength)  '   --projon  ',' --save ' cfg.fil_fif{irun} '  >& ',subj,'_',cfg.protocol,'_',num2str(irun),'_',num2str(cfg.mne_preproc_filt.hpf(ifilter)),'_',num2str(cfg.mne_preproc_filt.lpf(ifilter)),'_mne_preproc.log'];
            
            if cfg.removeECG_EOG(irun)==0
               command = ['mne_process_raw ' cfg.mne_preproc_raw_tag{irun} cfg.mne_process_raw_digtrig ' --lowpass  ', num2str(cfg.mne_preproc_filt.lpf(ifilter)),' --highpass  ',num2str(cfg.mne_preproc_filt.hpf(ifilter)),...
                '  --filtersize  ' num2str(cfg.filterlength)  '   --projoff  ',' --save ' cfg.fil_fif{irun} '  >& ',subj,'_',cfg.protocol,'_',num2str(irun),'_',num2str(cfg.mne_preproc_filt.hpf(ifilter)),'_',num2str(cfg.mne_preproc_filt.lpf(ifilter)),'_mne_preproc.log'];
            end  
                
            
            [st,wt] = unix(command);
            
            plotfft_fm([cfg.fil_fif{irun}(1:end-5) '_raw.fif'])
            

            fprintf(1,'\n Command executed: %s \n',command);
            fprintf(1,'\n Run: %d\n', irun);
            fprintf(1,'\n filtering: highpass  %d to lowpass %d\n',cfg.mne_preproc_filt.hpf(ifilter),cfg.mne_preproc_filt.lpf(ifilter));
            
            if st ~=0
                error('ERROR : error in computing filtered file highpass  %d to lowpass %d\n',cfg.mne_preproc_filt.hpf(ifilter),cfg.mne_preproc_filt.lpf(ifilter))
                continue
            else
                fprintf(1,'\n Success!: highpass  %d to lowpass %d\n',cfg.mne_preproc_filt.hpf(ifilter),cfg.mne_preproc_filt.lpf(ifilter));
            end
            
            
        end
    catch
        fprintf(1,'\n Filtering failed highpass  %d to lowpass %d for run  %d\n',cfg.mne_preproc_filt.hpf(ifilter),cfg.mne_preproc_filt.lpf(ifilter),irun);
        continue
    end
end



if isfield(cfg,'2-20_epoching')  % Maintain settings in field cfg.mne_preproc_filt
    cfg.mne_preproc_filt.hpf=cfg.mne_preproc_filt.hpf(1:length(cfg.mne_preproc_filt.hpf)-1);
    cfg.mne_preproc_filt.lpf=cfg.mne_preproc_filt.lpf(1:length(cfg.mne_preproc_filt.lpf)-1);
end
fprintf('\n Changing permissions of files created by this script \n')
[success,messageid]=system(['setgrp acqtal *'])
[success,messageid]=system(['chmod 775 *'])

filename=strcat(subj,'_do_mne_preproc_filtered_cfg');
save(filename,'cfg','visitNo','run','subj');
diary off   % Ending Diary
