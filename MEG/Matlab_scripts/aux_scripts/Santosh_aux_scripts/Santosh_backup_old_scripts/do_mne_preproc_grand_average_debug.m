function [cfg]=do_mne_preproc_grand_average(subj,visitNo,run,cfg)
%% Global Variables
if ~isfield(cfg,'rootdir'),
 error('Please enter a root directory in sub-structure cfg.rootdir: Thank you');
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
if ~isfield(cfg,'covdir')
error('Please enter a covariance directory in sub-structure cfg.covdir: Thank you');
end

if ~isfield(cfg,'mne_preproc_filt')
cfg.mne_preproc_filt=[];
end


subjdir=[cfg.rootdir '/' subj '/' num2str(visitNo) '/'];
cd(subjdir) % cd to the fif dir
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
                    fprintf('Starting to Filtering %s\n',subj);
                end

                           if (cfg.removeECG_EOG==1),
                            cfg.preproc_filtered_file_tag='ecgClean';
                           elseif (cfg.removeECG_EOG==2),
                            cfg.preproc_filtered_file_tag='ecgeogClean';
                           else
                            cfg.preproc_filtered_file_tag='sss';
                           end
                           
                           
                           
                           
 if run>1,
        

        for igrand_avg=1:length(cfg.mne_preproc_grand_average.hpf),
            
          
         cfg.mne_preproc_grand_average_file{1} = ['--raw ' [subj '_' ,cfg.protocol, '_1_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'_',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil_raw.fif ']]; % takes as input raw files who's ecg component has been removed i.e <subj>_<paradigm>_<run>_ecgClean_raw.fif

            
                    for irun=2:run
                    
                            fprintf('\n Checking file existence for grand average %s\n',[subj '_' ,cfg.protocol, '_',num2str(irun),'_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'_',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil_raw.fif ']);     
                            cfg.mne_preproc_file_checker= exist(([subj '_' ,cfg.protocol, '_',num2str(irun),'_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'_',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil_raw.fif']),'file');
                                if (cfg.mne_preproc_file_checker~=2)
                                error(' The filtered file you want to perform a grand average on does not seem to exist, Please recheck');
                                end
                                
                                    multiple_grand_avg_file_tag=[subj '_' ,cfg.protocol, '_',num2str{irun},'_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'_',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil_raw.fif '];                      
                                    cfg.mne_preproc_grand_average_file{irun} = [cfg.mne_preproc_grand_average_file{1},' ',multiple_grand_avg_file_tag]; % takes as input raw files who's ecg component has been removed i.e <subj>_<paradigm>_<run>_ecgClean_raw.fif
  
          
                    end
                    
                    
                        for irun=2:run
                                    cfg.mne_preproc_grand_average_file{irun}= [cfg.mne_preproc_grand_average_file{irun},' ',' --gave ', subj, '_', cfg.protocol,'_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'_',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)) ,'_fil-gave.fif '];          
                        end
                    
                    
                    

                    command=['mne_process_raw ' cfg.mne_preproc_grand_average_file{irun},' --filteroff' ,'  --projon','  --save  ',[subj '_' ,cfg.protocol, '_',num2str(irun),'_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'_',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil_grand_avg.fif '],'  --ave ', cfg.covdir cfg.protocol '.ave ',' --saveavetag ','-',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'_',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil-ave ', ' >& ', subj, '_', cfg.protocol, '_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'_',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil-ave.log'];
                    [st,wt] = unix(command);
                    fprintf(1,'\n Command executed: %s \n',command);
                    fprintf(1,'\n Run: %d\n', irun);
                    fprintf(1,'\n Grand Average: highpass  %d to lowpass %d\n',cfg.mne_preproc_grand_average.hpf(igrand_avg),cfg.mne_preproc_grand_average.lpf(igrand_avg));

                    if st ~=0
                    error('ERROR : error in computing grand average highpass  %d to lowpass %d\n',cfg.mne_preproc_grand_average.hpf(igrand_avg),cfg.mne_preproc_grand_average.lpf(igrand_avg))
                    end

                    fprintf(1,'\n Success!: highpass  %d to lowpass %d\n',cfg.mne_preproc_grand_average.hpf(igrand_avg),cfg.mne_preproc_grand_average.lpf(igrand_avg));

      
        end

    
else
     fprintf('cannot perform grand average! there is only 1 run');

end    
        

diary off
    

    
  
    
    
    

    
    
    
