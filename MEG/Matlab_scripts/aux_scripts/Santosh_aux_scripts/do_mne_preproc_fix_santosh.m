function do_mne_preproc_fix_santosh(subj,para,nrun,removeECG_EOG)

% Generates a bash script to SSS and filter the data of all subjects for a
% paradigm. Assumes default subject list. It also generates a matlab script
% to convert filtered data to eeglab format and calculate ICA.
%
% USAGE:
% do_mne_preproc(para,scriptname,matname);
% para: Paradigm
%  1 for two-tone
%  2 for WMM
%  3 for eyes closed
%  4 for ampliotopy
%  12 for fmm
%  13 for fmm with noise
%--------------------------------------
% Dr Engr. Sheraz Khan,  P.Eng, Ph.D.
% Engr. Nandita Shetty,  MS.
%
% Creation date: October, 2010
%--------------------------------------

%% Global Variables

s=subj;
avedir=('/autofs/space/marvin_001/users/MEG/descriptors/ave_templates/');
rootdir=('/autofs/space/amiga_001/users/meg');
p=para;
% nVisit=num2str(nVisit);


% number of runs
switch nrun
    case 1
        run = [1];

    case 2
%         run=2;
        run = [1,2];

    case 3
        run = [1,2,3];

    otherwise
        display('ERROR : This script does not support analysis of 4 or more runs');
        return;
end

% generates mne_proces_raw tags for ave/gave calculations

% subjdir=[rootdir '/' p '/' s '/' nVisit '/'];

subjdir=[rootdir '/' s '/' ];

cd(subjdir) % cd to the fif dir

diaryFile=strcat(s,'_mne_preproc_on_sss-fif.info');
diary(diaryFile);
diary on

fprintf(1,'\n Beginning MNE pre-processing for SUBJECT: %s \n',s);
fprintf(1,'\n Analyzing paradigm: %s \n',p);
fprintf(1,'\n Number of runs for this paradigm: %d \n',nrun);
fprintf(1,'\n ECG-EOG reject option: %d \n',removeECG_EOG);


%%  Removal of heart-beat component
if removeECG_EOG==1
 for n = 1:1
% for n = 1:numel(run)
    in_fif = strcat(s,'_',p,'_',num2str(run(n)),'_sss.fif');
    out_fif = strcat(s,'_',p,'_',num2str(run(n)),'_ecgClean.fif');
    in_path=subjdir;
    projectfile= strcat(s,'_',p,'_',num2str(run(n)),'_proj','.fif');

    eventFileName =strcat(s,'_',p,'_',num2str(run(n)),'_ecg_eve','.fif');

    fprintf(1,'\n Implementing ECG artifact rejection on data \n');
    clean_ecg(in_fif,out_fif,projectfile,eventFileName,in_path) % check channel STI014
end % end of for n = 1:numel(run)

elseif removeECG_EOG==2
for n = 1:numel(run)
    in_fif = strcat(s,'_',p,'_',num2str(run(n)),'_sss.fif');
    out_fif = strcat(s,'_',p,'_',num2str(run(n)),'_ecgeogClean.fif');
    in_path=subjdir;
    projectfile= strcat(s,'_',p,'_',num2str(run(n)),'_proj','.fif');

    eventFileName =strcat(s,'_',p,'_',num2str(run(n)),'_ecg_eve','.fif');
    fprintf(1,'\n Implementing ECG and EOG artifact rejection on data \n')
    clean_ecgeog(in_fif,out_fif,projectfile,eventFileName,in_path) % check channel STI014
end % end of for n = 1:numel(run)

elseif removeECG_EOG==0
    display('No ECG, EOG artifacts removed')


end
%%
if removeECG_EOG==1
    if numel(run)==1
        raw_tag = ['--raw ' s '_' p '_1_ecgClean_raw.fif ']; % takes as input raw files who's ecg component has been removed i.e <subj>_<paradigm>_<run>_ecgClean_raw.fif
        filt144_tag = [' --filteroff --projon ' ' --save ' s '_' p '_1_144fil.fif ']; % saves filtered file <subj>_<paradigm>_<run>_100fil.fif
            filt40_tag = ['  --lowpass 40 --highpass 2 --projon ' ' --save ' s '_' p '_1_40fil.fif ']; % saves filtered file <subj>_<paradigm>_<run>_40fil.fif

    else

        error('ERROR : This script does not support analysis of 1 or more runs')

   end

elseif removeECG_EOG==2
    
if run==1
% if numel(run)==2
    raw_tag = ['--raw ' s '_' p '_',num2str(1),'_ecgClean_raw.fif' ' ' '--raw ' s '_' p '_',num2str(1),'_ecgClean_raw.fif ']; % takes as input raw files who's ecg component has been removed i.e <subj>_<paradigm>_<run>_ECG_EOG_clean_raw.fif
  filt1_25_tag = [' --highpass 1 --lowpass 25 --projoff ' ' --save ' s '_' p '_' num2str(1),'_1-25fil.fif '];
    filt25_tag = ['  --lowpass 25 --projoff ' ' --save ' s '_' p '_' num2str(1),'_.1-25fil.fif '];
    filt20_tag = ['  --lowpass 20 --projoff ' ' --save ' s '_' p '_' num2str(1),'_1-20fil.fif '];
    filt40_tag = [' --highpass 1 --lowpass 40 --projoff ' ' --save ' s '_' p '_' num2str(1),'_1-40fil.fif '];
    filt144_tag = [' --highpass 1 --lowpass 144 --projoff ' ' --save ' s '_' p '_' num2str(1),'_1-144fil.fif '];

else 
       raw_tag = ['--raw ' s '_' p '_',num2str(2),'_ecgClean_raw.fif' ' ' '--raw ' s '_' p '_',num2str(2),'_ecgClean_raw.fif ']; % takes as input raw files who's ecg component has been removed i.e <subj>_<paradigm>_<run>_ECG_EOG_clean_raw.fif
  filt1_25_tag = [' --highpass 1 --lowpass 25 --projoff ' ' --save ' s '_' p '_' num2str(2),'_1-25fil.fif '];
    filt25_tag = ['  --lowpass 25 --projoff ' ' --save ' s '_' p '_' num2str(2),'_.1-25fil.fif '];
    filt20_tag = ['  --lowpass 20 --projoff ' ' --save ' s '_' p '_' num2str(2),'_1-20fil.fif '];
    filt40_tag = [' --highpass 1 --lowpass 40 --projoff ' ' --save ' s '_' p '_' num2str(2),'_1-40fil.fif '];
    filt144_tag = [' --highpass 1 --lowpass 144 --projoff ' ' --save ' s '_' p '_' num2str(2),'_1-144fil.fif '];  
        
    
% else removeECG_EOG==0
%     
%     if numel(run)==1
%     raw_tag = ['--raw ' s '_' p '_1_ecgeogClean_raw.fif ']; % takes as input raw files who's ecg component has been removed i.e <subj>_<paradigm>_<run>_ecgClean_raw.fif
%     filt144_tag = [' --filteroff --projon ' ' --save ' s '_' p '_1_144fil.fif ']; % saves filtered file <subj>_<paradigm>_<run>_100fil.fif
%     else
%     error('ERROR : This script does not support analysis of 3 or more runs')
%     end
%     
%    else
%     error('ERROR : This script does not support analysis of 3 or more runs')
%     end
    
end

%% Computation of filtered, evoked and grand-average files.


% Computes the evoked data with a LPF cut off of 144Hz



in_fiff_File=strcat(subjdir,s,'_movM_1_ecgeogClean_raw.fif');
% eventfix4secFileName=add_triggers(in_fiff_File,4,997,'fix4sec');
 eventfix2secFileName=add_triggers(in_fiff_File,2,996,'fix2sec');
% eventmovfFileName=add_triggers(in_fiff_File,2,995,'movf');



fprintf(1,'\n Filtering the data at 144 Hz \n ' )
command = ['mne_process_raw ' raw_tag filt144_tag  '  --ave ' avedir  'fix2sec.ave ' ' --events  '  eventfix2secFileName  '  --saveavetag -144fil-ave  '  ' >& ' s '_' p '_2sec_144fil-ave.log'];

fprintf(1,'\n Command executed: %s \n',command);

[st,wt] = system(command)

if st ~=0
    display('ERROR : error in computing evoked data with 144 LPF; No High Pass')
%     error(wt)
end

fprintf(1,'\n DONE: Filtering the data at 144 Hz \n ' )


% Computes the evoked data with a LPF cut off of 20Hz

fprintf(1,'\n Filtering the data at 20 Hz and HPF of 1Hz \n ' )
command = ['mne_process_raw ' raw_tag filt20_tag  '  --ave ' avedir  'fix2sec.ave ' ' --events  '  eventfix2secFileName  '  --saveavetag -144fil-ave  '  ' >& ' s '_' p '_2sec_144fil-ave.log'];

fprintf(1,'\n Command executed: %s \n',command);

[st,wt] = system(command)

if st ~=0
    display('ERROR : error in computing evoked data with 20 LPF; High Pass of 1Hz')
    error(wt)
end

fprintf(1,'\n DONE: Filtering the data at 144 Hz \n ' )




% Computes the evoked data with a LPF cut off of 40Hz


fprintf(1,'\n Filtering the data with LPF of 40Hz and HPF of 1Hz \n ' )

command = ['mne_process_raw ' raw_tag  filt40_tag  ' --ave ' avedir 'fix2sec.ave ' ' --events  '  eventfix2secFileName  '  --saveavetag -144fil-ave  '  ' >& ' s '_' p '_2sec_144fil-ave.log'];

fprintf(1,'\n Command executed: %s \n',command);

[st,wt] = system(command)

if st ~=0
    display('ERROR : error in computing evoked data with 40Hz LPF and 1Hz HPF');
    error(wt)
end





fprintf(1,'\n DONE: Filtering the data with LPF of 40 Hz;  High Pass 1Hz \n ' )


% Computes the evoked data with a LPF cut off of 25Hz


fprintf(1,'\n Filtering the data with LPF of 25Hz and HPF of 1Hz \n ' )

command = ['mne_process_raw ' raw_tag  filt1_25_tag ' --ave ' avedir 'fix2sec.ave ' ' --events  '  eventfix2secFileName  '  --saveavetag -144fil-ave  '  ' >& ' s '_' p '_2sec_144fil-ave.log'];

fprintf(1,'\n Command executed: %s \n',command);

[st,wt] = system(command)

if st ~=0
    display('ERROR : error in computing evoked data with 25Hz LPF and 1Hz HPF');
    error(wt)
end





fprintf(1,'\n DONE: Filtering the data with LPF of 25 Hz;  High Pass 1Hz \n ' )



% Computes the evoked data with a LPF cut off between .1 & 25Hz


fprintf(1,'\n Filtering the data with LPF of 25Hz and HPF of .1Hz \n ' )

command = ['mne_process_raw ' raw_tag  filt25_tag ' --ave ' avedir 'fix2sec.ave ' ' --events  '  eventfix2secFileName  '  --saveavetag -144fil-ave  '  ' >& ' s '_' p '_2sec_144fil-ave.log'];

fprintf(1,'\n Command executed: %s \n',command);

[st,wt] = system(command)

if st ~=0
    display('ERROR : error in computing evoked data with 25Hz LPF and .1Hz HPF');
    error(wt)
end





fprintf(1,'\n DONE: Filtering the data with LPF of 25 Hz;  High Pass .1Hz \n ' )







fprintf(1,'\n Setting permissions to acqtal \n ' )


fprintf(1,'\n Done generating evoked data. You may now proceed with more interesting analyses :) \n ' )


! /usr/pubsw/bin/setgrp acqtal *
! chmod 775 *

diary off

end
%%
