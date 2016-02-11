function [cfg]=do_mne_preproc_heartbeat(subj,visitNo,run,cfg)

%   Sheraz Khan <sheraz@nmr.mgh.harvard.edu>
%   Santosh Ganesan <santosh@nmr.mgh.harvard.edu>
%   Cleans raw or sss empty room/protocol data
% Local variables:
%   1) subj = subject name
%   2) visitNo = visit number
%   3) run = run number
%   4) cfg = data structure with global variables
% OPTIONS:
%   1) cfg.removeECG_EOG // if set (cfg.removeECG_EOG=1), indicates removing heartbeat only, cfg.removeECG_EOG=2 indicates removing heartbeat and blinks
%   2) cfg.no_erm_decimation // if set (cfg.no_erm_decimation=[]), erm decimation is skipped entirely
%   3) cfg.no_data_decimation // if set (cfg.no_data_decimation=[]), data decimation is skipped entirely
%   4) cfg.start_run_from // if set, with multiple runs, will start sss from that run. For example, cfg.start_run_from=2, function will begin from run 2
%   5) cfg.force_ecgdet_ch171 // if set, ch171 is set as ecg channel
%   6) cfg.force_ecgdet_ch159 // if set, ch159 is set as ecg channel
%   7) cfg.apply_projections_only // if set, only previously constructed ecg and/or eog projections will be applied.
%   8) cfg.manually_checked_proj // if set, only previously constructed ecg and/or eog projections will be applied.

% FORMAT for file:
% ecg: [subj_cfg.protocol_run_ecg_checked-proj.fif]
% ecgeog: [subj_cfg.protocol_run_ecgeog_checked-proj.fif]

%   9) cfg.ecg_grad_number // sets the number of the gradiometers in the projections, If field not set, then default will be 1
%  10) cfg.ecg_mag_number // sets the number of the magnetometers in the projections, If field not set, then default will be 2
%  11) cfg.eyeballed_ecg // indicates a manually constructed heartbeat event file

% FORMAT for file:
% ecg: [subj_cfg.protocol_run_eyeballed_ecg-eve.eve]

%  12) cfg.eyeballed_eog // indicates a manually constructed blink event file

% FORMAT for file:
% eog: [subj_cfg.protocol_run_eyeballed_eog-eve.eve]

%  13) cfg.proj_event // if set, specifies an event number for a manually constructed event file (Please refer to option number 12 & 13)
%  14) cfg.turnprojoff // if set, projections will be created but not applied on data.
%  15) cfg.no_projector_application_on_data // if set, projections will be applied on erm, but not on data
%  16) cfg.no_projector_application_on_erm // if set, projections will be applied on data, but not on erm
%  17) cfg.clean_eog_only // if set, only blink projection will be performed
%  18) cfg.eog_manual_sign_indicator, manually checking/implementing blink projections through GUI


%% Error Check
if isfield(cfg,'error_mode')
    
    file= exist(strcat(subj,'_do_mne_preproc_heartbeat_error_cfg.mat'),'file');
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

if ~isfield(cfg,'removeECG_EOG'), % IF FIELD IS NOT SET, DEFAULT IS EOG & ECG CLEAN BOTH PERFORMED
    cfg.removeECG_EOG(run)=2;
    fprintf('\n Remove ECG_EOG is not set %s\n',subj);
    fprintf('\n Default will be used/ Removal of ECG & EOG! %s\n',subj);
    fprintf('\n ECG_EOG=2! %s\n',subj);
end



data_subjdir=[cfg.data_rootdir,'/',subj '/' num2str(visitNo) '/'];
cd(data_subjdir) % cd to the fif dir
%% Removal of heart-beat component

diary(strcat(subj,'_mne_preproc_heartbeat_',datestr(clock),'.info')); % Starting Diary
diary on

if ~isfield(cfg,'start_run_from')
    cfg.start_run_from=1; % field allows flexibility to start pre-processing not from run 1
end

if isfield(cfg,'no_erm_decimation'), % IF FIELD IS SET, THEN ERM DECIMATION IS NOT PERFORMED
    cfg.in_fif_erm=strcat(subj,'_erm_1_sss.fif');
    
else
    
    cfg.in_fif_erm=strcat(subj,'_erm_1_decsss_raw.fif');
    
end

%% CHECKING TO SEE IF ERM RECORDING DONE WITH NEW MEG ELECTRONICS (10/1/12)

if ~isfield(cfg,'erm_mne_process_raw_digtrig'), % IF FIELD IS SET, THEN ERM DECIMATION IS NOT PERFORMED
    erm_subjdir=[cfg.erm_rootdir,'/',subj '/' num2str(visitNo) '/'];
    
    checkerm=exist([erm_subjdir cfg.in_fif_erm],'file');
    
    if checkerm==0       
    erm_subjdir=[cfg.erm_rootdir,'/',subj '/' num2str(1) '/'];
    end
    
    addpath(erm_subjdir);
    fiff_file=fiff_setup_read_raw(cfg.in_fif_erm);
    cfg.erm_raw_file_sfreq=fiff_file.info.sfreq;
    
    if round(cfg.erm_raw_file_sfreq)-cfg.erm_raw_file_sfreq==0
        cfg.erm_mne_process_raw_digtrig='  --digtrig STI101  --digtrigmask 0xff ';
    else
        cfg.erm_mne_process_raw_digtrig=' --digtrigmask 0xff ';
        
    end
    
end
%%
temp=cfg.removeECG_EOG(cfg.start_run_from); % USED TO ERROR CHECK. IF EITHER EOG OR ECG FAILS, IT RECORDS THE EVENT

for irun=cfg.start_run_from:run
    
    
    
    if length(cfg.removeECG_EOG)~=run, % IF FIELD IS NOT SET, DEFAULT IS EOG & ECG CLEAN BOTH PERFORMED
        for newrun=1:run
            cfg.removeECG_EOG(newrun)=2;
            fprintf('\n Remove ECG_EOG is not set %s\n',subj);
            fprintf('\n Default will be used/ Removal of ECG & EOG! %s\n',subj);
            fprintf('\n ECG_EOG=2! %s\n',subj);
        end
    end
    
    cfg.removeECG_EOG(irun)=temp; % USED TO ERROR CHECK. IF EITHER EOG OR ECG FAILS, IT RECORDS THE EVENT
    
    if isfield(cfg,'no_data_decimation')
        if cfg.no_data_decimation==1
            fprintf(1,'\n MNE Preproc on undecimated data %d\n',irun);
        else
            fprintf(1,'\n MNE Preproc on decimated data %d\n',irun);
        end
        
    else
        fprintf(1,'\n MNE Preproc on decimated data %d\n',irun);
    end
    
    
    error_handler=0;
    while error_handler<=2,
        
        if cfg.removeECG_EOG(irun)==1
            try
                if ~isfield(cfg,'no_data_sss')
                    if ~ isfield (cfg,'no_data_decimation')
                        cfg.in_fif{irun} = strcat(subj,'_',cfg.protocol,'_',num2str(irun),'_decim_sss.fif'); % DECIM SSS DATA FILE INPUT
                    else
                        cfg.in_fif{irun} = strcat(subj,'_',cfg.protocol,'_',num2str(irun),'_sss.fif'); % SSS DATA FILE INPUT
                    end
                else
                    if ~isfield (cfg,'no_data_decimation')
                        cfg.in_fif{irun} = strcat(subj,'_',cfg.protocol,'_',num2str(irun),'_decim_raw.fif'); % RAW DATA FILE INPUT
                    else
                        cfg.in_fif{irun} = strcat(subj,'_',cfg.protocol,'_',num2str(irun),'_raw.fif'); % RAW DECIM DATA FILE INPUT
                    end
                end
                cfg.out_fif{irun} = strcat(subj,'_',cfg.protocol,'_',num2str(irun),'_ecgClean.fif'); % ECG CLEANED OUTPUT
                cfg.out_fif_erm = strcat(subj,'_erm_1_sss_ecgClean_applied.fif'); % ERM CLEANED OUTPUT
                cfg.in_path{irun}=data_subjdir; % SAVE PATH
                cfg.eventFileName =strcat(subj,'_',cfg.protocol,'_',num2str(irun),'_ecgClean_raw-eve','.fif'); % ECG CLEAN EVENT FILE NAME
                fprintf(1,'\n Implementing ECG artifact rejection on data \n');
                if ~isfield(cfg,'force_ecgdet_ch171') % IF FIELD IS SET, HEARTBEAT REJECTION BASED ON CHANNEL 171
                    cfg.force_ecgdet_ch171=0;
                end
                if ~isfield(cfg,'force_ecgdet_ch159') % IF FIELD IS SET, HEARTBEAT REJECTION BASED ON CHANNEL 159
                    cfg.force_ecgdet_ch159=0;
                end
                [cfg]=clean_ecg(cfg.in_fif{irun},cfg.out_fif{irun},cfg.eventFileName,cfg.in_path{irun},cfg,visitNo,subj,irun,cfg.force_ecgdet_ch171,cfg.force_ecgdet_ch159); % check channel STI014
                error_handler=3;
            catch
                fprintf(1,'\n Heartbeat Artifact Rejection failed  %d\n',irun);
                error_handler=3;
                continue
            end
            
            
        elseif cfg.removeECG_EOG(irun)==2
            
            try
                if ~isfield(cfg,'no_data_sss')
                    if ~ isfield (cfg,'no_data_decimation')
                        cfg.in_fif{irun} = strcat(subj,'_',cfg.protocol,'_',num2str(irun),'_decim_sss.fif'); % DECIM SSS DATA FILE INPUT
                    else
                        cfg.in_fif{irun} = strcat(subj,'_',cfg.protocol,'_',num2str(irun),'_sss.fif'); % SSS DATA FILE INPUT
                    end
                else
                    if ~isfield (cfg,'no_data_decimation')
                        cfg.in_fif{irun} = strcat(subj,'_',cfg.protocol,'_',num2str(irun),'_decim_raw.fif'); % RAW DATA FILE INPUT
                    else
                        cfg.in_fif{irun} = strcat(subj,'_',cfg.protocol,'_',num2str(irun),'_raw.fif'); % RAW DECIM DATA FILE INPUT
                    end
                end
              %  cfg.in_fif{irun} = strcat(subj,'_',cfg.protocol,'_',num2str(irun),'_sss.fif'); % SSS DATA FILE INPUT
                cfg.out_fif{irun} = strcat(subj,'_',cfg.protocol,'_',num2str(irun),'_ecgeogClean.fif'); % ECG & EOG CLEANED OUTPUT
                cfg.out_fif_erm = strcat(subj,'_erm_1_sss_ecgeogClean_applied.fif'); % ERM CLEANED OUTPUT
                cfg.in_path{irun}=data_subjdir; % SAVE PATH
                cfg.eventFileName =strcat(subj,'_',cfg.protocol,'_',num2str(irun),'_ecgeogClean_raw-eve','.fif'); % ECGEOG CLEAN EVENT FILE NAME
                fprintf(1,'\n Implementing ECG and EOG artifact rejection on data \n')
                [cfg]=clean_ecgeog(cfg.in_fif{irun},cfg.out_fif{irun},cfg.eventFileName,cfg.in_path{irun},cfg,visitNo,subj,irun); % check channel STI014
                error_handler=3;
           
            catch
                
                fprintf(1,'\n Blink Artifact Rejection failed  %d\n',irun);
                fprintf('\n Trying only ECG Clean\n')
                temp=1;
                cfg.removeECG_EOG(irun)=temp; % USED TO ERROR CHECK. IF EITHER EOG OR ECG FAILS, IT RECORDS THE EVENT
                continue
            end
            
        else
            display('No ECG, EOG artifacts removed')
            error_handler=3;
            
            break;
            
        end
        
        
        
    end
    
end

fprintf('\n Changing permissions of files created by this script \n')
[success,messageid]=system(['setgrp acqtal *'])
[success,messageid]=system(['chmod 775 *'])

%%
filename=strcat(subj,'_do_mne_preproc_heartbeat_cfg');
save(filename,'cfg','visitNo','run','subj');
diary off % Ending Diary