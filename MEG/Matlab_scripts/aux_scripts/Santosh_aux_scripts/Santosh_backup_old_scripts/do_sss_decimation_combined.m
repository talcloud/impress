function [cfg]= do_sss_decimation_combined(subj,visitNo,run,erm_run,cfg) 


   % Decimates ERM & SSS data of all subjects for a
    % paradigm. Assumes default subject list. 
    %--------------------------------------
    % Dr Engr. Sheraz Khan,  P.Eng, Ph.D.
    % Engr. Nandita Shetty,  MS.
    %
    % Modified By Santosh Ganesan
    % Date:   June 15, 2011
    %--------------------------------------
 %% Error Check
if isfield(cfg,'current')
    I=strmatch(cfg.current,'do_sss_decimation_combined');
           if isempty(I)
               return
           else
               cfg=rmfield(cfg, 'current');
           end    
end    
       
%% Global Variables    
if ~isfield(cfg,'erm_rootdir'),
 error('Please enter a root directory in sub-structure cfg.erm_rootdir: Thank you');
end
erm_subjdir=[cfg.erm_rootdir '/' subj '/' num2str(visitNo) '/'];

if ~isfield(cfg,'data_rootdir'),
error('Please enter a root directory in sub-structure cfg.data_rootdir: Thank you');
end
if  ~isfield(cfg,'protocol'),
error('Please enter a protocol name in sub-structure cfg.protocol: Thank you');
end
data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
      
%% Decimating ERM Files



diary(strcat(subj,'_erm_decimation.info'));
diary on
if ~isfield(cfg,'erm_decimation'),
% cd(data_subj)
       cd(erm_subjdir);
    fprintf('Starting to Decimate %s\n',subj);
     
 


    % Decimating to 600 HZ sampling  
  
        fprintf('decimating to 600 Hz sampling %s\n',subj);
 
    
    for irun=1:erm_run,   
     
                fprintf(1,'\n Executing Run: %d\n', irun);

                if (cfg.erm_sss),
                    
                    
                       cfg.erm_sss_file_tag=[subj,'_erm_',num2str(irun),'_sss.fif'];
                    %                 cfg.erm_sss_file_tag=[subj,'_erm_',num2str(irun),'_sss.fif'];
                tag='sss';
                fprintf('Starting to Decimate ERM SSS File,%s\n',subj);
                
  
                else    
                cfg.erm_sss_file_tag=[subj,'_erm_',num2str(irun),'_raw.fif'];
                tag='raw';
                fprintf('SSS selected as not having been done %s\n',subj);
                fprintf('Starting to Decimate Raw ERM File %s\n',subj);
                end
                
            

                
            [info] = fiff_read_meas_info(cfg.erm_sss_file_tag);
            cfg.raw_tag{irun} = ['--raw ' cfg.erm_sss_file_tag];
            cfg.raw_dec_tag{irun} = [subj,'_erm_',num2str(irun),'_dec_',tag];
            decim= round(info.sfreq/600);
            fprintf('decim = %d\n',decim);
            cfg.ds_tag{irun}=[' --decim  ',num2str(decim)];
           

    
            fprintf('lowpass 144 Hz \n');
                        command = ['mne_process_raw ' cfg.raw_tag{irun}  cfg.ds_tag{irun} '  --lowpass 144  --projoff  --save ' cfg.raw_dec_tag{irun} ' >& ' subj '_erm_',num2str(irun),'_erm_decim.log'];
                        [st,wt] = unix(command);
                        fprintf(1,'\n Command executed: %s \n',command);

                        if st ~=0
                            error('ERROR : error in downsampling')
                        end
  
    end 
    
  cfg.erm_decimation=1;  
else
fprintf('erm_decimation field is true; indicates that erm decimation has already been performed %s\n',subj);    
end 

diary off

%% SSS Decimation

diary(strcat(subj,'_sss_decimation.info'));
diary on
cd(data_subjdir) % cd to the fif dir
fprintf('Starting to Decimate %s\n',subj);
     
if ~isfield(cfg,'no_data_decimation')
cfg.no_data_decimation=0;
end

if cfg.no_data_decimation==1,
              fprintf(1,'\n SSS data decimation is turned off:cfg.no_data_decimation is enabled \n');

 else
     
if ~isfield(cfg,'start_run_from')
cfg.start_run_from=1;
end
        for irun=cfg.start_run_from:run
           try

            % Decimating to 600 HZ sampling  
  
            fprintf('decimating to 600 Hz sampling %s\n',subj);
            decimate_sss_tag=[subj '_' cfg.protocol '_' num2str(irun) '_sss.fif'];
            [info] = fiff_read_meas_info(decimate_sss_tag);
           
          
           
            decim= round(info.sfreq/600);
            fprintf('decim = %d\n',decim);
            cfg.ds_tag{irun}=[' --decim  ',num2str(decim)];
 
            
            
        % Have to filter in the decimation step, else MNE

    
        fprintf('\n DECIMATING THE DATA WITH LPF SET TO 144 Hz \n')
    
        command = ['/usr/pubsw/packages/mne/nightly/bin/mne_process_raw --raw ' subj '_' cfg.protocol '_' num2str(irun) '_sss.fif'  cfg.ds_tag{irun} ' --lowpass 144  --projoff  --save ' subj '_' cfg.protocol '_' num2str(irun) '_sss.fif' ' >& ' subj '_' cfg.protocol '_sss_decim.log'];
        % Removed Highpass on June 28, 2010
        fprintf(1,'\n Command executed: %s \n',command);
        [st,wt] = system(command);

                if st ~=0
                    error(strcat('ERROR : error in downsampling:',wt));
                end
        
        movefile( [subj '_' cfg.protocol '_' num2str(irun) '_sss_raw.fif'],[subj '_' cfg.protocol '_' num2str(irun) '_sss.fif'],'f');
        fprintf('\n \DONE DECIMATING THE DATA. Success! %d\n ',irun)
        fprintf('\n Changing permissions of files created by this script \n')
    ! /usr/pubsw/bin/setgrp acqtal *
    ! chmod 775 
           catch
                                     fprintf(1,'\n Failed run %d \n',irun);

               continue
           end
        end
end
diary off

        filename=strcat(subj,'_do_sss_decimation_combined_cfg');
        save(filename,'cfg','visitNo','run','erm_run','subj');
