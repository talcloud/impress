function [cfg]=do_mne_preproc_grand_average(subj,visitNo,run,cfg)

  %% Error Check
if isfield(cfg,'current')
    I=strmatch(cfg.current,'do_mne_preproc_grand_average');
           if isempty(I)
               return
           else
               cfg=rmfield(cfg, 'current');
           end    
end    
     
%% Need 2 or more runs
% if run<2,
%      fprintf('cannot perform grand average! there is only 1 run');
% 
%     return
% end

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
if ~isfield(cfg,'protocol_covdir')
error('Please enter a covariance directory in sub-structure cfg.protocol_covdir: Thank you');
end

if ~isfield(cfg,'mne_preproc_filt')
cfg.mne_preproc_filt=[];
end


data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
cd(data_subjdir) % cd to the fif dir
%% MNE Preproc Grand Average

diary(strcat(subj,'_mne_preproc_grand_average.info'));
diary on

cfg.mne_preproc_grand_average=cfg.mne_preproc_filt;

    if isempty(cfg.mne_preproc_grand_average)
        cfg.mne_preproc_grand_average.hpf(1)=1;
        cfg.mne_preproc_grand_average.lpf(1)=144;
        fprintf(' highpass    %d to lowpass %d\n',  cfg.mne_preproc_grand_average.hpf(1), cfg.mne_preproc_grand_average.lpf(1));
    end
    
                if (length( cfg.mne_preproc_grand_average.lpf)~=length(cfg.mne_preproc_grand_average.hpf))
    
                    error(' There is something funky with the low pass and high pass settings you have entered, Please recheck');
                else
                    fprintf('Starting to Grand Average %s\n',subj);
                end

                           if (cfg.removeECG_EOG==1),
                            cfg.preproc_filtered_file_tag='ecgClean';
                           elseif (cfg.removeECG_EOG==2),
                            cfg.preproc_filtered_file_tag='ecgeogClean';
                           else
                            cfg.preproc_filtered_file_tag='sss';
                           end
                           
                      
                           
                           
 
        

        for igrand_avg=1:length(cfg.mne_preproc_grand_average.hpf),
            
                fprintf('Now computing grand average highpass  %d to lowpass %d\n',cfg.mne_preproc_grand_average.hpf(igrand_avg),cfg.mne_preproc_grand_average.lpf(igrand_avg))
       
                cfg.mne_preproc_grand_average_file= ['--raw ' [subj '_' ,cfg.protocol, '_1_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'_',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil_raw.fif ']]; % takes as input raw files who's ecg component has been removed i.e <subj>_<paradigm>_<run>_ecgClean_raw.fif

                fprintf('\n Checking file existence for grand average %s\n',[subj '_' ,cfg.protocol, '_1_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'_',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil_raw.fif ']);     
                cfg.mne_preproc_file_checker= exist(([subj '_' ,cfg.protocol, '_1_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'_',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil_raw.fif']),'file');
                                    

                        if (cfg.mne_preproc_file_checker~=2)
                            fprintf(' The filtered file you want to perform a grand average on does not seem to exist, Please recheck');
                            fprintf(' The file will be ignored in averaging')
                            cfg.mne_preproc_grand_average_file='';
                        end
                        
                     if run>1,                 
                                    multiple_grand_avg_file_tag=cell(1,run-1);
                                    for irun=2:run
                     
                                        fprintf('\n Checking file existence for grand average %s\n',[subj '_' ,cfg.protocol, '_',num2str(irun),'_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'_',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil_raw.fif ']);     
                                        cfg.mne_preproc_file_checker= exist(([subj '_' ,cfg.protocol, '_',num2str(irun),'_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'_',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil_raw.fif']),'file');
                                                if (cfg.mne_preproc_file_checker~=2)
                                                fprintf(' The filtered file you want to perform a grand average on does not seem to exist, Please recheck');
                                                fprintf(' The file will be ignored in averaging')                                         
                                                multiple_grand_avg_file_tag{irun}='';
                                                else
                                                multiple_grand_avg_file_tag{irun}=['--raw ',subj '_' ,cfg.protocol, '_',num2str(irun),'_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'_',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil_raw.fif '];                      
                                                end
                                    end    
                                         cfg.mne_preproc_grand_average_file = [cfg.mne_preproc_grand_average_file,' ',multiple_grand_avg_file_tag{1:run}]; % takes as input raw files who's ecg component has been removed i.e <subj>_<paradigm>_<run>_ecgClean_raw.fif
  
          
                    
                       
                    

                                    cfg.mne_preproc_grand_average_file= [cfg.mne_preproc_grand_average_file,' ',' --gave ', subj, '_', cfg.protocol,'_',cfg.preproc_filtered_file_tag,'_',num2str(irun),'_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'_',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)) ,'_fil_gave.fif  '];          
                    end   
                    
if isfield(cfg,'epochMEG_merge_events'),

    for irun=1:run
try
eventfile=strcat(cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/', subj ,'_',cfg.protocol,'_',num2str(irun),'_',cfg.preproc_filtered_file_tag,'_raw-eve.fif');
B=exist(eventfile,'file');  

              if (B~=2)
                 fprintf(' The event file doesnt exist, skipping the run');
             
                  continue
          
              end  
newfile=mergeEvents(eventfile,cfg.epochMEG_event_order,cfg.newevents);
cfg.eventFile_average=[' --events  '  newfile ];
cfg.epoch_merge=1;
                    

fprintf(1,'\n Computing log file for merged events \n');


cfg.merge_ave_input_file{irun}=['--raw  ',subj,'_',cfg.protocol,'_',num2str(irun),'_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'_',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil_raw.fif'];
command=['mne_process_raw ' cfg.merge_ave_input_file{irun},' --filteroff' ,'  --projon',cfg.eventFile_average,'  --ave ', cfg.protocol_covdir,'/', cfg.protocol '_merg.ave  ','  --saveavetag ','-ave ', '  ', ' >& ', subj, '_', cfg.protocol, '_',cfg.preproc_filtered_file_tag,'_',num2str(irun),'_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'-',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil-merg-ave.log'];
 [st,wt] = unix(command)	;   
catch
    continue
end
    

    end


else    
                    fprintf(1,'\n Computing grand average and logfile for unmerged events \n');



                    command=['mne_process_raw ' cfg.mne_preproc_grand_average_file,' --filteroff' ,'  --projon','  --ave ', cfg.protocol_covdir,'/', cfg.protocol '.ave  ','  --saveavetag ','-ave ', '  ', ' >& ', subj, '_', cfg.protocol, '_',cfg.preproc_filtered_file_tag,'_',num2str(run),'_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'-',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil_ave.log'];
                    [st,wt] = unix(command)	;
                    fprintf(1,'\n Command executed: %s \n',command);
                   
                    fprintf(1,'\n Grand Average: highpass  %d to lowpass %d\n',cfg.mne_preproc_grand_average.hpf(igrand_avg),cfg.mne_preproc_grand_average.lpf(igrand_avg));
end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
                    if st ~=0
                    error('ERROR : error in computing grand average highpass  %d to lowpass %d\n',cfg.mne_preproc_grand_average.hpf(igrand_avg),cfg.mne_preproc_grand_average.lpf(igrand_avg))
                    end

                    fprintf(1,'\n Success!: highpass  %d to lowpass %d\n',cfg.mne_preproc_grand_average.hpf(igrand_avg),cfg.mne_preproc_grand_average.lpf(igrand_avg));

      
 end

    
        filename=strcat(subj,'_do_mne_preproc_grand_average_cfg');
        save(filename,'cfg','visitNo','run','subj');

   
        

diary off
    

    
  
    
    
    

    
    
    
