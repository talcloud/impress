function do_faces_mne_preproc(subj,para,nrun)

% Generates a bash script to SSS and filter the data of all subjects for a
% paradigm. Assumes default subject list. It also generates a matlab script
% to convert filtered data to eeglab format and calculate ICA.
%
% USAGE:
%   scriptgen(para,scriptname,matname);
% para: Paradigm
%  1 for two-tone
%  2 for WMM
%  3 for eyes closed
%  4 for ampliotopy
%  12 for fmm
%  13 for fmm with noise

%--------------------------------------------------------------------------


%% Global Variables

s=subj;
avedir=('/space/marvin/1/users/MEG/descriptors/ave_templates/');
rootdir=('/autofs/space/sondre_002/users/meg/');
p=para;

% number of runs
switch nrun
    case 1
        run = 1;

    case 2
        run = [1,2];

    case 3
        run = [1,2,3];

    otherwise
        display('ERROR : This script does not support analysis of 4 or more runs');
        return;
end

% generates mne_proces_raw tags for ave/gave calculations
if numel(run)==1
%     raw_tag = ['--raw ' s '_' p '_1_ecgClean_raw.fif ']; % takes as input raw files who's ecg component has been removed i.e <subj>_<paradigm>_<run>_ecgClean_raw.fif
%     %orig_tag = ['--raw ' s '_' p '_1_raw.fif '];
%     filt40_tag = ['  --lowpass 40 --highpass 2 --projon ' ' --save ' s '_' p '_1_40fil.fif ']; % saves filtered file <subj>_<paradigm>_<run>_40fil.fif
%     filt144_tag = [' --filteroff --projon ' ' --save ' s '_' p '_1_144fil.fif ']; % saves filtered file <subj>_<paradigm>_<run>_100fil.fif


else if numel(run)==2
%         raw_tag = ['--raw ' s '_' p '_1_ecgClean_raw.fif ' ' --raw ' s '_' p '_2_ecgClean_raw.fif ']; % takes as input raw files who's ecg component has been removed i.e <subj>_<paradigm>_<run>_ECG_EOG_clean_raw.fif
%         filt40_tag = ['  --lowpass 40  --highpass 2    --projon   ' ' --save ' s '_' p '_1_40fil.fif ' ' --save ' s '_' p '_2_40fil.fif ']; % saves filtered file <subj>_<paradigm>_<run>_40fil.fif
%         filt144_tag = ['--filteroff   --projon  ' ' --save ' s '_' p '_1_144fil.fif ' ' --save ' s '_' p '_2_144fil.fif ']; % saves filtered file <subj>_<paradigm>_<run>_40fil.fif


    else if numel(run)==3
            raw_tag = ['--raw ' s '_' p '_1_new_1-40fil_raw.fif' ' --raw ' s '_' p '_2_new_1-40fil_raw.fif ' ' --raw ' s '_' p '_3_new_1-40fil_raw.fif '  ]; % takes as input raw files who's ecg component has been removed i.e <subj>_<paradigm>_<run>_ECG_EOG_clean_raw.fif
            filt20_tag = [' --lowpass 20 --highpass 2 --projon' ' --save ' s '_' p '_1_20fil.fif ' ' --save ' s '_' p '_2_20fil.fif ' ' --save ' s '_' p '_3_20fil.fif ']; % saves filtered file <subj>_<paradigm>_<run>_40fil.fif
            %filt144_tag = [' --filteroff --projon ' ' --save ' s '_' p '_1_144fil.fif ' ' --save ' s '_' p '_2_144fil.fif ' ' --save ' s '_' p '_3_144fil.fif ']; % saves filtered file <subj>_<paradigm>_<run>_40fil.fif


        else

            error('ERROR : This script does not support analysis of 3 or more runs')

        end

    end

end

subjdir=[rootdir '/' p '/' s '/'];

cd(subjdir) % cd to the fif dir

% diary('mne_preproc_on_sss-fif.info');
% diary on

% fprintf(1,'\n Beginning MNE pre-processing for SUBJECT: %s \n',s);
% fprintf(1,'\n Analyzing paradigm: %s \n',p);
% fprintf(1,'\n Number of runs for this paradigm: %d \n',nrun);
%%



%%  Removal of heart-beat component
% for n = 1:numel(run)
%     in_fif = strcat(s,'_',p,'_',num2str(run(n)),'_sss.fif');
%     out_fif = strcat(s,'_',p,'_',num2str(run(n)),'_ecgClean.fif');
%     in_path=subjdir;
%     projectfile= strcat(s,'_',p,'_',num2str(run(n)),'_proj','.fif');
% 
%     eventFileName =strcat(s,'_',p,'_',num2str(run(n)),'_ecg_eve','.fif');
% 
%     fprintf(1,'\n Implementing ECG artefact rejection on data \n');
%     clean_ecg(in_fif,out_fif,projectfile,eventFileName,in_path) % check channel STI014
% end % end of for n = 1:numel(run)
%%


%% Computation of filtered, evoked and grand-average files.


% Computes the evoked data with a LPF cut off of 98Hz

% fprintf(1,'\n Filtering the data at 144 Hz \n ' )
% command = ['mne_process_raw ' raw_tag filt144_tag ' --ave ' avedir p '.ave ' ' --saveavetag -144fil-ave  '  ' >& ' s '_' p '_144fil-ave.log'];
% 
% fprintf(1,'\n Command executed: %s \n',command);
% 
% [st,wt] = system(command);
% 
% if st ~=0
%     error('ERROR : error in computing evoked data with 98 LPF; No High Pass')
%     error(wt)
% end
% 
% fprintf(1,'\n DONE: Filtering the data at 144 Hz \n ' )



% Computes the evoked data with a LPF cut off of 40Hz


% fprintf(1,'\n Filtering the data with LPF of 40; No High Pass \n ' )

command = ['mne_process_raw ' raw_tag  filt20_tag   ' >& ' s '_' p '_20fil-ave.log'];

% fprintf(1,'\n Command executed: %s \n',command);

[st,~] = system(command);

if st ~=0
    error('ERROR : error in computing evoked data with 40 LPF');
end


% fprintf(1,'\n DONE: Filtering the data with LPF of 20;  High Pass 2Hz \n ' )
% 
% fprintf(1,'\n Setting permissions to acqtal \n ' )
% 
% 
% fprintf(1,'\n Done generating evoked data. You may now proceed with more interesting analyses :) \n ' )


! /usr/pubsw/bin/setgrp acqtal *
! chmod 775 *

% diary off

end
%%
