    function do_tac_erm_mne_preproc_santosh(subj,run,SSS)
    % Generates a bash script to SSS and filter the data of all subjects for a
    % paradigm. Assumes default subject list. It also generates a matlab script
    % to convert filtered data to eeglab format and calculate ICA.


    %--------------------------------------------------------------------------


%% Global Variables

    s=subj;
    rootdir=('/autofs/space/amiga_001/users/meg/erm1');
    covdir = ('/space/marvin/1/users/MEG/descriptors/cov_templates/');
    p='erm';
    run=1;
    subjdir=[rootdir '/' s '/' num2str(2) '/'];
     
%%

    cd(subjdir) % cd to the fif dir
diary(strcat(s,'_erm_mne_preproc_tacr.info'));
diary on

fprintf(1,'\n Beginning pre-processing for SUBJECT: %s \n',s);
fprintf(1,'\n Analyzing paradigm tacr: \n');



if(SSS)

% SSS and removal of heart-beat component
   
        in_fif = strcat(s,'_',p,'_',num2str(run),'_raw.fif'); 

        frame_tag = ' -frame device -origin 0 13 -6 '; % if hpi fit is not good, use a device frame co-ordinate system
        

        

        
        % if you want tsss -st 16 -corr 0.96
        % MAXFILTER Step 1 - i/p file : <subj>_<paradigm>_<run>_raw.fif ; o/p file : <subj>_<paradigm>_<run>_sss1.fif
        command=['/space/orsay/8/megdev/megsw-neuromag/bin/util/maxfilter -f  '  s '_' p '_' num2str(run) '_raw.fif'...
            ' -o  '  s '_' p '_' num2str(run) '_sss.fif ' ' -autobad on'...
            ' -format short  -force ' frame_tag ' -v >& ' s '_' p '_' num2str(run) '_sss.log'];
        [st,wt] = unix(command);
        fprintf(1,'\n Command executed: %s \n',command);

        if st ~=0
            error('ERROR : check maxfilter step')
        end
        
        
        
        

        

        
        in_fif = strcat(s,'_',p,'_',num2str(run),'_sss.fif');
        out_fif = strcat(s,'_',p,'_',num2str(run),'_ecgClean.fif');
        in_path=subjdir;
        
        projectfile= strcat(s,'_',p,'_',num2str(run),'_proj','.fif');

        eventFileName =strcat(s,'_',p,'_',num2str(run),'_ecg_eve','.fif');


        clean_ecg(in_fif,out_fif,projectfile,eventFileName,in_path) % check channel STI014
end
    %%

   
%% Computation of noise  files.MM
    fprintf('computing noise files %s\n',s);
    raw_tag = ['--raw ' s '_' p '_1_sss.fif '];
%     raw_tag_predecim = [ s '_' p '_1_sss_raw.fif '];
%     raw_tag_filter = [ s '_' p '_1_sss.fif '];
    raw_dec_tag = [s '_' p '_1_dec_sss'];
    mne_dec_tag = ['--raw ' s '_' p '_1_dec_sss_raw.fif '];
  
    
    
    filt1_25_tag = [' --highpass 1 --lowpass 25 --projoff ' ' --save ' s '_' p '_' num2str(run),'_1_25fil.fif '];
    filt25_tag = [' --highpass .1 --lowpass 25 --projoff ' ' --save ' s '_' p '_' num2str(run),'_.1_25fil.fif '];
    filt20_tag = [' --highpass .1 --lowpass 20 --projoff ' ' --save ' s '_' p '_' num2str(run),'_1_20fil.fif '];
    filt40_tag = [' --highpass 1 --lowpass 40 --projoff ' ' --save ' s '_' p '_' num2str(run),'_1_40fil.fif '];
    filt144_tag = [' --highpass 1 --lowpass 144 --projoff ' ' --save ' s '_' p '_' num2str(run),'_1_144fil.fif '];
    
     fprintf(1,'\n Generating Tags: \n'); 
  % Decimating to 600 HZ sampling  
  
    fprintf('decimating to 600 Hz sampling %s\n',s);
[info] = fiff_read_meas_info([s '_' p '_1_sss.fif']);
        
        if info.sfreq >= 3000
         fprintf('decim=5 \n');
            ds_tag=' --decim  5';
        elseif  info.sfreq >= 600 
               fprintf('decim=1 \n');
            ds_tag=' --decim 1 ';
        else      
            error('Check sampling rate');
        end


        
        
        
%     command = ['mne_process_raw ' raw_tag   ' --lowpass 98 --projoff  '   ' >& ' s '_' p '_pre_decim.log'];
%     [st,wt] = unix(command);
% 
%     if st ~=0
%         error('ERROR : error in downsampling')
%     end   
%     
%     movefile( raw_tag_predecim, raw_tag_filter ,'f');
    

    
    
    
     fprintf('lowpass 144 Hz \n');
    command = ['mne_process_raw ' raw_tag  ds_tag '  --lowpass 144  --projoff  --save ' raw_dec_tag ' >& ' s '_' p '_decim.log'];
    [st,wt] = unix(command);
        fprintf(1,'\n Command executed: %s \n',command);

    if st ~=0
        error('ERROR : error in downsampling')
    end
    
    
         fprintf('bandpass 1-25 Hz \n');

    command = ['mne_process_raw ' mne_dec_tag ' --projoff ' filt1_25_tag '--cov ' covdir p '.cov ' ' --savecovtag -1_25fil-cov  ' ' >& ' s '_' p '_1_25fil-cov.log'];
    [st,wt] = unix(command);
        fprintf(1,'\n Command executed: %s \n',command);

    if st ~=0
        error('ERROR : error in computing cov with 1 to 25 LPF')
    end

    movefile([s '_' p '_1_dec_sss-1_25fil-cov.fif'],[s '_' p '_1-1-25fil-cov.fif'])
       
    
    fprintf('bandpass .1-25 Hz \n');

    command = ['mne_process_raw ' mne_dec_tag ' --projoff ' filt25_tag '--cov ' covdir p '.cov ' ' --savecovtag -.1_25fil-cov  ' ' >& ' s '_' p '_.1_25fil-cov.log'];
    [st,wt] = unix(command);
        fprintf(1,'\n Command executed: %s \n',command);

    if st ~=0
        error('ERROR : error in computing cov with .1 to 25 LPF')
    end

    movefile([s '_' p '_1_dec_sss-.1_25fil-cov.fif'],[s '_' p '_1-.1-25fil-cov.fif']);
    
    
    
    
    
    fprintf('bandpass 1-20 Hz \n');

    command = ['mne_process_raw ' mne_dec_tag ' --projoff ' filt20_tag '--cov ' covdir p '.cov ' ' --savecovtag -20fil-cov  ' ' >& ' s '_' p '_1_20fil-cov.log'];
    [st,wt] = unix(command);
        fprintf(1,'\n Command executed: %s \n',command);

    if st ~=0
        error('ERROR : error in computing cov with 20 LPF')
    end

    movefile([s '_' p '_1_dec_sss-20fil-cov.fif'],[s '_' p '_1-1-20fil-cov.fif'])
    
    
            
    fprintf('bandpass 1-40 Hz \n');
      
    command = ['mne_process_raw ' mne_dec_tag ' --projoff ' filt40_tag '--cov ' covdir p '.cov ' ' --savecovtag -40fil-cov  ' ' >& ' s '_' p '_1_40fil-cov.log'];
    [st,wt] = unix(command);
        fprintf(1,'\n Command executed: %s \n',command);

    if st ~=0
        error('ERROR : error in computing cov with 40 LPF')
    end

    movefile([s '_' p '_1_dec_sss-40fil-cov.fif'],[s '_' p '_1-1-40fil-cov.fif'])
    
    
    
    
    fprintf('bandpass 1-144 Hz \n');

    command = ['mne_process_raw ' mne_dec_tag ' --projoff ' filt144_tag ' --cov ' covdir p '.cov ' ' --savecovtag -144fil-cov ' ' >& ' s '_' p '_1_144fil-cov.log'];
    [st,wt] = unix(command);
        fprintf(1,'\n Command executed: %s \n',command);

    if st ~=0
        error('ERROR : error in computing cov with 144 LPF')
    end

    movefile([s '_' p '_1_dec_sss-144fil-cov.fif'],[s '_' p '_1-1-144fil-cov.fif']);
    
    diary off
    
    
%     command = ['mne_process_raw ' mne_dec_tag ' --projoff --filteroff ' ' --cov ' covdir p '.cov ' ' --savecovtag -nofil-cov  ' ' >&' s '_' p '_nofil-cov.log'];
%     [st,wt] = unix(command);
% 
%     if st ~=0
%         error('ERROR : error in computing cov with filter off')
%     end
% 
%      movefile([s '_' p '_1_dec_sss-nofil-cov.fif'],[s '_' p '_1-nofil-cov.fif']);
%%


