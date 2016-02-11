
function [cfg]=do_erm_noise_covariance(subj,visitNo,erm_run,cfg)
    
    % Generates filtered variants of SSS data of all subjects for a
    % paradigm. Assumes default subject list. 
    %--------------------------------------
    % Dr Engr. Sheraz Khan,  P.Eng, Ph.D.
    % Engr. Nandita Shetty,  MS.
    %
    % Modified By Santosh Ganesan
    % Date:   June 15, 2011
    %--------------------------------------
  %% Error Check
if isfield(cfg,'current')
    I=strmatch(cfg.current,'do_erm_noise_covariance');
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

    if ~isfield(cfg,'covdir')
    error('Please enter a covariance directory in sub-structure cfg.covdir: Thank you');
    end
  
    if ~isfield(cfg,'filt')
    cfg.filt=[];
    end
    
%     erm_subjdir=[cfg.erm_rootdir '/' subj '/' num2str(visitNo) '/'];
%     cd(erm_subjdir) % cd to the fif dir 

data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
cd(data_subjdir);
    diary(strcat(subj,'_erm_noise_covariance.info'));
    diary on


%% Computation of noise  files.MM
    
  if(cfg.erm_decimation~=1),
        warning('ERM data does not appear to be decimated, cfg.erm_decimation is not set ')     
  end

    
  cfg.noise_cov=cfg.filt;
  
  if isempty(cfg.noise_cov),
        cfg.noise_cov.hpf(1)=1;
        cfg.noise_cov.lpf(1)=144;
        cfg.noise_cov.hpf(2)=.1;
        cfg.noise_cov.lpf(2)=25;       
        cfg.noise_cov.hpf(3)=1;
        cfg.noise_cov.lpf(3)=40;
        cfg.noise_cov.hpf(4)=.1;
        cfg.noise_cov.lpf(4)=144;
        cfg.noise_cov.hpf(5)=.3;
        cfg.noise_cov.lpf(5)=40;
        for default=1:5
        fprintf(' Default highpass    %d to lowpass %d\n', cfg.noise_cov.hpf(default),cfg.noise_cov.lpf(default));
        end
  end
  
 
  fprintf('computing noise files %s\n',subj);
     
     

       
for irun=1:erm_run,

   for inoise=1:length(cfg.noise_cov.hpf),

       cfg.mne_raw_tag{irun} = ['--raw ' subj '_erm_' num2str(irun),'_',num2str(cfg.noise_cov.hpf(inoise)),'-',num2str(cfg.noise_cov.lpf(inoise)),'fil_raw.fif '];

       command = ['mne_process_raw --projoff  ',' --filteroff  ', cfg.mne_raw_tag{irun} '--cov ' cfg.covdir,'/', 'erm.cov ' ' --savecovtag ','-cov  ' ' >& ' subj '_',num2str(irun),'_',num2str(cfg.noise_cov.hpf(inoise)),'-',num2str(cfg.noise_cov.lpf(inoise)),'fil-cov.log'];

           [st,wt] = unix(command);
           fprintf(1,'\n Command executed: %s \n',command);
           fprintf(1,'\n Run: %d\n', irun);
           fprintf(1,'\n computing noise files:  %d to  %d\n',(cfg.noise_cov.hpf(inoise)),(cfg.noise_cov.lpf(inoise)));

                if st ~=0
                 error('ERROR : error in computing noise file  %d to %d\n',(cfg.noise_cov.hpf(inoise)),(cfg.noise_cov.lpf(inoise)));
                end

            fprintf(1,'\n Success!:  %d to  %d\n',(cfg.noise_cov.hpf(inoise)),(cfg.noise_cov.lpf(inoise)));

      
      
   end
end
 
     diary off
     
         filename=strcat(subj,'_do_erm_noise_covariance_cfg');
        save(filename,'cfg','visitNo','erm_run','subj');    
