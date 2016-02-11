    function [cfg]= do_sss_no_movementcomp_combined(subj,visitNo,run,erm_run,cfg)
 %% Description   
    % Generates ERM-SSS & Data-SSS of the data of all subjects for a
    % paradigm. Assumes default subject list. 
    %--------------------------------------
    % Dr Engr. Sheraz Khan,  P.Eng, Ph.D.
    % Engr. Nandita Shetty,  MS.
    %
    % Date::  October, 2010
    
    % Modified By Santosh Ganesan
    % Date:   June 15, 2011
    %--------------------------------------
%% Error Check
if isfield(cfg,'current')
    I=strmatch(cfg.current,'do_sss_no_movementcomp_combined');
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


%% ERM SSS
diary(strcat(subj,'_erm_mne_preproc_SSS_no_movemementcomp.info'));
diary on

if ~isfield(cfg,'erm_sss'),
 cd(erm_subjdir) % cd to the fif dir

    if ~isfield(cfg,'erm_linefreq'),
    cfg.erm_linefreq=' 60';
    end

    if ~isfield(cfg,'format'),
    cfg.format=' short';
    end

        fprintf(1,'\n Beginning erm pre-processing for SUBJECT: %s \n',subj);
        fprintf(1,'\n Analyzing paradigm: %s\n',subj);

     
        for irun=1:erm_run,
        
                cfg.erm_frame_tag = ' -frame device -origin 0 13 -6 '; % if hpi fit is not good, use a device frame co-ordinate system
        
                % if you want tsss -st 16 -corr 0.96
                % MAXFILTER Step 1 - i/p file : <subj>_<paradigm>_<run>_raw.fif ; o/p file : <subj>_<paradigm>_<run>_sss1.fif
                command=['/space/orsay/8/megdev/megsw-neuromag/bin/util/maxfilter -f  ' subj '_' 'erm' '_' num2str(irun) '_raw.fif'...
                ' -o  '  subj '_' 'erm' '_' num2str(irun) '_sss.fif ' ' -autobad on -linefreq',cfg.erm_linefreq...
                ' -format ',cfg.format, ' -force ' cfg.erm_frame_tag ' -v >& ' subj '_' 'erm' '_' num2str(irun) '_sss.log'];
                [st,wt] = unix(command)
                fprintf(1,'\n Command executed: %s \n',command);

                    if st ~=0
                     error('ERROR : check maxfilter step')
                    end
        end
    
    cfg.erm_sss=1;
else
fprintf('erm_sss field is true; indicates that erm sss has already been performed %s\n',subj);  
end
diary off


%% SSS without Movement Compensation
diary(strcat(subj,'_sss_without_movement_comp.info'));
diary on
if ~isfield(cfg,'no_data_sss')
        fprintf(1,'\n Beginning sss pre-processing for SUBJECT: %s \n',subj);

    cd(data_subjdir) % cd to the fif dir
    if ~isfield(cfg,'frame_tag')
    error('Please check HPI Fit/ function:do_sss_hpifit: Thank you');
    end
    
if ~isfield(cfg,'start_run_from')
cfg.start_run_from=1;
end
    

for irun = cfg.start_run_from:run
    try
        
                    if ~isfield(cfg,'HPI_DROP_COUNTER')
                    fprintf('warning, no HPI_DROP_COUNTER value set: SSS with movement compensation may not have been performed');
                    cfg.HPI_DROP_COUNTER{irun}=0;
                    end  
    
                    if ~isfield(cfg,'format'),
                    cfg.format=' short';
                    end   
    
                            if ((cfg.HPI_DROP_COUNTER{irun} >=20)||isfield(cfg,'without_movement_option'))
     
                            fprintf(1,'\n PERFORMING SSS WITHOUT MOVEMENT COMPENSATION, HPI_DROP_COUNTER Value: %d \n',cfg.HPI_DROP_COUNTER{irun});    
   
                            % Removed: -st 16 -corr 0.96 from the command... Add if doing tSSS
                            command=['/space/orsay/8/megdev/megsw-neuromag/bin/util/maxfilter -f  '  subj '_' cfg.protocol '_' num2str(irun) '_raw.fif'...
                             ' -o  '  subj '_' cfg.protocol '_' num2str(irun) '_sss.fif ' ' -autobad off    ' ...
                               ' -format',cfg.format,' -force -hpisubt amp -format ',cfg.format,' -force -bad '  cfg.badch{irun} cfg.frame_tag{irun}   ' -v >& ' subj '_' cfg.protocol '_' num2str(irun) '_sss_without_move_comp.log'];
                            fprintf(1,'\n Command executed: %s \n',command);
                            [st,wt] = system(command)

                                        if st ~=0
                                        error(strcat('ERROR : check maxfilter step 2/ SSS without Movement Compensation:',wt));
                                        end
                             % Saving movement comp figure 
                            fprintf('\n Ploting and saving movement compensation result \n')
                            cfg.logfile_without_movement_comp{irun}= strcat(subj, '_', cfg.protocol, '_', num2str(irun), '_sss_without_move_comp.log');
                            movecomp( cfg.logfile_without_movement_comp{irun});
                            close(figure);         
    
                            else
                            fprintf(1,'\n Not performing movement compensation for this run: %d \n',irun)

    
                            end
    catch
                             fprintf(1,'\n Failed run %d \n',irun);
 
        
        continue
    end
    

    
end


    fprintf('\n SSS Without Movement Compensation: Successful \n')
    fprintf('\n Changing permissions of files created by this script \n')
    ! /usr/pubsw/bin/setgrp acqtal *
    ! chmod 775 
else
      fprintf(1,'\n SSS data is turned off:cfg.no_data_sss is enabled \n');
end
diary off

        filename=strcat(subj,'_do_sss_no_movementcomp_combined_cfg');
        save(filename,'cfg','visitNo','run','erm_run','subj');