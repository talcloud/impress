function [subj,visitNo,run,cfg,erm_run]=do_calc_forward_inverse_main(subj,visitNo,run,cfg,erm_run)
%% Global variables
if ~isfield(cfg,'data_rootdir'),
error('Please enter a root directory in sub-structure cfg.data_rootdir: Thank you');
end
%%
% current directories
addpath('/autofs/space/marvin_001/users/MEG/scripts/kenet/ml/curr/Santosh/SVN/');
data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
cd(data_subjdir);
diary(strcat(subj,'_calc_forward_inverse_main_.info'));
diary on

%% config file

    % Necessary for the main functions
%   1) cfg.do_calc_forward=[];
    
%         cfg.setMRIdir=[];        % Please set MRI directory here. do_calc-forward will not function
                                % without this variable set.
                   
                                
    
    
    
%   2) cfg.do_calc_inverse=[];
    
%        cfg.inv_cov_tag=[];      % cfg.inv_cov_tag/ Please set filter bands here for do_calc_inverse
                                % IF EMPTY, DEFAULT FILTERING WILL BE ACCOMPLISHED
                                % at highpass 1 Hz and lowpass of 144 Hz
                                
                                % The structure is as follows:
                                % cfg.inv_cov_tag.lpf(1)=40;
                                % cfg.inv_cov_tag.hpf(2)=2;
                                % cfg.inv_cov_tag.lpf(1)=98;
                                % cfg.inv_cov_tag.hpf(2)=0;
                                % Filter Bands set between 2-40Hz & 0-98 Hz
                                
                                
%        cfg.inv_orientation=[];  % cfg.inv_orientation/ Please set to 1 if you want LOOSE
                                % orientation, otherwise if EMPTY, inverse
                                % solution will run as FIXED ORIENTATION.In
                                % either case this field must exist in
                                % order for inverse solution to function
                                % properly
                                
%        cfg.forward_fif;         % forward operator is necessary. It is called through this variable
       
       
%        cfg.forward_spacing=[];  % Specify ico spacing. Just enter a number. For example for ico-6, set value
                                % to 6. If this parameter is left EMPTY,
                                % DEFAULT is to to ico-5
                                
    %----------------------------------------------------------------------

    
    
   % Necessary for sub-functions: Place set values here
    
%       cfg.data_rootdir=[];      % cfg.data_rootdir
%       cfg.erm_rootdir=[];       % cfg.erm_rootdir
%       cfg.protocol=[];          % cfg.protocol
% for transcend       cfg.setMRIdir='setenv SUBJECTS_DIR  /autofs/space/calvin_001/marvin/1/users/MRI/WMA/recons';  
% for AC              cfg.setMRIdir='setenv SUBJECTS_DIR /autofs/space/sondre_001/users/mri/mit/recon';  


%% Default settings                                


if ~isfield (cfg,'current')


    if ~isfield(cfg,'do_calc_forward')
        cfg.do_calc_forward=1;
        fprintf('Performing calc_forward %s\n',subj);
    else
        cfg.do_calc_forward=0;
        fprintf('Not Performing calc_forward %s\n',subj);
    end
    
    if ~isfield(cfg,'do_calc_inverse')
        cfg.do_calc_inverse=1;
        fprintf('Performing calc_inverse %s\n',subj);
    else
        cfg.do_calc_inverse=0;
        fprintf('Not Performing calc_inverse %s\n',subj);
    end

end

%% Actions

fprintf('Starting Specified Actions %s\n',subj); 


if (cfg.do_calc_forward)
    try
        fprintf('Starting forward operator %s\n',subj);    
        [cfg]=do_calc_forward(subj,visitNo,run,cfg);
        fprintf('Complete ! %s\n',subj); 

    catch ME
        cfg.current=ME.stack.name;
        filename=strcat(subj,'_do_calc_forward_error_cfg');
        save(filename,'cfg','visitNo','run','subj','ME');
    
 
    end
end


if (cfg.do_calc_inverse)
    try
        fprintf('Starting inverse solution %s\n',subj);   
        [cfg]=do_calc_inverse(subj,visitNo,run,cfg,erm_run);
        fprintf('Complete ! %s\n',subj);

    catch ME
        cfg.current=ME.stack.name;
        filename=strcat(subj,'_do_calc_inverse_error_cfg');
        save(filename,'cfg','visitNo','run','subj','ME');
       
  
    end   
end


filename=strcat(subj,'_calc_forward_inverse_main_cfg');
save(filename,'cfg','visitNo','run','subj');
diary off