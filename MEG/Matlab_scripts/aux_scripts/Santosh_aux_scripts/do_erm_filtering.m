
function [cfg]=do_erm_filtering(subj,visitNo,erm_run,cfg) 
    
    % Generates filtered variants of SSS data of all subjects for a
    % paradigm. Assumes default subject list. 
    %--------------------------------------
    % Dr Engr. Sheraz Khan,  P.Eng, Ph.D.
    % Engr. Nandita Shetty,  MS.
    %
    % Modified By Santosh Ganesan
    % Date:   June 15, 2011
    %--------------------------------------
  %% Error Check
if isfield(cfg,'error_mode')
    
   file= exist(strcat(subj,'_do_erm_filtering_error_cfg.mat'),'file');
           if file~=2
               return
           else
               delete(file);
           end    
end     
   
%% Global Variables    
        if ~isfield(cfg,'erm_rootdir'),
        error('Please enter a root directory in sub-structure cfg.erm_rootdir: Thank you');
        end
        
        if ~isfield(cfg,'filt')
        cfg.filt=[];
        end

        
%     erm_subjdir=[cfg.erm_rootdir '/' subj '/' num2str(visitNo) '/'];
%     cd(erm_subjdir) % cd to the fif dir 
data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
cd(data_subjdir);
    diary(strcat(subj,'_erm_filtering.info'));
    diary on
    
%% Setting Filter Bands    
    
        
        if ~isfield(cfg,'erm_decimation'),
        warning('ERM data does not appear to be decimated, cfg.erm_decimation is not set ')     
        end


    if isempty(cfg.filt)
        
        cfg.filt.hpf(1)=1;  
        cfg.filt.lpf(1)=144;
        cfg.filt.hpf(2)=.1;
        cfg.filt.lpf(2)=25;       
        cfg.filt.hpf(3)=1;
        cfg.filt.lpf(3)=40;
        cfg.filt.hpf(4)=.1;
        cfg.filt.lpf(4)=144;
        cfg.filt.hpf(5)=.3;
        cfg.filt.lpf(5)=40;
        for default=1:5.
        fprintf(' highpass    %d to lowpass %d\n', cfg.filt.hpf(default),cfg.filt.lpf(default));
        end
    end
    
    if(length(cfg.filt.lpf)~=length(cfg.filt.hpf))
    
            error(' There is something funky with the low pass and high settings you have entered, Please recheck');
    else
            fprintf('Starting to Filtering %s\n',subj);
    end

%% Filtering files
    
 for irun=1:erm_run,
    
     if ~isfield(cfg,'removeECG_EOG')
    cfg.removeECG_EOG=2;
                fprintf('cfg.reomveECG_EOG is not set, automatically setting to ecgeogClean_applied  %s\n',subj);

     end
     
    if cfg.removeECG_EOG==2,
        cfg.erm_filtering_file_tag{irun}='ecgeogClean_applied';
    elseif cfg.removeECG_EOG==1,
        cfg.erm_filtering_file_tag{irun}='ecgClean_applied';
    else
        cfg.erm_filtering_file_tag{irun}='';
    end
     
     
     
    if isfield(cfg,'erm_sss')
   cfg.mne_dec_tag{irun} = ['--raw ' subj '_erm_',num2str(irun),'_sss_',cfg.erm_filtering_file_tag{irun},'_raw.fif '];
    else
   cfg.mne_dec_tag{irun} = ['--raw ' subj '_erm_',num2str(irun),'_dec_raw.fif '];    
    end
   

   filtersize='';
    
   for ifilter=1:length(cfg.filt.hpf),

                if cfg.filt.hpf(ifilter)==.3,
                    filtersize= ' --filtersize 8192 ';  
                end
       
            command = ['mne_process_raw ' cfg.mne_dec_tag{irun} ' --projoff '  filtersize ' --highpass',' ',num2str(cfg.filt.hpf(ifilter)),' ','--lowpass',' ',num2str(cfg.filt.lpf(ifilter)),' ',...
             ' --save ' subj '_erm_' num2str(irun),'_',num2str(cfg.filt.hpf(ifilter)),'-',num2str(cfg.filt.lpf(ifilter)),'fil.fif  >& ',subj,'_',cfg.protocol,'_erm_filtering.log '];
            
           [st,wt] = unix(command);
           fprintf(1,'\n Command executed: %s \n',command);
           fprintf(1,'\n Run: %d\n', irun);
           fprintf(1,'\n filtering: highpass  %d to lowpass %d\n',cfg.filt.hpf(ifilter),cfg.filt.lpf(ifilter));

                if st ~=0
                 error('ERROR : error in computing highpass  %d to lowpass %d\n',cfg.filt.hpf(ifilter),cfg.filt.lpf(ifilter))
                end

            fprintf(1,'\n Success!: highpass  %d to lowpass %d\n',cfg.filt.hpf(ifilter),cfg.filt.lpf(ifilter));

      
      
   end
end
 
     diary off

         filename=strcat(subj,'_do_erm_filtering_cfg');
        save(filename,'cfg','visitNo','erm_run','subj');    
     