function [cfg]=do_mne_subspace_correlationship(subj,visitNo,cfg)


% Create sensitivity maps for the paradigm
%
% USAGE:
%    calc_sensitivity_maps(subjs,visitNo)
%
% INPUTS:
%   subjs -   Subject Name   (string)
%   visitNo - Visit number   (as integer)
% OUTPUTS:
%   Save the sensitivity map in subject dir
%
%--------------------------------------
% Sheraz Khan,  P.Eng, Ph.D.
% Creation date::  Jan 29, 2011
%--------------------------------------


%% Error Check
if isfield(cfg,'current')
    I=strmatch(cfg.current,'do_mne_subspace_correlationship');
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


if ~isfield(cfg,'inv_proj_tag'),
 error('Please specify the projections you will be using in sub-structure cfg.inv_proj_tag: Thank you');
end

if ~isfield(cfg,'forward_operator_used_tag'),
 error('Please specify the forward tag you will be using in sub-structure cfg.forward_operator_used_tag: Thank you');
end

data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
cd(data_subjdir) % cd to the fif dir


%% Subspace Cor-relationship


diary(strcat(subj,'_mne_subspace_correlationship.info'));
diary on

if isfield (cfg,'calc_map')
  map_value=num2str(cfg.calc_map);
else
  map_value=num2str(5);  
end

if isfield (cfg,'calc_smooth')
  smooth_value=num2str(cfg.calc_smooth);
else
  smooth_value=num2str(5);  
end



stem=[subj '_sensitivity_maps'];

command=['mne_sensitivity_map  --fwd ' cfg.forward_operator_used_tag   cfg.inv_proj_tag   '  --map  ',   map_value, '  --smooth  ',smooth_value, '  --w  ' stem ]; 
[st,w] = unix(command);

if st ~=0
  error('ERROR : please check the validity of the forward operator or the proj tags in calculating the subspace co-relationship')
end


lh=mne_read_w_file([stem,'-lh.w']);
rh=mne_read_w_file([stem,'-lh.w']);


[N,I]=hist([lh.data;rh.data],100);
hist([lh.data;rh.data],100);
[temp II]=max(N);
cfg.subspace_corellationship_value=I(II);
xlabel('Distribution of data points of hemisphere')
title([subj,' sensitivity map']);
newfile=strcat(subj,'_sensitivity_map','.png');

print('-dpng','-r300',newfile)


filename=strcat(subj,'_do_mne_subspace_correlationship_cfg');
save(filename,'cfg','visitNo','subj');
        
close all        
        
diary off