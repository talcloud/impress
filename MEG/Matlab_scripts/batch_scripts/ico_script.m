
counter=1;

subject={'051901';
'AC058';
'AC077';
'002901';
'AC063';
'AC065';
'AC050';
'014001';
'014002';
'040401';
'AC073';
'032901';
'AC053';
'AC076';
'AC054';
'018301';
'007501';
'038301';
'AC013';
'AC069';
'AC047';
'AC071';
'009101';
'050901';
'051301';
'AC003';
'AC023';
'AC072';
'AC075';
'010401'};

%visitNo=[1];
    
 for i=1:length(subject)  
     cfg.data_rootdir='/cluster/transcend/MEG/tacr';
     fprintf('Starting subject %s\n',subject{i}); 
     

    try
    command=['mne_setup_source_space  --subject  ' ,subject{i}, ' --ico -5 --cps --overwrite  '];
    [st,w] = unix(command);
    
    
                                if st ~=0
                                    
                                error('ERROR :with ico -5')
                                 failed_subjects{counter,1}= subject{i}; 
                                 fprintf('subject failed %s\n',subject{i}); 
                                 counter=counter+1;
                                end
                                
    visitNo=[1;
    1;
    1;
    2;
    2;
    2;
    2;
    2;
    2;
    1;
    1;
    1;
    1;
    1;
    1;
    2;
    1;
    1;
    1;
    1;
    1;
    1;
    1;
    1;
    1;
    1;
    1;
    1;
    1;
    1];

    data_subjdir=strcat(cfg.data_rootdir,'/',subject{i},'/',num2str(visitNo(i)),'/');
    cd(data_subjdir) % cd to the fif dir                            
                                
    filename=strcat(subject{i},'_do_mne_preproc_grand_average_cfg.mat');
    load(filename)
    

    

    if isfield(cfg,'perform_sensitivity_map') 
    cfg=rmfield(cfg,'perform_sensitivity_map');
    end
    
    if isfield(cfg,'mne_preproc_filt') 
    cfg.mne_preproc_filt.hpf(1)=0.1;
    cfg.mne_preproc_filt.lpf(1)=144;
    end
    
    addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/');
    
    cfg.forward_spacing=' oct-5 ';
    
    [cfg]=do_calc_forward(subject{i},visitNo,1,cfg);
    [cfg]=do_calc_inverse(subject{i},visitNo,1,cfg,1);
    
    clear cfg visitNo
    catch
             fprintf('subject failed %s\n',subject{i}); 
             failed_subjects{counter,1}= subject{i};  
             counter=counter+1;  
    continue  
    end
 end