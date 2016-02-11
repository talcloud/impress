%% Global Variables

cfg.protocol='wmm';
% .Ave file for ERM
cfg.covdir = ('/cluster/transcend/scripts/MEG/descriptors/cov_descriptors/from_calvin_001_marvin');
% .Ave file for Protocol
 cfg.protocol_avedir = ('/autofs/cluster/transcend/manfred');

% Data Directory
cfg.data_rootdir=('/cluster/transcend/manfred/wmm');

% ERM Directory
 cfg.erm_rootdir=('/autofs/space/amiga_001/users/meg/erm1');
%cfg.erm_rootdir=('/cluster/transcend/manfred/erm');


% For calc/forward inverse
cfg.setMRIdir=('/space/sondre/1/users/mri/mit/recon');
addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/');


%% wmm

subject={'005801','007501','009101','009102','009901','012002','012301','013703','015001','027202','011202','010302','010302','008801','014001','014002','014901','015601','030801','055201','007501','026801','AC017','AC019','AC021','046503','018201','005901','011302','016201','017801','021301','058501','059601'};

        erm_run=[ones(64,1)];
run=[1;1;1;1;1;1;1;1;1;1;ones(22,1);1;1];
%                  run=[2;1;1;2];
         %run=[3,3];
        % visitNo of each of the subject(s). if multiple, can be a matrix
        % If multiple dimensions, must match length(cfg.amp_sub_folders) 
        visitNo=[ones(34,1)];
%         filename=strcat('Batch_intital_parameters_',cfg.protocol,'cfg');
%         save(filename,'cfg','visitNo','run','erm_run');

%%
 %erm_run=ones(52,1);
%         run=[2;2;2;2;2;2;2;2;2;2;ones(21,1);2;1];
    
    
 %       visitNo=[ones(34,1)];
cfgsheet=[];
spreadsheet_start=2;
for i=1:length(subject)
     try
         
   fprintf('Processing subject %s\n',subject{i});      
[cfgsheet,spreadsheet_start]=do_output_protocol_chart(cfg.data_rootdir,subject{i},visitNo(i),run(i),cfgsheet,cfg,spreadsheet_start);
     catch
     continue
     end
end
cd(cfg.data_rootdir);
c=clock;
filename=strcat(cfg.protocol,'_spreadsheet_',datestr(c),'.txt');
cell2csv(filename, cfgsheet.output_fields);
    