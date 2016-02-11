function [cfg]= do_sss_decimation_combined(subj,visitNo,run,erm_run,cfg)


% Decimates ERM & SSS data of all subjects for a
% paradigm. Assumes default subject list.
%--------------------------------------
% Dr Engr. Sheraz Khan,  P.Eng, Ph.D.
% Engr. Nandita Shetty,  MS.
%
% Modified By Santosh Ganesan
% Date:   June 15, 2011
%--------------------------------------

%   Decimates raw or sss empty room/protocol data with LPF SET to 144 Hz
% Local variables:
%   1) subj = subject name
%   2) visitNo = visit number
%   3) run = run number
%   4) cfg = data structure with global variables
% OPTIONS:
%   1) cfg.erm_sss // if set (cfg.erm_sss=[]), indicates decimation on sss erm file, otherwise, erm decimation on raw erm file
%   2) cfg.no_erm_decimation // if set (cfg.no_erm_decimation=[]), erm decimation is skipped entirely
%   3) cfg.start_run_from // if set, with multiple runs, will start data decimation from that run. For example, cfg.start_run_from=2, function will begin from run 2
%   4) cfg.no_data_decimation // if set (cfg.no_data_decimation=[]), data decimation is skipped entirely
%   5) cfg.start_run_from // if set, with multiple runs, will start sss from that run. For example, cfg.start_run_from=2, function will begin from run 2
%% Error Check
if isfield(cfg,'error_mode')
    
    file= exist(strcat(subj,'_do_sss_decimation_combined_error_cfg.mat'),'file');
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
erm_subjdir=[cfg.erm_rootdir '/' subj '/' num2str(visitNo) '/'];

if ~isfield(cfg,'data_rootdir'),
    error('Please enter a root directory in sub-structure cfg.data_rootdir: Thank you');
end
if  ~isfield(cfg,'protocol'),
    error('Please enter a protocol name in sub-structure cfg.protocol: Thank you');
end
data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];

%% Decimating ERM Files



diary(strcat(subj,'_erm_decimation_',datestr(clock),'.info')); % Starting Diary
diary on
if ~isfield(cfg,'no_erm_decimation'),
    
    
    
    
    % cd(data_subj)
    cd(erm_subjdir);
    fprintf('Starting to Decimate ERM %s\n',subj);
    
    
    if ~isfield(cfg,'decim_freq')
        cfg.decim_freq=600;
        fprintf('decimating to 600 Hz sampling %s\n',subj);
    end
    
    % Decimating to 600 HZ sampling
    
    
    
    
    for irun=1:erm_run,
        
        fprintf(1,'\n Executing Run: %d\n', irun);
        
        if isfield(cfg,'erm_sss'),
            
            
            cfg.erm_sss_file_tag=[subj,'_erm_',num2str(irun),'_sss.fif']; % DECIMATE SSS OF ERM FILE
            
            tag='sss';
            fprintf('Starting to Decimate ERM SSS File,%s\n',subj);
            
            
        else
            cfg.erm_sss_file_tag=[subj,'_erm_',num2str(irun),'_raw.fif']; % DECIMATE RAW ERM FILE
            tag='';
            fprintf('SSS selected as not having been done %s\n',subj);
            fprintf('Starting to Decimate Raw ERM File %s\n',subj);
        end
        
        
        %% CHECKING TO SEE IF ERM RECORDING DONE WITH NEW MEG ELECTRONICS (10/1/12)
        
        fiff_file=fiff_setup_read_raw(cfg.erm_sss_file_tag);
        cfg.erm_raw_file_sfreq=fiff_file.info.sfreq;
        
        if round(cfg.erm_raw_file_sfreq)-cfg.erm_raw_file_sfreq==0
            cfg.erm_mne_process_raw_digtrig='  --digtrig STI101  ';
        else
            cfg.erm_mne_process_raw_digtrig='  ';
            
        end
        %%
        [info] = fiff_read_meas_info(cfg.erm_sss_file_tag);
        cfg.raw_tag{irun} = ['--raw ' cfg.erm_sss_file_tag];
        cfg.raw_dec_tag{irun} = [subj,'_erm_',num2str(irun),'_dec',tag];
        
        
        decim= round(info.sfreq/cfg.decim_freq);
        fprintf('decim = %d\n',decim);
        cfg.ds_tag{irun}=[' --decim  ',num2str(decim)];
         
        
        fprintf('lowpass 144 Hz \n');
        % DECIMATE ERM TO 144 HZ
        command = ['mne_process_raw ' cfg.raw_tag{irun}  cfg.ds_tag{irun} '  --lowpass 144 ' cfg.erm_mne_process_raw_digtrig ' --projoff  --save ' cfg.raw_dec_tag{irun} ' >& ' subj '_erm_',num2str(irun),'_erm_decim.log'];
        [st,wt] = unix(command);
        fprintf(1,'\n Command executed: %s \n',command);
        
        if st ~=0
            error('ERROR : error in downsampling')
        end
        
    end
    
    cfg.no_erm_decimation=0;
else
    cfg.no_erm_decimation=1;
    fprintf('erm_decimation field is true; indicates that erm decimation has already been performed or that user wishes to not decimate ERM %s\n',subj);
end

diary off % Ending Diary

%% SSS Decimation

diary(strcat(subj,'_sss_decimation',datestr(clock),'.info')); % Starting Diary
diary on
cd(data_subjdir) % cd to the fif dir
fprintf('Starting to Decimate %s\n',subj);

if isfield(cfg,'no_data_decimation')
    
    fprintf(1,'\n SSS data decimation is turned off:cfg.no_data_decimation is enabled \n');
    
else
    
    if ~isfield(cfg,'start_run_from')
        cfg.start_run_from=1; % field allows flexibility to start pre-processing not from run 1
    end
    for irun=cfg.start_run_from:run
        try
            
            % Decimating to 600 HZ sampling
            
            fprintf('decimating to 600 Hz sampling %s\n',subj);
            if ~isfield(cfg,'no_data_sss')
                decimate_sss_tag{irun}=[subj '_' cfg.protocol '_' num2str(irun) '_sss.fif']; % DECIMATE SSS OF DATA FILE
            else
                decimate_sss_tag{irun}=[subj '_' cfg.protocol '_' num2str(irun) '_raw.fif']; % DECIMATE RAW DATA FILE
                
            end
            
            %% CHECKING TO SEE IF SSS RECORDING DONE WITH NEW MEG ELECTRONICS (10/1/12)
            
            fiff_file_raw=fiff_setup_read_raw(decimate_sss_tag{irun});
            cfg.raw_file_sfreq=fiff_file_raw.info.sfreq;
            
            if round(cfg.raw_file_sfreq)-cfg.raw_file_sfreq==0
                cfg.mne_process_raw_digtrig='  --digtrig STI101  ';
            else
                cfg.mne_process_raw_digtrig='  ';
                
            end
            %%
            
            
            
            [info] = fiff_read_meas_info(decimate_sss_tag{irun});
            
            
            
            decim= round(info.sfreq/cfg.decim_freq);
            fprintf('decim = %d\n',decim);
            cfg.ds_tag{irun}=[' --decim  ',num2str(decim)];
            
           
            
            fprintf('\n DECIMATING THE DATA WITH LPF SET TO 144 Hz \n')
            command = ['/usr/pubsw/packages/mne/nightly/bin/mne_process_raw --raw ' decimate_sss_tag{irun}  cfg.ds_tag{irun} ' --lowpass 144 ' cfg.mne_process_raw_digtrig '  --projoff  --save ' subj '_' cfg.protocol '_' num2str(irun) '_decim.fif' ' >& ' subj '_' cfg.protocol '_decim.log'];
            fprintf(1,'\n Command executed: %s \n',command);
            [st,wt] = system(command);
            
            if st ~=0
                error(strcat('ERROR : error in downsampling:',wt));
            end
            if ~isfield(cfg,'no_data_sss')
                
                
                movefile( [subj '_' cfg.protocol '_' num2str(irun) '_decim_raw.fif'],[subj '_' cfg.protocol '_' num2str(irun) '_decim_sss.fif'],'f'); % RENAMING DECIMATED SSS FILE TO subj '_' cfg.protocol '_' num2str(irun) '_sss.fif'
                fprintf('\n DECIMATION OF SSS FILE COMPLETE \n')
                
            else
                
                fprintf('\n DECIMATION OF RAW FILE COMPLETE \n')
                
            end
            
            fprintf('\n \DONE DECIMATING THE DATA. Success! %d\n ',irun)
            fprintf('\n Changing permissions of files created by this script \n')
            [success,messageid]=system(['setgrp acqtal *'])
            [success,messageid]=system(['chmod 775 *'])
        catch
            fprintf(1,'\n Failed run %d \n',irun);
            
            continue
        end
    end
end

diary off % Ending Diary

filename=strcat(subj,'_do_sss_decimation_combined_cfg');
save(filename,'cfg','visitNo','run','erm_run','subj');
