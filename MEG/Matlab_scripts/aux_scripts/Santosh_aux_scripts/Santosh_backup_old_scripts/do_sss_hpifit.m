function [cfg]= do_sss_hpifit(subj,visitNo,run,cfg)
%% Error Check
if isfield(cfg,'current')
    I=strmatch(cfg.current,'do_sss_hpifit');
           if isempty(I)
               return
           else
               cfg=rmfield(cfg, 'current');
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
cd(data_subjdir) % cd to the fif dir
%% HPI Fit

diary(strcat(subj,'_sss_hpifit_.info'));
diary on

if ~isfield(cfg,'start_run_from')
cfg.start_run_from=1;
end

for irun = cfg.start_run_from:run
    try    
        cfg.sss_trans_tag{irun} = [' -trans ' subj '_' cfg.protocol '_1_raw.fif']; % transforms head position in accordance to run 1
        cfg.in_fif{irun}= strcat(subj,'_',cfg.protocol,'_',num2str(irun),'_raw.fif');

        [c hpifit]=system(['/usr/pubsw/packages/mne/nightly/bin/mne_show_fiff --in ' cfg.in_fif{irun} ' --tag 242 --verbose']); % extract info on goodness of hpi fit
    
                if str2num(hpifit(27))==1 %#ok<ST2NM> % check if hpi fit is good or not
                    fprintf('\n HPI fit for this subject is GOOD \n')
                    fprintf('\n Computing head centre for subject \n')
                    computecenterflag = 1;
                            if(~computecenterflag)
                            cfg.frame_tag{irun} =' -frame head -origin 0 0 40 '; % if hpi fit is good, use a head frame co-ordinate system
                            else
                            [ctr, radius, hs] = computecenterofsphere(cfg.in_fif{irun}); %#ok<NASGU>
                            ctr = num2str(round(ctr*1000)'); % 1000 for going from m to mm
                            cfg.frame_tag{irun} = [' -frame head -origin ' ctr ' '];
                            fprintf(1,'\n Computed head centre: %s \n',ctr);
                            end
                            cfg.movecomp_tag{irun}=' -movecomp inter ';
        
                            if irun==1
                            cfg.sss_trans_tag{irun}= '';
                            end

                else
                     fprintf('\n HPI fit is BAD. using device frame co-ordinate system \n')
                     cfg.frame_tag{irun} = ' -frame device -origin 0 13 -6 '; % if hpi fit is not good, use a device frame co-ordinate system
                     cfg.movecomp_tag{irun}='' ;
                            
                end
    catch
        
        fprintf(1,'\n Failed run %d \n',irun);
    continue
    end
end                 
    fprintf('\n Changing permissions of files created by this script \n')
    ! /usr/pubsw/bin/setgrp acqtal *
    ! chmod 775 
diary off

        filename=strcat(subj,'_do_sss_hpifit_cfg');
        save(filename,'cfg','visitNo','run','subj');