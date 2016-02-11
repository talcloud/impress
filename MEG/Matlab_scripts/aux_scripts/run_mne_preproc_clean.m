function run_mne_preproc_clean(subj,para)

% This script do no sss
% subj= subject id




%% Processing raw data
s=subj;
p=para;
rootdir=('/autofs/space/sondre_002/users/meg');
subjdir=[rootdir '/' p '/' s '/'];
cd(subjdir); % cd to the fif dir

fprintf(1,'\n Beginning processing for ecg and eog artefact rejection SUBJECT: %s \n',s);
fprintf(1,'\n Analyzing paradigm: %s \n',p);

in_fif_File = strcat(s,'_',p,'_','1','_ECG_EOG_clean_raw.fif');


in_path=subjdir;
        
clean_ecgeog_tacr(in_fif_File,eog_eventFileName,ecg_eventFileName,in_path)

diary off
