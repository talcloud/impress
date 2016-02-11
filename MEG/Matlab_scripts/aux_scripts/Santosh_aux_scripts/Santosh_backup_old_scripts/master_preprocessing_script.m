function [subj,visitNo,run,cfg]=master_preprocessing_script(subj,visitNo,run,erm_run,cfg)


%% Subject Directory

data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
cd(data_subjdir);
diary(strcat(subj,'_master_preprocessing_.info'));
diary on


%% Tasks

  if ~isfield(cfg,'do_erm_and_data_sss_main')
       try
        cfg.do_erm_and_data_sss_main=1;
        fprintf('Performing do_erm_and_data_sss_main %s\n',subj);
        [subj,visitNo,run,cfg]=do_erm_and_data_sss_main(subj,visitNo,run,erm_run,cfg);
       catch ERM_and_DATA_SSS_ERROR
           cd(data_subjdir);
           filename=strcat(subj,'_ERM_and_DATA_SSS_ERROR_cfg');
           save(filename,'cfg','visitNo','run','erm_run','subj','ERM_and_DATA_SSS_ERROR');
       end
  else
        fprintf('Not Performing do_erm_and_data_sss_main %s\n',subj);
  end
  
  
  if ~isfield(cfg,'do_mne_preproc_main')
      try
        cfg.do_mne_preproc_main=1;
        fprintf('Performing do_mne_preproc_main %s\n',subj);
        [subj,visitNo,run,cfg]=do_mne_preproc_main(subj,visitNo,run,erm_run,cfg);
      catch MNE_PREPROC_ERROR
          cd(data_subjdir);
           filename=strcat(subj,'_MNE_PREPROC_ERROR_cfg');
           save(filename,'cfg','visitNo','run','subj','MNE_PREPROC_ERROR');
        
      end
  else
        fprintf('Not Performing do_mne_preproc_main %s\n',subj);
  end

  if ~isfield(cfg,'do_calc_forward_inverse_main')
      try
        cfg.do_calc_forward_inverse_main=1;
        fprintf('Performing do_mne_preproc_main %s\n',subj);
        [subj,visitNo,run,cfg]=do_calc_forward_inverse_main(subj,visitNo,run,cfg);
      catch CALC_FORW_INV_ERROR
          cd(data_subjdir);
          filename=strcat(subj,'_CALC_FORW_INV_ERROR_cfg');
           save(filename,'cfg','visitNo','run','subj','CALC_FORW_INV_ERROR');
         
      end
  else
        fprintf('Not Performing do_calc_forward_inverse_main %s\n',subj);
  end  
  
   if ~isfield(cfg,'do_epochMEG_main')
     try
        cfg.do_epochMEG_main=1;
        fprintf('Performing do_epochMEG_main %s\n',subj);
       [subj,visitNo,run,cfg]=do_epochMEG_main(subj,visitNo,run,cfg);
     catch epochMEG_ERROR
         cd(data_subjdir);
          filename=strcat(subj,'_epochMEG_ERROR_cfg');
           save(filename,'cfg','visitNo','run','subj','epochMEG_ERROR');
     end
    else
        fprintf('Not Performing do_epochMEG_main %s\n',subj);
    end  
  
%%

diary off

filename=strcat(subj,'_master_preprocessing_cfg');
save(filename,'cfg','visitNo','run','erm_run','subj');

