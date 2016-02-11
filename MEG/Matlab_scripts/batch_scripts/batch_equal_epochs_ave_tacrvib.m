%% Directory info
cfg.protocol='tacrvib';
% .Ave file for ERM
cfg.covdir = ('/cluster/transcend/scripts/MEG/descriptors/cov_descriptors/from_calvin_001_marvin');
% .Ave file for Protocol
% cfg.protocol_covdir = ('/space/sondre/2/users/meg/wmm');
cfg.protocol_covdir=('/cluster/transcend/scripts/MEG/descriptors/ave_descriptors/from_marvin_001');
% Data Directory
cfg.data_rootdir=('/autofs/space/amiga_001/users/meg/tacrvib');
%cfg.data_rootdir=('/autofs/space/amiga_001/users/meg/tacr_new');
% ERM Directory
% cfg.erm_rootdir=('/autofs/cluster/transcend/manfred/erm');
cfg.erm_rootdir=('/autofs/space/amiga_001/users/meg/erm1');


% For calc/forward inverse
cfg.setMRIdir=('/space/sondre/1/users/mri/mit/recon');
addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/');


%% Tacr vib
subject={ 'AC013';'041901'; '018301';
     '010401';
     '010001';

'017801';





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

'042301';
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
'AC077';'AC042';'AC069';'014002';'018301';'014901';'012301';'014001';'AC050';'AC063';'AC065';'043202';'012301';'002901';'050901';'AC047'};
 visitNo=[ones(45,1);2;2;2;2;2;2;2;2;1;3;2;1;2];
%subject={'002901';'AC042'};
%visitNo=[2,1];
%visitNo=[ones(44,1);2;2;2;2;2;2;2;2;1;3;2;1];
counter=1;
erm_run=ones(52,1);
run=ones(70,1);


%% Running Paradigm

%matlabpool 8
%for i=1:length(subject)
for i=1:length(subject);

    try
% cding into directory        
customAveGenerator(subject{i},51,70,'tacrvib',visitNo(i))


    catch

    fprintf('Subject Failed ! %s\n',subject{i});
  
    continue


    end

end
%matlabpool close
