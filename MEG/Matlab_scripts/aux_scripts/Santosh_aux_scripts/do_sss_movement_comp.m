 function [cfg]= do_sss_movement_comp(subj,visitNo,run,cfg)  


 
 %% Global Variables

if ~isfield(cfg,'data_rootdir'),
 error('Please enter a root directory in sub-structure cfg.data_rootdir: Thank you');
end
if  ~isfield(cfg,'protocol'),
error('Please enter a protocol name in sub-structure cfg.protocol: Thank you');
end
data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
cd(data_subjdir) % cd to the fif dir

%% SSS with Movement Compensation
diary(strcat(subj,'_sss_movement_comp.info'));
diary on
        

    if ~isfield(cfg,'frame_tag')||~isfield(cfg,'movecomp_tag')
    error('Please check HPI Fit/ function:do_sss_hpifit: Thank you');
    end
    
    fprintf('\n Maxfilter Step 2: SSS with Movement Compensation \n')

    % MAXFILTER Step 2-a - i/p file : <subj>_<paradigm>_<run>_raw.fif ; o/p file : <subj>_<paradigm>_<run>_raw1.fif

 for irun = 1:run
     
    % Removed: -st 16 -corr 0.96 from the command... Add if doing tSSS
    command=['/space/orsay/8/megdev/megsw-neuromag/bin/util/maxfilter -f  '  subj '_' cfg.protocol '_' num2str(irun) '_raw.fif'...
        ' -o  '  subj '_' cfg.protocol '_' num2str(irun) '_sss.fif ' ' -autobad off  -hp ' subj '_' cfg.protocol '_' num2str(irun) '_hp.log'...
        ' -format short -force -hpisubt amp -format short -force -bad '  cfg.badch{irun} cfg.frame_tag{irun} cfg.movecomp_tag{irun} ' -v >& ' subj '_' cfg.protocol '_' num2str(irun) '_sss_move_comp.log'];
    fprintf(1,'\n Command executed: %s \n',command);
    [st,wt] = system(command)

    if st ~=0
        error(strcat('ERROR : check maxfilter step 2/ SSS with Movement Compensation:',wt));
    end
    
    cfg.logfile_movement_comp{irun}=[ subj '_' cfg.protocol '_' num2str(irun) '_sss_move_comp.log'];
    
    cfg.counter{irun}= parse_mne_sss_step2_log(cfg.logfile_movement_comp{irun});
           % Saving movement comp figure 
    fprintf('\n Ploting and saving movement compensation result \n')
    movecomp(cfg.logfile_movement_comp{irun});
 
 
 end
 
 
    fprintf('\n SSS With Movement Compensation: Successful \n')
    fprintf('\n Changing permissions of files created by this script \n')
    ! /usr/pubsw/bin/setgrp acqtal *
    ! chmod 775 
 
 diary off