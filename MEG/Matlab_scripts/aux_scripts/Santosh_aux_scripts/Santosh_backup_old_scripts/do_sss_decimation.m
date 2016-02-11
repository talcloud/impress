function [cfg]= do_sss_decimation(subj,visitNo,run,cfg)


%% Global Variables    
      if ~isfield(cfg,'data_rootdir'),
        error('Please enter a root directory in sub-structure cfg.data_rootdir: Thank you');
      end
        
        if  ~isfield(cfg,'protocol'),
        error('Please enter a protocol name in sub-structure cfg.protocol: Thank you');
        end

    
    data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
    cd(data_subjdir); 
%% SSS Decimation

diary(strcat(subj,'_sss_decimation.info'));
diary on
fprintf('Starting to Decimate %s\n',subj);
     
 
        for irun=1:run

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
    
        end

diary off