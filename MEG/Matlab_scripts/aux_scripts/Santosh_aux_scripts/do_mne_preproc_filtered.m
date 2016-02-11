function [cfg]=do_mne_preproc_filtered(subj,visitNo,run,cfg)
  %% Error Check
if isfield(cfg,'error_mode')
    
   file= exist(strcat(subj,'_do_mne_preproc_filtered_error_cfg.mat'),'file');
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
data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
cd(data_subjdir) % cd to the fif dir
%% MNE Preproc Filtered

diary(strcat(subj,'_mne_preproc_filtered.info'));
diary on

    if ~isfield(cfg,'mne_preproc_filt')
        cfg.mne_preproc_filt.hpf(1)=1;
        cfg.mne_preproc_filt.lpf(1)=144;
        fprintf(' highpass    %d to lowpass %d\n', cfg.mne_preproc_filt.hpf(1),cfg.mne_preproc_filt.lpf(1));
        cfg.mne_preproc_filt.hpf(1)=2;
        cfg.mne_preproc_filt.lpf(1)=20;
        fprintf(' highpass    %d to lowpass %d\n', cfg.mne_preproc_filt.hpf(2),cfg.mne_preproc_filt.lpf(2));

    else
    
  cfg.mne_preproc_filt.hpf(length(cfg.mne_preproc_filt.hpf)+1)=2;
  cfg.mne_preproc_filt.lpf(length(cfg.mne_preproc_filt.lpf)+1)=20;
    end
    

    
    
    if (length(cfg.mne_preproc_filt.lpf)~=length(cfg.mne_preproc_filt.hpf))
    
            error(' There is something funky with the low pass and high pass settings you have entered, Please recheck');
    else
            fprintf('Starting to Filtering %s\n',subj);
    end

    
    if (cfg.removeECG_EOG==1),
                cfg.preproc_filtered_file_tag='ecgClean';
    
    elseif (cfg.removeECG_EOG==2),
                cfg.preproc_filtered_file_tag='ecgeogClean';
    else
                cfg.preproc_filtered_file_tag='sss';
    end

    if ~isfield(cfg,'start_run_from')
    cfg.start_run_from=1;
    end
    
        for irun=cfg.start_run_from:run,
            
            
                            
            cfg.mne_preproc_raw_tag{irun} = ['--raw ' subj '_' cfg.protocol '_',num2str(irun),'_',cfg.preproc_filtered_file_tag,'_raw.fif ']; % takes as input raw files who's ecg component has been removed i.e <subj>_<paradigm>_<run>_ecgClean_raw.fif
               try
                for ifilter=1:length(cfg.mne_preproc_filt.hpf),
                                      
                    
                    fprintf(1,'\n filtering: highpass  %d to lowpass %d\n',cfg.mne_preproc_filt.hpf(ifilter),cfg.mne_preproc_filt.lpf(ifilter));
  
                    
                    cfg.fil_fif{irun}=[subj, '_', cfg.protocol,'_',num2str(irun),'_',num2str(cfg.mne_preproc_filt.hpf(ifilter)),'_',num2str(cfg.mne_preproc_filt.lpf(ifilter)),'fil.fif '];

                    command = ['mne_process_raw ' cfg.mne_preproc_raw_tag{irun} ' --lowpass  ', num2str(cfg.mne_preproc_filt.lpf(ifilter)),' --highpass  ',num2str(cfg.mne_preproc_filt.hpf(ifilter)),...
                        ' --projon  ',' --save ' cfg.fil_fif{irun}];
            
                    [st,wt] = unix(command);
                    fprintf(1,'\n Command executed: %s \n',command);
                    fprintf(1,'\n Run: %d\n', irun);
                    fprintf(1,'\n filtering: highpass  %d to lowpass %d\n',cfg.mne_preproc_filt.hpf(ifilter),cfg.mne_preproc_filt.lpf(ifilter));

                    if st ~=0
           
                    error('ERROR : error in computing filtered file highpass  %d to lowpass %d\n',cfg.mne_preproc_filt.hpf(ifilter),cfg.mne_preproc_filt.lpf(ifilter))
                     continue
                    else

                    fprintf(1,'\n Success!: highpass  %d to lowpass %d\n',cfg.mne_preproc_filt.hpf(ifilter),cfg.mne_preproc_filt.lpf(ifilter));
                    end 
           
      
                end
               catch
                   fprintf(1,'\n Filtering failed highpass  %d to lowpass %d for run  %d\n',cfg.mne_preproc_filt.hpf(ifilter),cfg.mne_preproc_filt.lpf(ifilter),irun);
               continue
               end
        end
        
   cfg.mne_preproc_filt.hpf=cfg.mne_preproc_filt.hpf(1:length(cfg.mne_preproc_filt.hpf)-1);
  cfg.mne_preproc_filt.lpf=cfg.mne_preproc_filt.lpf(1:length(cfg.mne_preproc_filt.lpf)-1);
        filename=strcat(subj,'_do_mne_preproc_filtered_cfg');
        save(filename,'cfg','visitNo','run','subj');
diary off
