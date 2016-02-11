function [cfg]=do_calc_forward(subj,visitNo,run,cfg)
 
%   Sheraz Khan <sheraz@nmr.mgh.harvard.edu>
%   Santosh Ganesan <santosh@nmr.mgh.harvard.edu>
%   CALCULATES FORWARD OPERATOR
% Local variables:
%   1) subj = subject name
%   2) visitNo = visit number
%   3) run = run number
%   4) cfg = data structure with global variables
%   5) cfg.frame_tag_checker_off // if set,(cfg.frame_tag_checker_off=[]), The forward operator does not check to see whether cHPIs are viable. If not enabled, make sure value is set for cfg.frame_tag
% OPTIONS:
%   1) cfg.forward_spacing // sets forward spacing. If not enabled, default is cfg.forward_spacing= ' ico-5 '
%   2) cfg.start_run_from // if set, with multiple runs, will start sss from that run. For example, cfg.start_run_from=2, function will begin from run 2
%   3) cfg.removeECG_EOG // if set (cfg.removeECG_EOG=1), indicates removing heartbeat only, cfg.removeECG_EOG=2 indicates removing heartbeat and blinks, default: cfg.removeECG_EOG=2
%   4) cfg.start_run_from // if set, with multiple runs, will start sss from that run. For example, cfg.start_run_from=2, function will begin from run 2 

%% Error Check
if isfield(cfg,'error_mode')
    
   file= exist(strcat(subj,'_do_calc_forward_error_cfg.mat'),'file');
           if file~=2
               return
           else
               delete(file);
           end    
end

%% Global Variables


if ~isfield(cfg,'data_rootdir'),
error('Please enter a root directory in sub-structure cfg.data_rootdir: Thank you');
end

if ~isfield(cfg,'protocol'),
 error('Please enter a protocol name in sub-structure cfg.protocol: Thank you');
end

if ~isfield(cfg,'erm_rootdir'),
 error('Please enter a root directory in sub-structure cfg.erm_rootdir: Thank you');
end

if ~isfield(cfg,'frame_tag_checker_off')
    if ~isfield(cfg,'frame_tag')
  error('The forward operator checks to see whether cHPIs are viable. If you would like to turn this feature off, please set cfg.frame_tag_checker_off=[]: Thank you');
    end
end
data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
cd(data_subjdir) % cd to the fif dir


%% Calculating Forward Operator

% If re-running after error, make sure to clear cfg.forward_spacing,
% otherwise command will be in error

diary(strcat(subj,'_calc_forward_',datestr(clock),'.info')); % Starting Diary
diary on


cfg.forward_mri_tag=[' --mri ' cfg.erm_rootdir,'/',subj,'/',num2str(visitNo),'/', subj '_1-trans.fif  ']; % Set trans file 

if ~isfield(cfg,'forward_spacing'),
    
    cfg.forward_spacing=' ico-5 '; % Sets forward spacing
else
    cfg.forward_spacing=strcat(cfg.forward_spacing); % Sets forward spacing
    
end    

if isfield(cfg,'frame_tag_checker_off')
            
    fprintf('you have instructed the function not to check if cHPIs are valid for the runs before proceeding'); 

if ~isfield(cfg,'start_run_from')
cfg.start_run_from=1;  % field allows flexibility to start pre-processing not from run 1
end 
    
    for irun=cfg.start_run_from:run
     cfg.frame_forward_tag{irun}='empty value';
   
   end
       
end

subj1 = subj;
for irun=cfg.start_run_from:run,
    subj = subj1;
   if ~isfield(cfg,'frame_tag_checker_off') 
    I=strcmp(' -frame device -origin 0 13 -6 ', cfg.frame_tag{irun});
   else
    I=strcmp(' -frame device -origin 0 13 -6 ', cfg.frame_forward_tag{irun});
   end 
    if I ==1, 
        
        fprintf('HPI is bad for this run, %d, Checking another run if available %d\n',irun); 

      continue
    else
            cfg.forward.in_fif{irun} = strcat(subj,'_',cfg.protocol,'_',num2str(irun),'_raw.fif '); % INPUT RAW FILE
            cfg.forward.in_fif{irun} =[data_subjdir cfg.forward.in_fif{irun}];
            cfg.forward_fif{irun} = strcat(subj,'_',cfg.protocol,'_',num2str(irun),'-fwd.fif '); % OUTPUT FORWARD OPERATOR
            cfg.forward_fif{irun} =[data_subjdir cfg.forward_fif{irun}];

            if isfield(cfg,'mri_rescan')
                subj=[subj '_rescan'];
            end
            if isfield(cfg,'mri_visit2')
                subj=[subj '_visit2'];
            end
            % MNE FORWARD OPERATOR
            command=['mne_do_forward_solution --meas '  cfg.forward.in_fif{irun} ' --megonly --overwrite --spacing ' cfg.forward_spacing, cfg.forward_mri_tag  '  --subject  ' subj ' --fwd  ' cfg.forward_fif{irun} ' -v >& calc-forward_',num2str(irun),'.log' ];

  
            [st,w] = unix(command);
            fprintf(1,'\n Command executed: %s \n',command);
            fprintf(1,'\n Run: %d\n', irun);  
           

                        if st ~=0
                         w
                        warning('check Forward step');
                        fprintf(1,'\n Error with Forward operator! Run: %d\n', irun); 
                        elseif st==0 && isfield(cfg,'single_forward_operator')
                                break
                        else
                        continue
                        end
                           
    end
end




diary off     % Ending Diary   

        filename=strcat(subj,'_do_calc_forward_cfg');
        save(filename,'cfg','visitNo','run','subj');