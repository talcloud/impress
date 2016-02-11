
function [cfg]= do_sss_transform_allrunsto_singlerun(subj,visitNo,run,cfg)

%   If multiple runs, for SSS data, transforms all runs into a single run

% Local variables:

%   1) subj = subject name
%   2) visitNo = visit number
%   3) run = run number
%   4) cfg = data structure with global variables
% cfg.frame_tag must be input, taken from do_sss_hpifit.m
% cfg.sss_trans_tag must be input, taken from do_sss_hpifit.m
% cfg.badch from do_sss_bad_channels
%% Error Check
if isfield(cfg,'error_mode')
    
    file= exist(strcat(subj,'_do_sss_transform_allrunsto_singlerun_error_cfg.mat'),'file');
    if file~=2
        return
    else
        delete(file);
    end
end

diary(strcat(subj,'_sss_transform_allrunsto_singlerun_',datestr(clock),'.info'));  % Starting Diary
diary on

if ~isfield(cfg,'no_data_sss')
    %% Global Variables
%     if run<2,
%         fprintf('cannot perform transformation! there is only 1 run');
%         
%         return
%     end
    
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
    
    
    for irun = cfg.start_run_from:run,
        
        if ~isempty(cfg.frame_tag{irun});
            
            
            cfg.transform_allrunsto_singlerun_tag=[subj '_' cfg.protocol '_' num2str(irun) '_sss.fif']; % Selects input file for transformation
            cfg.transform_tag=[' -o ', subj '_' cfg.protocol '_' num2str(irun) '_transformto_run_1_raw.fif'];  % Selects output file, RUN 1
            cfg.transform_allrunsto_singlerun_tag=[cfg.transform_allrunsto_singlerun_tag,'',cfg.transform_tag]; % Sets frame tag for transformation
            
            if isempty(cfg.badch{irun})
                badchannel_command='';
            else
                badchannel_command=[' -bad ' char(cfg.badch{irun})];
            end
            
            if ~isempty(cfg.frame_tag{irun})
                % TRANSFORMS ALL RUNS INTO A SINGLE RUN to SSS data
              %   command=['maxfilter -f ',cfg.transform_allrunsto_singlerun_tag, ' -autobad off  ' badchannel_command ' ' cfg.sss_trans_tag{irun}  cfg.frame_tag{irun}  ' -format short -force -v >& ' subj '_' cfg.protocol '_' num2str(irun) '_sss_single_run_transformation.log' ];
            
              % TRANSFORMS ALL RUNS INTO A SINGLE RUN to RAW data
             cfg.trans_raw_tag=['-trans ' subj '_' cfg.protocol '_1_raw.fif'];
             
              command=['maxfilter -f ',cfg.transform_allrunsto_singlerun_tag, ' -autobad off  ' badchannel_command ' ' cfg.trans_raw_tag  cfg.frame_tag{irun}  ' -format short -force -v >& ' subj '_' cfg.protocol '_' num2str(irun) '_raw_single_run_transformation.log' ];
            
                fprintf(command);
                [st,wt] = system(command)
            else
                st=1;
            end
            
            if st ~=0
                
                fprintf(strcat('Error value %d check maxfilter step 3/ SSS Transform All Runs into Single Run for run %d/n',wt,irun));
                
            else
                fprintf('\n Transformation: Successful %d\n',irun);
                
            end
        else
            fprintf(1,'\n HPI FIT MAY BE BAD:TRANSFORMATION NOT PERFORMED \n');
            
        end
        
        fprintf('\n Renaming TRANSFORM FILE INTO _sss.fif FILE %s\n',cfg.transform_tag);
        copyfile( [subj '_' cfg.protocol '_' num2str(irun) '_transformto_run_1_raw.fif'],[subj '_' cfg.protocol '_' num2str(irun) '_sss.fif'],'f');
        
    end
    
else
    fprintf(1,'\n SSS transformation is turned off:cfg.no_data_sss is enabled \n');
end

fprintf('\n Transformation of all runs into a single RUN is Successful \n')
fprintf('\n Changing permissions of files created by this script \n')
[success,messageid]=system(['setgrp acqtal *'])
[success,messageid]=system(['chmod 775 *'])
diary off % Ending Diary

filename=strcat(subj,'_do_sss_transform_allrunsto_singlerun_cfg');
save(filename,'cfg','visitNo','run','subj');
