function [cfg]=do_calc_inverse(subj,visitNo,run,cfg,erm_run)
  
if nargin<5,
    erm_run=1;
end



%% Error Check
if isfield(cfg,'error_mode')
    
   file= exist(strcat(subj,'_do_calc_inverse_error_cfg.mat'),'file');
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

cfg.inv_cov_tag =cfg.mne_preproc_filt;
if isempty(cfg.inv_cov_tag)
        cfg.inv_cov_tag.hpf(1)=1;
        cfg.inv_cov_tag.lpf(1)=144;
        fprintf('Values for inv_cov_tag not chosen, setting them to defaults: highpass    %d to lowpass %d\n', cfg.inv_cov_tag.hpf(1),cfg.inv_cov_tag.lpf(1));
        fprintf(' highpass    %d to lowpass %d\n', cfg.inv_cov_tag.hpf(1),cfg.inv_cov_tag.lpf(1));
end
data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
cd(data_subjdir) % cd to the fif dir
%% Checking the existence and validity of projections




diary(strcat(subj,'_inverse_solution.info'));
diary on

if ~isfield(cfg,'removeECG_EOG')
cfg.removeECG_EOG=2;
fprintf('cfg.removeECG_EOG not set within subject  %s\n',subj);
end

if ~isfield(cfg,'start_run_from')
cfg.start_run_from=1;
end

if cfg.removeECG_EOG==0,
                fprintf('ECG & EOG projections are turned off, cfg.removeECG_EOG=0  %s\n',subj);
                cfg.inv_proj_tag=[' --proj off  '];

else
    if cfg.removeECG_EOG==2,
    
            fprintf('ECG & EOG projections are both taken into inverse  %s\n',subj);
            multiple_eog_tag=cell(1,run);
            multiple_eog_tag{1}=[' --proj ' subj,'_',cfg.protocol,'_1_eog_proj.fif  ']; 
            multiple_run_tag=cell(1,run);
            multiple_run_tag{1}=[' --proj ',subj,'_',cfg.protocol,'_1_ecg_proj.fif  '];
            cfg.multiple_ecg_eog_tag=[];
            
        if run>1,    
            for irun=2:run
            multiple_eog_tag{irun}=[' --proj ' subj,'_',cfg.protocol,'_',num2str(irun),'_eog_proj.fif ',' '];
            multiple_run_tag{irun}=[' --proj ',subj,'_',cfg.protocol,'_',num2str(irun),'_ecg_proj.fif ',' '];
            end
        end

    else
    
            fprintf(' Only ECG proj are taken into inverse  %s\n',subj);
            multiple_eog_tag=' '; 
            multiple_run_tag=cell(1,run);
            multiple_run_tag{1}=[' --proj ',subj,'_',cfg.protocol,'_1_ecg_proj.fif  '];
                if run>1,
    
                        for irun=2:run
            multiple_run_tag{irun}=[' --proj ',subj,'_',cfg.protocol,'_',num2str(irun),'_ecg_proj.fif ',' '];
                        end
    
                end
    
    end



count=0;
    for irun=1:run
    
        if cfg.removeECG_EOG==2
            temp = regexp(multiple_eog_tag{irun},'.');
            name = multiple_eog_tag{irun}(9:length(temp)-2);
                A=exist(name,'file');
                
                        if A~=2,
                            multiple_eog_tag{irun}='';
                            count=count+1;
                        else
                            count=count;
                        end
            temp = regexp(multiple_run_tag{irun},'.');
            name = multiple_run_tag{irun}(9:length(temp)-2);
                A= exist(name,'file');
                
                        if A~=2,
                           multiple_run_tag{irun}='';
                           count=count+1;
                        else
                            count=count;
                        end            
       else
            
            temp = regexp(multiple_run_tag{irun},'.');
            name = multiple_run_tag{irun}(9:length(temp)-2);
                A= exist(name,'file');
                
                        if A~=2,
                           multiple_run_tag{irun}='';
                           count=count+1;
                        else
                            count=count;
                        end
       
        end 
    
    end
    
    
    if isfield (cfg,'multiple_ecg_eog_tag')
               cfg.inv_proj_tag=[[multiple_run_tag{1:run}],[multiple_eog_tag{1:run}]];

    else
                cfg.inv_proj_tag=[[multiple_run_tag{1:run}]];
    end
    
    if count>0,
        
        fprintf(1,'\n: WARNING, NOT ALL PROJECTIONS USED   \n');

        filename=strcat(subj,'_ONLY_SOME_PROJECTIONS_USED_IN_INVERSE');
        save(filename,'multiple_run_tag','multiple_eog_tag');
        
    end
    

end

if isfield(cfg,'manually_checked_proj')
    
        for irun=1:run,
            cfg.multiple_manual_inv_tag{irun}=['   --proj ',subj,'_',cfg.protocol,'_',num2str(irun),'_ecgeog_checked-proj.fif'];
    
    
        end
                cfg.inv_proj_tag=[cfg.multiple_manual_inv_tag{1:run}];

end

%%  Performing Inverse

if ~isfield(cfg,'skip_inverse_operator')

    if (length(cfg.inv_cov_tag.lpf)~=length(cfg.inv_cov_tag.hpf))
    
            error(' There is something funky with the low pass and high pass settings you have entered, Please recheck');
    else
            fprintf('Starting Inverse Solution %s\n',subj);
    end
    
if ~isfield (cfg,'forward_operator_used_tag')
    for irun=1:run,
               cfg.forward_operator_used_tag=[subj,'_',cfg.protocol,'_',num2str(irun),'-fwd.fif'] ;
               A=exist(cfg.forward_operator_used_tag,'file');
               if A==2,
                   break
               end
               
    end
end

erm_file=deblank(cfg.mne_dec_tag{erm_run}(7:end));
info=fiff_read_meas_info(erm_file);
projections=length(info.projs);
cfg.noiserank=64-projections;
    
        for icov_tag=1:length(cfg.inv_cov_tag.hpf)
    
                cfg.erm_cov_tag = [' --senscov ' cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/', subj '_erm_1_',num2str(cfg.inv_cov_tag.hpf(icov_tag)),'-',num2str(cfg.inv_cov_tag.lpf(icov_tag)),'fil-','cov.fif   ' ];
                cfg.inv_tag_loose=[' --inv '  subj '_' cfg.protocol '_',num2str(cfg.inv_cov_tag.hpf(icov_tag)),'_',num2str(cfg.inv_cov_tag.lpf(icov_tag)),'_','fil_loose_new_erm_megreg_0_new_MNE_proj-inv.fif  ' ];
                inv_tag_loose_weight=[subj '_' cfg.protocol '_',num2str(cfg.inv_cov_tag.hpf(icov_tag)),'_',num2str(cfg.inv_cov_tag.lpf(icov_tag)),'_','fil_loose_new_erm_megreg_0_new_MNE_proj-inv.fif  ' ];

            
                    
                        command=['mne_do_inverse_operator --meg --depth --loose 0.3 --noiserank ' num2str(cfg.noiserank) '  --fwd ' ,cfg.forward_operator_used_tag,  cfg.inv_proj_tag cfg.erm_cov_tag cfg.inv_tag_loose, ' -v >& calc-inverse_loose_new_erm_megreg_0_new_MNE.log' ]; 
                        [st,w] = unix(command);
                        fprintf(1,'\n Command executed: %s \n',command);
                         

                                if st ~=0
                                    w
                                error('ERROR : check Inverse step Loose fil')
                            
                                end
                    
                  
                        cfg.inv_tag_fixed = ['--inv '  subj '_' cfg.protocol '_',num2str(cfg.inv_cov_tag.hpf(icov_tag)),'_',num2str(cfg.inv_cov_tag.lpf(icov_tag)),'_','fil_fixed_new_erm_megreg_0_new_MNE_proj-inv.fif  ' ];
                        command=['mne_do_inverse_operator --meg --fixed  --noiserank ' num2str(cfg.noiserank) '  --fwd ' cfg.forward_operator_used_tag  cfg.inv_proj_tag cfg.erm_cov_tag cfg.inv_tag_fixed  ' -v >& calc-inverse_fixed_new_erm_megreg_0_new_MNE.log']; 
                          [st,w] = unix(command);
                          
                                if st ~=0
                                    w
                                error('ERROR : check Inverse step Fixed fil')

                                end
                      
                          
                        command=['mne_do_inverse_operator --meg --fixed   --noiserank ' num2str(cfg.noiserank) '  --fwd ',cfg.forward_operator_used_tag,  cfg.inv_proj_tag cfg.erm_cov_tag '  --srccov  ' inv_tag_loose_weight cfg.inv_tag_fixed ,' -v >& calc-inverse_fixed_weight_new_erm_megreg_0_new_MNE.log' ];
                        [st,w] = unix(command);
                        fprintf(1,'\n Command executed: %s \n',command);
                      
                    
                                
                                if st ~=0
                                    w
                                error('ERROR : check Inverse step Fixed Weight fil')

                                end
                    
                    
                    
                  

      
        end
else
    
    fprintf('you have instructed not to compute the inverse operator by declaring cfg.skip_inverse_operator'); 
        
end
%% Calculating Sensitivity Map
cfg.perform_sensitivity_map=[];
if isfield(cfg,'perform_sensitivity_map')
     fprintf('you have instructed the script to perform a sensitivity map by declaring cfg.perform_sensitivity_map'); 
     [cfg]=do_mne_subspace_correlationship(subj,visitNo,cfg);    
else

     fprintf('you have instructed the script to not perform a sensitivity map by not declaring cfg.perform_sensitivity_map')
end    


diary off


        filename=strcat(subj,'_do_calc_inverse_cfg');
        save(filename,'cfg','visitNo','run','subj');