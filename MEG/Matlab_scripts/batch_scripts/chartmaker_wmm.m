%% Global Variables

cfg.protocol='wmm';
% .Ave file for ERM
cfg.covdir = ('/cluster/transcend/scripts/MEG/descriptors/cov_descriptors/from_calvin_001_marvin');
% .Ave file for Protocol
 cfg.protocol_covdir = ('/autofs/cluster/transcend/manfred');

% Data Directory
cfg.data_rootdir=('/cluster/transcend/manfred/wmm');

% ERM Directory
% cfg.erm_rootdir=('/autofs/cluster/transcend/manfred/erm');
cfg.erm_rootdir=('/autofs/space/amiga_001/users/meg/erm1');


% For calc/forward inverse
cfg.setMRIdir=('/space/sondre/1/users/mri/mit/recon');
addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/');


%!export SUBJECTS_DIR=/autofs/space/calvin_001/marvin/1/users/MRI/WMA/recons/

% For calc/forward inverse
cfg.setMRIdir=('/space/sondre/1/users/mri/mit/recon');
addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/');

subject={'059601';'054602';'056901';'063201'};
run=[1;1;1;1];
 visitNo=[1;1;1;1;2;2;1;1;2;1;1;2;1;1;1;2;1;1;1;1;1;1;1;1;2;1;1;1;2;2;2;2;1;1;1;1;1;1;1;1;1;1;1;1;1;1  ; 2;1;1;1;1;1;1;1;1;1];
 erm_run=ones(70,1);
 
%%
 %erm_run=ones(52,1);
%         run=[2;2;2;2;2;2;2;2;2;2;ones(21,1);2;1];
    
    
 %       visitNo=[ones(34,1)];
cfgsheet=[];
spreadsheet_start=2;
%matlabpool 8
for i=1:length(subject)
     try
         
   fprintf('Processing subject %s\n',subject{i});      
[cfgsheet,spreadsheet_start]=do_output_protocol_chart(cfg.data_rootdir,subject{i},visitNo(i),run(i),cfgsheet,cfg,spreadsheet_start);
     catch
     continue
     end
    
end

%matlabpool close 
cd(cfg.data_rootdir);
c=clock;
filename=strcat(cfg.protocol,'_spreadsheet_',datestr(c),'.txt');
cell2csv(filename, cfgsheet.output_fields);
    