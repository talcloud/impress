
function [cfg]= do_sss_transform_allrunsto_singlerun(subj,visitNo,run,cfg) 
%% Error Check
if isfield(cfg,'current')
    I=strmatch(cfg.current,'do_sss_transform_allrunsto_singlerun');
           if isempty(I)
               return
           else
               cfg=rmfield(cfg, 'current');
           end    
end    
diary(strcat(subj,'_sss_transform_allrunsto_singlerun.info'));
diary on
if ~isfield(cfg,'no_data_sss')   
%% Global Variables
if run<2,
     fprintf('cannot perform transformation! there is only 1 run');

    return
end

if ~isfield(cfg,'data_rootdir'),
        error('Please enter a root directory in sub-structure cfg.data_rootdir: Thank you');
end
if  ~isfield(cfg,'protocol'),
error('Please enter a protocol name in sub-structure cfg.protocol: Thank you');
end

if ~isfield(cfg,'frame_tag'),
 error('Please check hpifit/error in sub-structure cfg.frame_tag: Thank you');
end

if ~isfield(cfg,'sss_trans_tag'),
 error('Please check hpifit/error in sub-structure sss_trans_tag: Thank you');
end
data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
cd(data_subjdir) % cd to the fif dir
%% Transform all runs to single run


fprintf('\n Transform Everything to Run 1 \n');



for irun = 2:run,
     cfg.transform_allrunsto_singlerun_tag=[subj '_' cfg.protocol '_' num2str(irun) '_sss.fif'];
     cfg.transform_tag=[' -o ', subj '_' cfg.protocol '_' num2str(irun) '_transformto_run_1_sss.fif'];    
     cfg.transform_allrunsto_singlerun_tag=[cfg.transform_allrunsto_singlerun_tag,'',cfg.transform_tag];
  
        command=['/space/orsay/8/megdev/megsw-neuromag/bin/util/maxfilter -f ',cfg.transform_allrunsto_singlerun_tag, ' -autobad off -bad ' cfg.badch{irun} cfg.sss_trans_tag{irun}  cfg.frame_tag{irun}  ' -format short -force -v >& ' subj '_' cfg.protocol '_' num2str(irun) '_sss_single_run_transformation.log' ];

        [st,wt] = system(command)

        if st ~=0

            fprintf(strcat('Error value %d check maxfilter step 3/ SSS Transform All Runs into Single Run for run %d/n',wt,irun));
            
        else
            fprintf('\n Transformation: Successful %d\n',irun);

        end
  continue
end     
    
else
         fprintf(1,'\n SSS data is turned off:cfg.no_data_sss is enabled \n');
 
end



    fprintf('\n Changing permissions of files created by this script \n')
    ! /usr/pubsw/bin/setgrp acqtal *
    ! chmod 775 
diary off

        filename=strcat(subj,'_do_sss_transform_allrunsto_singlerun_cfg');
        save(filename,'cfg','visitNo','run','subj');
