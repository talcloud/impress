function [cfg]= do_sss_no_movementcomp_combined(subj,visitNo,run,erm_run,cfg)
%% Description
% Generates ERM-SSS & Data-SSS of the data of all subjects for a
% paradigm. Assumes default subject list.
%--------------------------------------
% Dr Engr. Sheraz Khan,  P.Eng, Ph.D.
% Engr. Nandita Shetty,  MS.
%
% Date::  October, 2010

% Modified By Santosh Ganesan
% Date:   June 15, 2011
%--------------------------------------
% Local variables:

%   1) subj = subject name
%   2) visitNo = visit number
%   3) run = run number
%   4) erm_run = erm run number, usually 1
%   5) cfg = data structure with global variables
% cfg.frame_tag must be input, taken from do_sss_hpifit.m
% cfg.bad_ch must be input, taken from do_sss_bad_channels.m
% OPTIONS:
%   1) cfg.erm_sss // if set (cfg.erm_sss=[]), skips sss on erm
%   2) cfg.erm_linefreq // if set, erm line frequency equals 60
%   3) cfg.format // if set, format is short
%   4) cfg.no_data_sss // if set, sss is not performed on data
%   5) cfg.start_run_from // if set, with multiple runs, will start sss from that run. For example, cfg.start_run_from=2, function will begin from run 2
%   6) cfg.frame_tag // if set, will provide mne with head alignment
%% Error Check
if isfield(cfg,'error_mode')
    
    file= exist(strcat(subj,'_do_sss_no_movementcomp_combined_error_cfg.mat'),'file');
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


%% ERM SSS
diary(strcat(subj,'_erm_mne_preproc_SSS_no_movementcomp',datestr(clock),'.info')); % Starting Diary
diary on

if ~isfield(cfg,'erm_sss'), % Field establishes whether sss has been performed on erm
    cd(erm_subjdir) % cd to the fif dir
    
    if ~isfield(cfg,'erm_linefreq'),
        cfg.erm_linefreq=' 60'; % sets line frequency for erm
    end
    
    if ~isfield(cfg,'format'),
        cfg.format=' short'; % default format in maxfilter is short unless otherwise specified
    end
    
    fprintf(1,'\n Beginning erm pre-processing for SUBJECT: %s \n',subj);
    fprintf(1,'\n Analyzing paradigm: %s\n',subj);
    
    
    for irun=1:erm_run,
        
        cfg.erm_frame_tag = ' -frame device -origin 0 13 -6 '; % if hpi fit is not good, use a device frame co-ordinate system
        
        
        % MAXFILTER COMMAND
        if isfield(cfg,'sss_cal')
            command=['/space/orsay/8/megdev/megsw-neuromag/bin/util/maxfilter -f  ' subj '_' 'erm' '_' num2str(irun) '_raw.fif'...
                ' -o  '  subj '_' 'erm' '_' num2str(irun) '_sss.fif ' ' -autobad on -linefreq',cfg.erm_linefreq...
                ' -format ',cfg.format, ' -ctc ' cfg.sss_ctc ' -cal ' cfg.sss_cal ' -force ' cfg.erm_frame_tag ' -v >& ' subj '_' 'erm' '_' num2str(irun) '_sss.log'];
        else
            command=['/space/orsay/8/megdev/megsw-neuromag/bin/util/maxfilter -f  ' subj '_' 'erm' '_' num2str(irun) '_raw.fif'...
                ' -o  '  subj '_' 'erm' '_' num2str(irun) '_sss.fif ' ' -autobad on -linefreq',cfg.erm_linefreq...
                ' -format ',cfg.format, ' -force ' cfg.erm_frame_tag ' -v >& ' subj '_' 'erm' '_' num2str(irun) '_sss.log'];
        end
        [st,wt] = unix(command)
        fprintf(1,'\n Command executed: %s \n',command);
        
        if st ~=0
            error('ERROR : check maxfilter step')
        end
    end
    
    cfg.erm_sss=1; % indicates successful sss of erm
else
    fprintf('erm_sss field is true; indicates that erm sss has already been performed %s\n',subj);
end
diary off % Ending Diary


%% SSS without Movement Compensation
diary(strcat(subj,'_sss_without_movement_comp.info')); % Starting Diary
diary on
if ~isfield(cfg,'no_data_sss')
    fprintf(1,'\n Beginning sss pre-processing for SUBJECT: %s \n',subj);
    
    cd(data_subjdir) % cd to the fif dir
    if ~isfield(cfg,'frame_tag')
        fprintf('Please check HPI Fit/ function:do_sss_hpifit: Thank you');
    end
    
    if ~isfield(cfg,'start_run_from')
        cfg.start_run_from=1; % field allows flexibility to start pre-processing not from run 1
    end
    
    
    for irun = cfg.start_run_from:run
        try
            
            if ~isfield(cfg,'HPI_DROP_COUNTER')
                fprintf('warning, no HPI_DROP_COUNTER value set: SSS with movement compensation may not have been performed');
                cfg.HPI_DROP_COUNTER{irun}='';
            end
            
            if length(cfg.HPI_DROP_COUNTER)<irun
                fprintf('warning, no HPI_DROP_COUNTER value set: HPI FIT MAY BE BAD FOR RUN  %d \n', irun);
                cfg.HPI_DROP_COUNTER{irun}='';
            end
            
            if ~isfield(cfg,'format'),
                cfg.format=' short'; % default format in maxfilter is short unless otherwise specified
            end
            
            if length(cfg.format)<irun
                cfg.format{irun}=' short'; % default format in maxfilter is short unless otherwise specified
            end
            
            if ~isfield(cfg,'frame_tag')
                cfg.frame_tag{irun} = '';
                fprintf('warning, no frame_tag HPI may be bad: SSS with movement compensation may not have been performed');
            end
            
            if length(cfg.frame_tag)<irun
                cfg.frame_tag{irun} = '';
                fprintf('warning, no frame_tag HPI may be bad: SSS with movement compensation may not have been performed');
            end
            
            if (cfg.HPI_DROP_COUNTER{irun} >=20) % For counter values greater than 20, sss without movement compensation is performed
                no_movement_comp=1;
            elseif isfield(cfg,'without_movement_option')
                no_movement_comp=1;
            elseif isempty(cfg.frame_tag{irun})
                no_movement_comp=1;
            else
                no_movement_comp=0;
            end
            
            if no_movement_comp==1
                fprintf(1,'\n PERFORMING SSS WITHOUT MOVEMENT COMPENSATION, RUN NUMBER: %d \n',irun);
                cfg.testdir=dir('badch.txt');
                
                if (cfg.do_sss_bad_channels==0) || cfg.testdir.bytes==0
                    fprintf('THERE ARE NO BAD CHANNELS DETECTED');
                    
                    badchannelcommand=' ';
                else
                    badchannelcommand= [' -bad '  char(cfg.badch{irun})];
                    
                end
                
                if isfield(cfg,'device_fit')
                    cfg.device_fit=' ';
                    % head_device= [' -frame device -origin ' num2str(cfg.frame_tag{irun})];
                    head_device= [' -frame device ' num2str(cfg.frame_tag{irun})];
                    fprintf(1,'\n PERFORMING SSS WITHOUT MOVEMENT COMPENSATION WITH DEVICE TRANSFORMATION');
                    
                else
                    cfg.device_fit=' ';
                    head_device=cfg.frame_tag{irun};
                    
                end
                
                if isfield(cfg,'sss_cal')
                command=['/space/orsay/8/megdev/megsw-neuromag/bin/util/maxfilter -f  '  subj '_' cfg.protocol '_' num2str(irun) '_raw.fif'...
                    ' -o  '  subj '_' cfg.protocol '_' num2str(irun) '_sss.fif ' ' -autobad off    ' ...
                    ' -format',cfg.format, ' -ctc ' cfg.sss_ctc ' -cal ' cfg.sss_cal ' -force ',cfg.device_fit, badchannelcommand head_device   ' -v >& ' subj '_' cfg.protocol '_' num2str(irun) '_sss_without_move_comp.log'];
                else
                command=['/space/orsay/8/megdev/megsw-neuromag/bin/util/maxfilter -f  '  subj '_' cfg.protocol '_' num2str(irun) '_raw.fif'...
                    ' -o  '  subj '_' cfg.protocol '_' num2str(irun) '_sss.fif ' ' -autobad off    ' ...
                    ' -format',cfg.format, ' -force ',cfg.device_fit, badchannelcommand head_device   ' -v >& ' subj '_' cfg.protocol '_' num2str(irun) '_sss_without_move_comp.log'];
                end    
                fprintf(1,'\n Command executed: %s \n',command);
                
                [st,wt] = system(command)
                
                if st ~=0
                    error(strcat('ERROR : check maxfilter step 2/ SSS without Movement Compensation:',wt));
                end
                % Saving movement comp figure
                fprintf('\n Ploting and saving movement compensation result \n')
                cfg.logfile_without_movement_comp{irun}= strcat(subj, '_', cfg.protocol, '_', num2str(irun), '_sss_without_move_comp.log');
                movecomp( cfg.logfile_without_movement_comp{irun});
                close(figure);
                clear no_movement_comp
            else
                fprintf(1,'\n Not performing SSS without movement compensation for this run: %d \n',irun)
                
                
            end
        catch
            fprintf(1,'\n Failed run %d \n',irun);
            
            
            continue
        end
        
        
        
    end
    
    
    fprintf('\n SSS Without Movement Compensation: Successful \n')
    fprintf('\n Changing permissions of files created by this script \n')
    [success,messageid]=system(['setgrp acqtal *'])
    [success,messageid]=system(['chmod 775 *'])
else
    fprintf(1,'\n SSS data is turned off:cfg.no_data_sss is enabled \n');
end
diary off % Ending Diary

filename=strcat(subj,'_do_sss_no_movementcomp_combined_cfg');
save(filename,'cfg','visitNo','run','erm_run','subj');