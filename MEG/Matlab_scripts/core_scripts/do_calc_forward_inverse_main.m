function [subj,visitNo,run,cfg,erm_run]=do_calc_forward_inverse_main(subj,visitNo,run,cfg,erm_run)

%   Sheraz Khan <sheraz@nmr.mgh.harvard.edu>
%   Santosh Ganesan <santosh@nmr.mgh.harvard.edu>
%   CALCULATE INVERSE OPERATOR
% Local variables:
%   1) subj = subject name
%   2) visitNo = visit number
%   3) run = run number
%   4) erm_run = erm run number, usually 1
%   5) cfg = data structure with global variables


%% Global variables
if ~isfield(cfg,'data_rootdir'),
    error('Please enter a root directory in sub-structure cfg.data_rootdir: Thank you');
end
%%
% current directories
addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/');
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



%        cfg.forward_fif;         % forward operator is necessary. It is called through this variable


%        cfg.forward_spacing=[];  % Specify ico spacing. Just enter a number. For example for ico-6, set value
% to 6. If this parameter is left EMPTY,
% DEFAULT is to to ico-5

%----------------------------------------------------------------------

%    3) cfg.do_eve_calc_inverse=[];


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
    
    if ~isfield(cfg,'do_eve_calc_inverse')
        cfg.do_eve_calc_inverse=1;
        fprintf('Performing eve_calc_inverse %s\n',subj);
    else
        cfg.do_eve_calc_inverse=0;
        fprintf('Not Performing eve_calc_inverse %s\n',subj);
    end
    
    if cfg.do_calc_inverse
        cfg.do_eve_calc_inverse=0;
    elseif cfg.do_eve_calc_inverse
        cfg.do_calc_inverse=0;
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

if (cfg.do_eve_calc_inverse)
    try
        fprintf('Starting eve inverse solution %s\n',subj);
        [cfg]=do_eve_calc_inverse(subj,visitNo,run,cfg);
        fprintf('Complete ! %s\n',subj);
        
    catch ME
        cfg.current=ME.stack.name;
        filename=strcat(subj,'_do_eve_calc_inverse_error_cfg');
        save(filename,'cfg','visitNo','run','subj','ME');
        
        
    end
end

filename=strcat(subj,'_calc_forward_inverse_main_cfg');
save(filename,'cfg','visitNo','run','subj');
diary off