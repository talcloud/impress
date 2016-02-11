
 function [cfg]= do_sss_without_movement_comp(subj,visitNo,run,cfg) 

%% Global Variables

if ~isfield(cfg,'data_rootdir'),
 error('Please enter a root directory in sub-structure cfg.data_rootdir: Thank you');
end
if  ~isfield(cfg,'protocol'),
error('Please enter a protocol name in sub-structure cfg.protocol: Thank you');
end


data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
cd(data_subjdir) % cd to the fif dir

%% SSS without Movement Compensation

diary(strcat(subj,'_sss_without_movement_comp.info'));
diary on

    if ~isfield(cfg,'frame_tag')
    error('Please check HPI Fit/ function:do_sss_hpifit: Thank you');
    end
    
  
    

for irun = 1:run
        
                    if ~isfield(cfg,'counter')
                    fprintf('warning, no counter value set: SSS with movement compensation may not have been performed');
                    cfg.counter{irun}=0;
                    end  
    
    
    
                            if ((cfg.counter{irun} >=20)||isfield(cfg,'without_movement_option'))
     
                            fprintf(1,'\n PERFORMING SSS WITHOUT MOVEMENT COMPENSATION, Counter Value: %d \n',cfg.counter{irun});    
   
                            % Removed: -st 16 -corr 0.96 from the command... Add if doing tSSS
                            command=['/space/orsay/8/megdev/megsw-neuromag/bin/util/maxfilter -f  '  subj '_' cfg.protocol '_' num2str(irun) '_raw.fif'...
                             ' -o  '  subj '_' cfg.protocol '_' num2str(irun) '_sss.fif ' ' -autobad off    ' ...
                               ' -format short -force -hpisubt amp -format short -force -bad '  cfg.badch{irun} cfg.frame_tag{irun}   ' -v >& ' subj '_' cfg.protocol '_' num2str(irun) '_sss_without_move_comp.log'];
                            fprintf(1,'\n Command executed: %s \n',command);
                            [st,wt] = system(command)

                                        if st ~=0
                                        error(strcat('ERROR : check maxfilter step 2/ SSS without Movement Compensation:',wt));
                                        end
                             % Saving movement comp figure 
                            fprintf('\n Ploting and saving movement compensation result \n')
                            cfg.logfile_without_movement_comp{irun}= strcat(subj, '_', cfg.protocol, '_', num2str(irun), '_sss_without_move_comp.log');
                            movecomp( cfg.logfile_without_movement_comp{irun});
    
    
                            else
                            fprintf(1,'\n Not performing movement compensation for this run: %d \n',irun)

    
                            end
    

    
end


    fprintf('\n SSS Without Movement Compensation: Successful \n')
    fprintf('\n Changing permissions of files created by this script \n')
    ! /usr/pubsw/bin/setgrp acqtal *
    ! chmod 775 
diary off