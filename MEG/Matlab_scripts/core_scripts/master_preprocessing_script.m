function [subj,visitNo,run,cfg]=master_preprocessing_script(subj,visitNo,run,erm_run,cfg)

%   Sheraz Khan <sheraz@nmr.mgh.harvard.edu>
%   Santosh Ganesan <santosh@nmr.mgh.harvard.edu>
%   CALCULATE INVERSE OPERATOR
% Local variables:
%   1) subj = subject name
%   2) visitNo = visit number
%   3) run = run number
%   4) erm_run = erm run number, usually 1
%   5) cfg = data structure with global variables


%% Tasks

  if ~isfield(cfg,'do_erm_and_data_sss_main')
       
        cfg.do_erm_and_data_sss_main=1;
        fprintf('Performing do_erm_and_data_sss_main %s\n',subj);
        [subj,visitNo,run,cfg]=do_erm_and_data_sss_main(subj,visitNo,run,erm_run,cfg);

  else
        fprintf('Not Performing do_erm_and_data_sss_main %s\n',subj);
  end
  
  
  if ~isfield(cfg,'do_mne_preproc_main')
     
        cfg.do_mne_preproc_main=1;
        fprintf('Performing do_mne_preproc_main %s\n',subj);
        [subj,visitNo,run,cfg]=do_mne_preproc_main(subj,visitNo,run,erm_run,cfg);        
     
  else
        fprintf('Not Performing do_mne_preproc_main %s\n',subj);
  end

  if ~isfield(cfg,'do_calc_forward_inverse_main')
    
        cfg.do_calc_forward_inverse_main=1;
        fprintf('Performing do_mne_preproc_main %s\n',subj);
        [subj,visitNo,run,cfg]=do_calc_forward_inverse_main(subj,visitNo,run,cfg,erm_run);
              
  else
        fprintf('Not Performing do_calc_forward_inverse_main %s\n',subj);
  end  
  
   if ~isfield(cfg,'do_epochMEG_main')
    
       cfg.do_epochMEG_main=1;
       fprintf('Performing do_epochMEG_main %s\n',subj);
       [subj,visitNo,run,cfg]=do_epochMEG_main(subj,visitNo,run,cfg);
    
    else
        fprintf('Not Performing do_epochMEG_main %s\n',subj);
    end  
  
%%

diary off

filename=strcat(subj,'_master_preprocessing_cfg');
save(filename,'cfg','visitNo','run','erm_run','subj');

