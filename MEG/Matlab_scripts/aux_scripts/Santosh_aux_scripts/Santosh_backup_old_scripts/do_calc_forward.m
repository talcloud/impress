function [cfg]=do_calc_forward(subj,visitNo,run,cfg)
  %% Error Check
if isfield(cfg,'current')
    I=strmatch(cfg.current,'do_calc_forward');
           if isempty(I)
               return
           else
               cfg=rmfield(cfg, 'current');
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
    ('The forward operator checks to see whether cHPIs are viable. If you would like to turn this feature off, please set cfg.frame_tag_checker_off=[]: Thank you');
    end
end
data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
cd(data_subjdir) % cd to the fif dir


%% Calculating Forward Operator

% If re-running after error, make sure to clear cfg.forward_spacing,
% otherwise command will be in error

diary(strcat(subj,'_calc_forward.info'));
diary on


cfg.forward_mri_tag=[' --mri ' cfg.erm_rootdir,'/',subj,'/',num2str(visitNo),'/', subj '_1-trans.fif  '];

if ~isfield(cfg,'forward_spacing'),
    
    cfg.forward_spacing=' ico-5 ';
else
    cfg.forward_spacing=strcat(' ico-',cfg.forward_spacing);
    
end    

if isfield(cfg,'frame_tag_checker_off')
            
    fprintf('you have instructed the function not to check if cHPIs are valid for the runs before proceeding'); 

if ~isfield(cfg,'start_run_from')
cfg.start_run_from=1;
end 
    
    for irun=cfg.start_run_from:run
     cfg.frame_forward_tag{irun}='empty value';
   
   end
       
end

for irun=cfg.start_run_from:run,
   if ~isfield(cfg,'frame_tag_checker_off') 
    I=strcmp(' -frame device -origin 0 13 -6 ', cfg.frame_tag{irun});
   else
    I=strcmp(' -frame device -origin 0 13 -6 ', cfg.frame_forward_tag{irun});
   end 
    if I ==1, 
        
        fprintf('cHPI is bad for this run, %d, Checking another run if available %d\n',irun); 

      continue
    else
            cfg.forward.in_fif{irun} = strcat(subj,'_',cfg.protocol,'_',num2str(irun),'_raw.fif ');
            cfg.forward.in_fif{irun} =[data_subjdir cfg.forward.in_fif{irun}];
            cfg.forward_fif{irun} = strcat(subj,'_',cfg.protocol,'_',num2str(irun),'-fwd.fif ');
            cfg.forward_fif{irun} =[data_subjdir cfg.forward_fif{irun}];


            
            command=['mne_do_forward_solution --meas '  cfg.forward.in_fif{irun} ' --megonly --overwrite --spacing ' cfg.forward_spacing, cfg.forward_mri_tag  '  --subject  ' subj ' --fwd  ' cfg.forward_fif{irun} ' -v >& calc-forward_',num2str(irun),'.log' ];

  
            [st,w] = unix(command);
            fprintf(1,'\n Command executed: %s \n',command);
            fprintf(1,'\n Run: %d\n', irun);  
           

                        if st ~=0
                         w
                        WARNING('check Forward step');
                        fprintf(1,'\n Error with Forward operator! Run: %d\n', irun); 
                        elseif st==0 && isfield(cfg,'single_forward_operator')
                                break
                        else
                        continue
                        end
                           
    end
end


filename=strcat(subj,'_',num2str(visitNo),'_calc_forward_cfg');
save(filename,'cfg','visitNo','run','subj');

diary off        

        filename=strcat(subj,'_do_calc_forward_cfg');
        save(filename,'cfg','visitNo','run','subj');