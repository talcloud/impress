function [subj,visitNo,run,cfg]=master_preprocessing_script(subj,visitNo,run,erm_run,cfg)


%% Subject Directory

% data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
% cd(data_subjdir);
% diary(strcat(subj,'_master_preprocessing_.info'));
% diary on
% 
% badch_filename=strcat(subj,'_do_sss_bad_channels_cfg.mat');
% load(badch_filename);
% cfg=rmfield(cfg,'do_erm_and_data_sss_main');
% cfg=rmfield(cfg,'do_sss_movementcomp_combined');
% cfg=rmfield(cfg,'do_sss_no_movementcomp_combined');
% cfg=rmfield(cfg,'do_sss_transform_allrunsto_singlerun');
% cfg=rmfield(cfg,'do_sss_decimation_combined');
% 
% %         cfg.do_erm_and_data_sss_main=[];
%  
%                  cfg.do_sss_hpifit=[];
%                  cfg.do_sss_bad_channels=[];
% %                  cfg.do_sss_movementcomp_combined=[];
% %                 cfg.do_sss_no_movementcomp_combined=[];
% %                 cfg.do_sss_transform_allrunsto_singlerun=[];
% %                cfg.do_sss_decimation_combined=[];
%                  cfg.do_erm_filtering=[];
%                   cfg.do_erm_noise_covariance=[];
% %     cfg.do_mne_preproc_main=[];
% 
%             %     cfg.do_mne_preproc_heartbeat=[];
% %                                 cfg.do_erm_filtering_mne=[];
% %                    cfg.do_erm_noise_covariance_mne=[];
% %                 cfg.do_mne_preproc_filtered=[];
% %                 cfg.do_mne_preproc_grand_average=[];
% 
% %         cfg.do_calc_forward_inverse_main=[];
% %                cfg.do_calc_forward=[];
% %                cfg.do_calc_inverse=[];
%             
% %          cfg.do_epochMEG_main=[];
% 
%     cfg.mne_preproc_filt.hpf(1)=.1;
%     cfg.mne_preproc_filt.lpf(1)=144;
%      cfg.filt.hpf(1)=.1;  
%         cfg.filt.lpf(1)=144;
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

