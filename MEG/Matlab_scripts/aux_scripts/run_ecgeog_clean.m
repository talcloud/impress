function run_ecgeog_clean(subj,para)

% This script do no sss
% subj= subject id




%% Processing raw data
s=subj;
p=para;
rootdir=('/autofs/space/sondre_002/users/meg');
subjdir=[rootdir '/' p '/' s '/'];
cd(subjdir); % cd to the fif dir

diary('ecgeog_clean.info');
diary on

fprintf(1,'\n Beginning processing for ecg and eog artefact rejection SUBJECT: %s \n',s);
fprintf(1,'\n Analyzing paradigm: %s \n',p);


% Removing ECG EOG artifacts
in_fif_File = strcat(s,'_',p,'_','1','_sss.fif');
ecg_eventFileName =strcat(s,'_',p,'_','1','_ecg-eve','.fif');
eog_eventFileName =strcat(s,'_',p,'_','1','_eog-eve','.fif');
in_path=subjdir;
        
clean_ecgeog_tacr(in_fif_File,eog_eventFileName,ecg_eventFileName,in_path)

diary off
