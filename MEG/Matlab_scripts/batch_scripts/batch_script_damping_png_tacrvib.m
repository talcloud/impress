%% tacr


cfg.protocol='tacrvib';
% .Ave file for ERM
cfg.covdir = ('/autofs/space/calvin_001/marvin/1/users/MEG/descriptors/cov_templates');
% .Ave file for Protocol
% cfg.protocol_covdir = ('/space/sondre/2/users/meg/wmm');
cfg.protocol_covdir=('/autofs/space/marvin_001/users/MEG/descriptors/ave_templates');
% Data Directory
cfg.data_rootdir=('/autofs/space/amiga_001/users/meg/tacrvib');
%cfg.data_rootdir=('/autofs/space/amiga_001/users/meg/tacr_new');
% ERM Directory
% cfg.erm_rootdir=('/autofs/cluster/transcend/manfred/erm');
cfg.erm_rootdir=('/autofs/space/amiga_001/users/meg/erm1');



addpath('/homes/6/santosh')


 subject={  'AC013'; '018301';
     '010401';
     '010001';

'017801';




'041901';
'042201';
'042301';
'015402';
'015601';
'051301';
'009101';
'012002';



'pilotei';



'007501';
'013001';
'038301';
'038502';
'040701';
'042401';

'051901';


'AC003';




'AC023';

'AC046';
'AC047';
'AC056';

'AC053';
'AC058';
'AC061';

'ac047';

'AC067';


'AC054';

'AC064';

'AC068';
'AC071';

'AC070';
'AC072';
'AC073';
'AC075';

'AC0066';


'AC076';
'AC077';'AC042';'AC069';'014002';'018301';'014901';'012301';'014001';'AC050';'AC063';'AC065'};

counter=1;
 for i=1:length(subject),
  
    try
                erm_run=ones(52,1);
        % runs of the data to be processed. If different for different subjects, can be a matrix
         % If multiple dimensions, must match length(cfg.amp_sub_folders)
        run=ones(52,1);
%          run=[2,1];
        % visitNo of each of the subject(s). if multiple, can be a matrix
        % If multiple dimensions, must match length(cfg.amp_sub_folders) 
%visitNo=[1];
               visitNo=[ones(44,1);2;2;2;2;2;2;2;2];  
        
    fprintf('Processing single subject %s\n',subject{i});
    cd(strcat(cfg.data_rootdir,'/',subject{i},'/',num2str(visitNo(i)),'/'));

    leftfig=strcat(subject{i},'_sensitivity_maps-lh.w');
    left=mne_read_w_file(leftfig);
    
stc.tmin=0;
stc.tstep=1;
stc.data=left.data;
stc.vertices=left.vertices;
    
    mne_write_stc_file('sens-damp-lh.stc',stc);
    
    
    rightfig=strcat(subject{i},'_sensitivity_maps-rh.w');
   right= mne_read_w_file(rightfig);
    
stc.tmin=0;
stc.tstep=1;
stc.data=right.data;
stc.vertices=right.vertices;    
    
    mne_write_stc_file('sens-damp-rh.stc',stc);

    
       %command=['./mkSensMaps.csh ', subject{i}]; 
       %[st,w] = unix(command);
    catch
    fprintf('Subject Failed ! %s\n',subject{i});
    failed_subjects{counter,1}= subject{i};   
    counter=counter+1;
    end
 end