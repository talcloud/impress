function [cfg]=batchlabels(subj,cfg,labelyear)

%% Global Variables

if ~isfield(cfg,'data_rootdir'),
error('Please enter a root directory in sub-structure cfg.data_rootdir: Thank you');
end

if ~isfield(cfg,'protocol'),
 error('Please enter a protocol name in sub-structure cfg.protocol: Thank you');
end


%% Generating Labels

if~isfield(cfg,'setMRI')
    cfg.setMRI=['/autofs/space/calvin_001/marvin/1/users/MRI/WMA/recons'];
end

switch (labelyear)

    case '2009'
aparc='  aparc.a2009s  ';
    case '2005'
aparc=' aparc ';
end

amp_sub_folders=dir(cfg.data_rootdir);



for i=1:length(amp_sub_folders);
    
    try

    subjdir= [cfg.setMRI,'/',subj];
  
    ls(subjdir);
        try
      [success,message,messageid]=mkdir(subjdir,'/',labelyear,'_labels');
        catch
        fprintf('mkdir failed %s\n',subj)
        continue
        end
    command=['mri_annotation2label --subject ', subj,  '  --hemi rh --outdir ',cfg.setMRI,subj, '/',labelyear,'_labels --annotation ',aparc, '--surface white'];
    [st,wt]=unix(command);
        
        if st ~=0
            error('ERROR : check rh')
        end
        command=['mri_annotation2label --subject ',subj,  '  --hemi lh --outdir ',cfg.setMRI,subj, '/',labelyear,'_labels --annotation ',aparc, '--surface white'];
    [st,wt]=unix(command);
        
        if st ~=0
            error('ERROR : check lh')
        end
    
    catch
       fprintf(1,'\n Label generation for subject failed: %s \n',subj);
    continue
        
    end
    
end

