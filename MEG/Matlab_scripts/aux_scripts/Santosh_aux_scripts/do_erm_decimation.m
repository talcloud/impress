
function [cfg]= do_erm_decimation(subj,visitNo,run,cfg) 
    
    % Generates filtered variants of SSS data of all subjects for a
    % paradigm. Assumes default subject list. 
    %--------------------------------------
    % Dr Engr. Sheraz Khan,  P.Eng, Ph.D.
    % Engr. Nandita Shetty,  MS.
    %
    % Modified By Santosh Ganesan
    % Date:   June 15, 2011
    %--------------------------------------
    
%% Global Variables    
        if ~isfield(cfg,'rootdir'),
        error('Please enter a root directory in sub-structure cfg.rootdir: Thank you');
        end


    
    subjdir=[cfg.rootdir '/' subj '/' num2str(visitNo) '/'];
    cd(subjdir); 

 

%% Decimating Files
    
diary(strcat(subj,'_erm_decimation.info'));
diary on
fprintf('Starting to Decimate %s\n',subj);
     
 


% Decimating to 600 HZ sampling  
  
fprintf('decimating to 600 Hz sampling %s\n',subj);
 
    
 for irun=1:run,   
     
            fprintf(1,'\n Executing Run: %d\n', irun);

            if (cfg.sss),
                cfg.erm_sss_file_tag=[subj,'_erm_',num2str(irun),'_sss.fif'];
                tag='sss';
                fprintf('Starting to Decimate SSS File %s\n',subj);
            else    
                cfg.erm_sss_file_tag=[subj,'_erm_',num2str(irun),'_raw.fif'];
                tag='raw';
                fprintf('SSS selected as not having been done %s\n',subj);
                fprintf('Starting to Decimate Raw File %s\n',subj);
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
     

diary off
