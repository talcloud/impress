function [cfg]=do_mne_preproc_heartbeat(subj,visitNo,run,cfg)
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

if ~isfield(cfg,'removeECG_EOG'),
 cfg.removeECG_EOG=2;
 fprintf('\n Remove ECG_EOG is not set %s\n',subj); 
 fprintf('\n Default will be used/ Removal of ECG & EOG! %s\n',subj); 
 fprintf('\n ECG_EOG=2! %s\n',subj);    
end
data_subjdir=[cfg.data_rootdir,'/',subj '/' num2str(visitNo) '/'];
cd(data_subjdir) % cd to the fif dir
%% Removal of heart-beat component

diary(strcat(subj,'_mne_preproc_heartbeat.info'));
diary on

if ~isfield(cfg,'start_run_from')
cfg.start_run_from=1;
end

if ~isfield(cfg,'no_erm_decimation'),
 cfg.in_fif_erm=strcat(subj,'_erm_1_sss.fif');

else

 cfg.in_fif_erm=strcat(subj,'_erm_1_dec_sss_raw.fif');

end



   for irun=cfg.start_run_from:run
       
      
                           
                           if isfield(cfg,'no_data_decimation');
                         
                              fprintf(1,'\n MNE Preproc on undecimated data %d\n',irun); 

                           else
                          
                              fprintf(1,'\n MNE Preproc on decimated data %d\n',irun); 

                           end    
       
       
       error_handler=0;
       while error_handler<=2,
      
                if cfg.removeECG_EOG==1
                        try
                           
                              cfg.in_fif{irun} = strcat(subj,'_',cfg.protocol,'_',num2str(irun),'_sss.fif');

                                cfg.out_fif{irun} = strcat(subj,'_',cfg.protocol,'_',num2str(irun),'_ecgClean.fif');
                                cfg.out_fif_erm = strcat(subj,'_erm_1_sss_ecgClean_applied.fif');

                                cfg.in_path{irun}=data_subjdir;
%                                 cfg.projectfile= strcat(subj,'_',cfg.protocol,'_',num2str(irun),'_proj','.fif');
                                cfg.eventFileName =strcat(subj,'_',cfg.protocol,'_',num2str(irun),'_ecgClean_raw-eve','.fif');
                                fprintf(1,'\n Implementing ECG artifact rejection on data \n');
                                [cfg]=clean_ecg(cfg.in_fif{irun},cfg.out_fif{irun},cfg.eventFileName,cfg.in_path{irun},cfg,visitNo,subj,irun); % check channel STI014
                                error_handler=3;
                        catch
                         fprintf(1,'\n Heartbeat Artifact Rejection failed  %d\n',irun); 
                         error_handler=3;
                         continue
                        end

                                
                 elseif cfg.removeECG_EOG==2
                    
                          try   
                                            cfg.in_fif{irun} = strcat(subj,'_',cfg.protocol,'_',num2str(irun),'_sss.fif');

                                cfg.out_fif{irun} = strcat(subj,'_',cfg.protocol,'_',num2str(irun),'_ecgeogClean.fif');
                                   
                                cfg.out_fif_erm = strcat(subj,'_erm_1_sss_ecgeogClean_applied.fif');

                                cfg.in_path{irun}=data_subjdir;
                                cfg.projectfile= strcat(subj,'_',cfg.protocol,'_',num2str(irun),'_proj','.fif');
                                cfg.eventFileName =strcat(subj,'_',cfg.protocol,'_',num2str(irun),'_ecgeogClean_raw-eve','.fif');
                                fprintf(1,'\n Implementing ECG and EOG artifact rejection on data \n')
                                [cfg]=clean_ecgeog(cfg.in_fif{irun},cfg.out_fif{irun},cfg.projectfile,cfg.eventFileName,cfg.in_path{irun},cfg,visitNo,subj,irun); % check channel STI014
                                error_handler=3;
                          catch
                              
                              fprintf(1,'\n Blink Artifact Rejection failed  %d\n',irun);
                              fprintf('\n Trying only ECG Clean\n')
                              cfg.removeECG_EOG=1;
                             
                          continue
                          end 

                 else 
                                display('No ECG, EOG artifacts removed')



                 end
                
            

       end
   end
            
%%
           filename=strcat(subj,'_do_mne_preproc_heartbeat_cfg');
        save(filename,'cfg','visitNo','run','subj');
diary off