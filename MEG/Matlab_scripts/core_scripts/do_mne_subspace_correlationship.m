function [cfg]=do_mne_subspace_correlationship(subj,visitNo,run,cfg)




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


stem=[subj '_visit_' num2str(visitNo) '_run_' num2str(run) '_sensitivity_maps'];

cfg.subspace_mag='';
if isfield(cfg,'ecg_grad_number')
    if cfg.ecg_grad_number==0
        cfg.subspace_mag=' --mag';
    else
        cfg.subspace_mag='';
    end
end

if isfield(cfg,'apply_subspace_on_mag_only')
    cfg.subspace_mag=' --mag';
    
    
end


if isfield(cfg,'only_axial_proj_applied')  % added by konmic
    command=['mne_sensitivity_map  --fwd ' cfg.forward_operator_used_tag   cfg.inv_proj_tag   '  --map  ',   map_value, '  --smooth  ',smooth_value,cfg.subspace_mag, ' --mag  --w  ' stem];
else
    command=['mne_sensitivity_map  --fwd ' cfg.forward_operator_used_tag   cfg.inv_proj_tag   '  --map  ',   map_value, '  --smooth  ',smooth_value,cfg.subspace_mag, '  --w  ' stem];
end
[st,w] = unix(command);

if st ~=0
    error('ERROR : please check the validity of the forward operator or the proj tags in calculating the subspace co-relationship')
end


lh=mne_read_w_file([stem,'-lh.w']);
rh=mne_read_w_file([stem,'-rh.w']);


[N,I]=hist([lh.data;rh.data],100);
hist([lh.data;rh.data],100);
[temp II]=max(N);
cfg.subspace_corellationship_value=I(II);
xlabel('Distribution of data points of hemisphere')
set(gca,'XLim',[0 .5]);
set(gca,'XTick',[0,.1,.2,.3,.4,.5]);
title([subj,' sensitivity map']);
newfile=strcat(stem,'.png');


print('-dpng','-r300',newfile)

cd(cfg.data_rootdir);
A=exist('sensitivity_folder_png','dir');
if A~=7
    mkdir('sensitivity_folder_png')
end
source=strcat(data_subjdir,stem);
destination=strcat(cfg.data_rootdir,'/sensitivity_folder_png/');
%copyfile(source,destination);
system(['cp ' source ' ' destination])


cd(data_subjdir)

if isfield (cfg,'make_png_only')
    cd(cfg.data_rootdir);
    A=exist('damping_png','dir');
    if A~=7
        mkdir('damping_png')
    end
    cd(data_subjdir)
    stc.tmin=0;
    stc.tstep=1;
    stc.data=lh.data;
    stc.vertices=lh.vertices;
    
    mne_write_stc_file('sens-damp-lh.stc',stc);
    
    
    
    
    stc.tmin=0;
    stc.tstep=1;
    stc.data=rh.data;
    stc.vertices=rh.vertices;
    
    mne_write_stc_file('sens-damp-rh.stc',stc);
    
    
    side={'lh';'rh'};
    for i=1:2
        command=['mne_make_movie  ','--',side{i}, ' --stcin sens-damp-',side{i},'.stc --png ',cfg.data_rootdir,'/damping_png/',subj,'_sens-damp ','--subject ',subj ,' --pick 0 --smooth 5 --fthresh 0e8 --fmid 75e7 --fmax 15e8'];
        [st,w] = unix(command);
    end
    
    for i=1:2
        command=['mne_make_movie  ','--',side{i}, ' --stcin sens-damp-',side{i},'.stc --png ',cfg.data_rootdir,'/damping_png/',subj,'_sens-damp-med ','--subject ',subj ,' --view med --pick 0 --smooth 5 --fthresh 0e8 --fmid 75e7 --fmax 15e8'];
        [st,w] = unix(command);
    end
    
end

filename=strcat(subj,'_do_mne_subspace_correlationship_cfg');
save(filename,'cfg','visitNo','subj');

close all

diary off