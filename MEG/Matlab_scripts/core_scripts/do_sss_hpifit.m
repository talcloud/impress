function [cfg]= do_sss_hpifit(subj,visitNo,run,cfg)

%%
%  Authors: Sheraz Khan <sheraz@nmr.mgh.harvard.edu>
%           Santosh Ganesan <santosh@nmr.mgh.harvard.edu>
%           Fahimeh Mamashli Date: 15 January, 2014
%  This function performs HPI FIT on the raw data.
%  Local variables:
%   1) subj = subject name
%   2) visitNo = visit number
%   3) run = run number
%   4) cfg = data structure with global variables
%   5) cfg.start_run_from // if set, with multiple runs, will start sss from that run. For example, cfg.start_run_from=2, function will begin from run 2

% Output: cfg.frame_tag

% Output: cfg.movecomp_tag

% Output: cfg.sss_trans_tag

%% Error Check
if isfield(cfg,'error_mode')
    
    file= exist(strcat(subj,'_do_sss_hpifit_error_cfg.mat'),'file');
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
data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
cd(data_subjdir)
%% HPI Fit

diary(strcat(subj,'_sss_hpifit_',datestr(clock),'.info')); % Starting Diary
diary on

if ~isfield(cfg,'start_run_from')
    cfg.start_run_from=1;    % field allows flexibility to start pre-processing not from run 1
end

for irun = cfg.start_run_from:run
    try
        cfg.sss_trans_tag{irun} = [' -trans ' subj '_' cfg.protocol '_1_sss.fif']; % sets transformation of all runs, IF SPECIFIED LATER in the pipeline, to RUN 1
        cfg.in_fif{irun}= strcat(subj,'_',cfg.protocol,'_',num2str(irun),'_raw.fif');% takes in raw file
        
        
        %  [c
        %  hpifit]=system(['/usr/pubsw/packages/mne/nightly/bin/mne_show_fiff --in ' cfg.in_fif{irun} ' --tag 242 --verbose']); % running hpifit
        [c hpifit]=system(['mne_show_fiff --in ' cfg.in_fif{irun} ' --tag 242 --verbose']); % running hpifit
        hpi_result=strfind(hpifit,'accept');
        
        if ~isempty(hpi_result)
            fprintf('\n HPI fit for this subject is GOOD \n')
            fprintf('\n Computing head centre for subject \n')
            computecenterflag = 1;
            if isfield(cfg,'manual_head_value') % allows for top level input of head center
                if length(cfg.manual_head_value)~=3
                    error('You have not entered manual head center values properly, Please enter in following format: cfg.manual_head_value=[0,0,40] : Thank you');
                    
                end
                
                cfg.frame_tag{irun} =[' -frame head -origin  ' num2str(cfg.manual_head_value(1)) ' ' num2str(cfg.manual_head_value(2)) ' ' num2str(cfg.manual_head_value(3))]; % Sets frame tag
            else
                if(~computecenterflag)
                    cfg.frame_tag{irun} =' -frame head -origin 0 0 40 ';
                    fprintf('\n Head center not established: Setting frame tag to 0 0 40 \n')
                else
                    [ctr, radius, hs] = computecenterofsphere(cfg.in_fif{irun}); % computes the center of sphere
                    ctr = num2str(round(ctr*1000)');
                    cfg.frame_tag{irun} = [' -frame head -origin ' ctr ' '];
                    fprintf(1,'\n Computed head centre: %s \n',ctr);
                end
            end
            cfg.movecomp_tag{irun}=' -movecomp inter ';
            
            if irun==1
                cfg.sss_trans_tag{irun}= '';
            end
            
        else
            fprintf('\n HPI fit is BAD. using device frame co-ordinate system \n')
            cfg.frame_tag{irun} = '';
            cfg.movecomp_tag{irun}='' ;
            
        end
    catch
        
        fprintf(1,'\n Failed run %d \n',irun);
        continue
    end
    
    
end


if isfield(cfg,'manual_frame_tag')
    cfg.frame_tag{irun}=cfg.manual_frame_tag{irun};
    cfg.movecomp_tag{irun}='' ;
end

% fprintf('\n Changing permissions of files created by this script \n')
%[success,messageid]=system(['setgrp acqtal *'])
%[success,messageid]=system(['chmod 775 *'])
diary off % Ending Diary

filename=strcat(subj,'_do_sss_hpifit_cfg'); % saves cfg structure
save(filename,'cfg','visitNo','run','subj');% saves cfg structure