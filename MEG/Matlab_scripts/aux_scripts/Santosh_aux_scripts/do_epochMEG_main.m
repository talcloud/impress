function [subj,visitNo,run,cfg]=do_epochMEG_main(subj,visitNo,run,cfg)
addpath('/autofs/space/marvin_001/users/MEG/scripts/kenet/ml/curr/Santosh/SVN/Private_epochMEG/')
diary(strcat(subj,'_epochMEG_main_.info'));
diary on
%% config file

    % Necessary for the main functions
    
    cfg.do_epochMEG=1;
   % Necessary parameters: Place set values here
    
%       cfg.data_rootdir=[];      % cfg.rootdir
%       cfg.protocol=[];          % cfg.protocol
      % emo1 cfg.epochMEG_time=[-.3,1];        % Please enter tmin & tmax in the following format:
                                        % cfg.epochMEG_time=[tmin,tmax];
                                        
     % wmm     cfg.epochMEG_time=[-.4,1.2];                              
%       cfg.epochMEG_time=[-.2,2]; 
% %        cfg.epochMEG_event_order{1}=[1,4];
% %       cfg.epochMEG_event_order{2}=[2,5];
%          cfg.newevents(1)=[997];
%           cfg.newevents(2)=[998];
                                % Please specify event order,
                                % for example, event=[1,4,2,5];
                                
%        cfg.epochMEG_merge_events=[];                        
                
   % Optional parameters:                           
%       cfg.epochMEG_baseline=[]; % Please enter tmin & tmax in the following format:
%                                 % cfg.epochMEG_baseline=[bmin bmax]
%                                 % If EMPTY, BASELINE CORRECTION WILL NOT BE
%                                 % IMPLEMENTED
%                                 
%  
%       
%   
%      
%                                 
%                                 % Filename Example Convention
%                                 
%                                 % Filename=<subject_protocol_run_(insert-highpass-setting)-(insert-lowpass-setting)fil_raw.fif>
%                                 
%                                 % If cfg.epochMEG_filename parameter is left
%                                 % EMPTY, then the parameter is equal to cfg.fil_fif, output from do_mne_preproc_filtered
%        
%        cfg.epochMEG_eventfilename=[];
%        
%                                 % If Input =1, eventfile name is 'ecgClean'
%                                 % If Input =2, eventfile name is 'ecgeogClean'
%                                 % If Input =3, eventfile name is 'sss'
%                                 % Eventfile Example Convention
%                                 % Eventfile=<subject_protocol_run_cfg.epochMEG_run_eventfilename_raw-eve.fif>
% 
%        
%                                 % If cfg.epochMEG_filename parameter is left
%                                 % EMPTY, then the parameter is equal to cfg.removeECG_EOG, output from do_mne_preproc_filtered
%                                 
%         
%                                 
%         cfg.epochMEG_filt=[];   % cfg.epochMEG_filt/ Please set value of the filter bands here for do_epochMEG
%                                 % IF EMPTY, will take on values of
%                                 % cfg.mne_preproc_filt, whose DEFAULT
%                                 % FILTERING IS AT
%                                 % at highpass 1 Hz and lowpass of 144 Hz
%                                 
%                                 % The structure is as follows:
%                                 % cfg.epochMEG_filt.lpf(1)=40;
%                                 % cfg.epochMEG_filt.hpf(2)=2;
%                                 % cfg.epochMEG_filt.lpf(1)=98;
%                                 % cfg.epochMEG_filt.hpf(2)=0;
%                                 % Filter Bands set between 2-40Hz & 0-98 Hz   
%                                 
%      

                                
         
        
%% Actions

fprintf('Starting Specified Actions %s\n',subj); 


if (cfg.do_epochMEG)
    try
    fprintf('Starting epochMEG %s\n',subj);    
    [cfg]=do_epochMEG(subj,visitNo,run,cfg);
    fprintf('Complete ! %s\n',subj);

    catch ME
        cfg.current=ME.stack.name;
        data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
        cd(data_subjdir)
        filename=strcat(subj,'_do_epochMEG_error_cfg');
        save(filename,'cfg','visitNo','run','subj','ME');
       
    
    end 

end



data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
cd(data_subjdir)                               
filename=strcat(subj,'_epochMEG_main_cfg');
save(filename,'cfg','visitNo','run','subj');      
diary off
