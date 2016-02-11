function [cfg]= do_sss_bad_channels(subj,visitNo,run,cfg)
%%
%  Authors: Sheraz Khan <sheraz@nmr.mgh.harvard.edu>
%           Santosh Ganesan <santosh@nmr.mgh.harvard.edu>
%           Fahimeh Mamashli
%  This function performs Bad channel detection on the raw data.
%  Local variables:
%   1) subj = subject name
%   2) visitNo = visit number
%   3) run = run number
%   4) cfg = data structure with global variables
%      cfg.frame_tag must be input, taken from do_sss_hpifit.m
%   5) cfg.start_run_from // if set, with multiple runs, will start sss from that run. For example, cfg.start_run_from=2, function will begin from run 2

% cfg.frame_tag must be input, taken from do_sss_hpifit.m
% cfg.manual_badch=[]; if provided, badch procedure will be skipped. the
% in this case, cfg.badch{runs} needs to be provided for each run.

% Output: cfg.badch
%% Error Check
if isfield(cfg,'error_mode')
    
    file= exist(strcat(subj,'_do_sss_bad_channels_error_cfg.mat'),'file');
    if file~=2
        return
    else
        delete(file);
    end
end

%% Global Variables

addpath /autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/Private_Mne_Preproc

if ~isfield(cfg,'data_rootdir'),
    error('Please enter a root directory in sub-structure cfg.data_rootdir: Thank you');
end

if ~isfield(cfg,'protocol'),
    error('Please enter a protocol name in sub-structure cfg.protocol: Thank you');
end

if ~isfield(cfg,'frame_tag'),
    error('Please check hpifit/error in sub-structure cfg.frame_tag: Thank you');
end

data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
cd(data_subjdir) % cd to the fif dir

diary(strcat(subj,'_sss_bad_channels_',datestr(clock),'.info')); % Starting Diary
diary on
%% Bad Channels


if ~isfield(cfg,'start_run_from')
    cfg.start_run_from=1;    % field allows flexibility to start pre-processing not from run 1
end



if ~isfield(cfg,'manual_badch')
    
    
    for irun = cfg.start_run_from:run
                       
            
            
            try
                
                fprintf('\n Maxfilter Step 1: IDENTIFYING BAD CHANNELS %d\n',irun)
                badchlog=[subj '_' cfg.protocol '_badch_run_' num2str(irun) '.log']; % generate bad channel file for each run
                
                if ~isfield(cfg,'bad_channel_use_whole_file')
                    
                    cfg.detection=' -autobad 20 -skip 0 2 21 999999 ';
                    % cfg.detection=' -autobad 120 -skip 0 5 120  999999 '; % Changed by Sheraz; 07/02/2014
                    fprintf(1,'\n Bad channel detection will be based on first 20 seconds of the file %s: \n', cfg.detection);
                    
                    
                else
                    cfg.detection=' -autobad on ';
                    fprintf(1,'\n Bad channel detection will be based on entirety of the file %s: \n', cfg.detection);
                end
                
                
                if isfield(cfg,'device_fit')
                    head_device= [' -frame device -origin ' num2str(cfg.frame_tag{irun})];
                else
                    head_device=cfg.frame_tag{irun};
                    %       head_device=head_device{1};
                end
                
                if isfield(cfg,'sss_cal')
                    command=['/space/orsay/8/megdev/megsw-neuromag/bin/util/i686-pc-linux-gnu/maxfilter -f  '  subj '_' cfg.protocol '_' num2str(irun) '_raw.fif  -force ' ' -ctc ' cfg.sss_ctc ' -cal ' cfg.sss_cal ' -o  '  subj '_' cfg.protocol '_' num2str(irun) '_badch.fif  '  head_device  cfg.detection ' -v >& ' badchlog ]; % maxfilter command for bad channel detection
                else
                    command=['/space/orsay/8/megdev/megsw-neuromag/bin/util/i686-pc-linux-gnu/maxfilter -f  '  subj '_' cfg.protocol '_' num2str(irun) '_raw.fif  -force ' ' -o  '  subj '_' cfg.protocol '_' num2str(irun) '_badch.fif  '  head_device  cfg.detection ' -v >& ' badchlog ]; % maxfilter command for bad channel detection
                end
                
                if isfield(cfg,'Sheraz_badch_file')
                    
                    if ~isfield(cfg,'badch_thresh')
                        thresh=2;
                    end
                    
                    filename=[data_subjdir strcat(subj,'_',cfg.protocol,'_',num2str(irun),'_raw.fif')];
                    fprintf('using Sheraz badch function \n');
                    
                    
                    detectbadchannels1(filename,thresh)
                    
                else
                    
                    fprintf(1,'\n Command executed: %s \n',command);
                    [st,wt]=system(command);
                    
                    if st ~=0
                        error(strcat('ERROR : check maxfilter step 1:',wt));
                    end
                    
                    % parsing bad channel log for bad channels
                    %badch.txt=strcat('badch_',num2str(irun),'txt');
                    %! cat step1-badch.log | sed -n  '/Static bad channels/p' | cut -f 5- -d ' '   | uniq | tee  badch.txt
                    setenv('badchlog',badchlog)
                    ! cat $badchlog | sed -n  '/Static bad channels/p' | cut -f 5- -d ' '   | uniq | tee  badch.txt
                    
                end
                
                
                fid=fopen(['badch.txt']);
                s=textscan(fid,'%s');
                
                if ~isempty(s{1})
                    temp=dlmread(['badch.txt'],' ');
                    cfg.badch{irun}=num2str(temp);
                    fprintf(1,'\n Bad channels for this run are: %s \n',cfg.badch{irun}) % writing bad channels into structure cfg.badch{irun}
                else
                    cfg.badch{irun}='';
                end
                  
                save(['badch_run' num2str(irun) '.mat'],'cfg');
                
            catch
                
                fprintf(1,'\n Failed run %d \n',irun);
                
                continue
           
            end
            
                
    end
    
end

fprintf('\n Changing permissions of files created by this script \n')
[success,messageid]=system(['setgrp acqtal *'])
[success,messageid]=system(['chmod 775 *'])
diary off % Ending Diary

filename=strcat(subj,'_do_sss_bad_channels_cfg');
save(filename,'cfg','visitNo','run','subj');