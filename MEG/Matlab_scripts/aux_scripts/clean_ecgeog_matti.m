function [ECGprojectfile EOGprojectfile out_clean_fif_File]=clean_ecgeog_matti(in_fif_File,eog_eventFileName,ecg_eventFileName,in_path)

% clean_ecg: Clean ECG from raw fif file
%
% USAGE: clean_fif_File = clean_ecg(fif_File)
%
% INPUT:
%      in_fif_File = Raw fif File
%      eog_eventFileName= name of EOG event file required.
%      ecg_eventFileName= name of ECG event file required.
%      in_path = Path where all the files are.   
%  
% Author: Sheraz Khan, 2009
%         Martinos Center
%         MGH, Boston, USA
% --------------------------- Script History ------------------------------
% SK 19-Nov-2009  Creation
% SK & NS Jun -2010 - added eog
% -------------------------------------------------------------------------

%%
% Reading fif File
cd(in_path)
[fiffsetup] = fiff_setup_read_raw(in_fif_File);

%% Geting ECG Channel
channelNames = fiffsetup.info.ch_names;
% ch_ECG = strmatch('ECG',channelNames);
% fprintf(1,'\n ECG channel index for this subject is: %d \n',ch_ECG)
% 
% if isempty(ch_ECG)
ch_ECG= 171; % closest to the heart normally, IN future we can search for it.
% fprintf(1,'\n  ECG channel is missing. Will use MEG0171 instead \n')
% end

start_samp = fiffsetup.first_samp;
end_samp = fiffsetup.last_samp;
[ecg] = fiff_read_raw_segment(fiffsetup, start_samp ,end_samp, ch_ECG);


%% detecting QRS and generating event file
sampRate = fiffsetup.info.sfreq;
fprintf(1,'\n Sampling rate for this acquisition is : %d \n',sampRate)
firstSamp = fiffsetup.first_samp;
thresh_value = 0.6;     %(qrs detection threshold)
levels = 2.5;           %(number of std from mean to include for detection)
num_thresh = 3;         %(max number of crossings)
ECG_type = 999;
ecg_events = qrsDet2(sampRate, ecg, thresh_value, levels, num_thresh);

writeEventFile(ecg_eventFileName, firstSamp, ecg_events, ECG_type);



%% Making projector for ECG

fprintf(1,'\n Making ECG projector \n')
command = ['mne_process_raw --cd ' in_path ' --raw ' in_fif_File ' --events ' ecg_eventFileName ' --makeproj --projtmin ' '-0.08' ' --projtmax ' '0.08' ' --saveprojtag ' '_ECG-proj' ' --projnmag ' '2' ' --projngrad ' '1' ' --projevent 999 --highpass ' '5' ' --lowpass ' '35 ' ' --projmagrej   4000  --projgradrej 3000'];

fprintf(1,'\n Command executed: %s \n',command);

[s,w] = unix(command)

if s ~=0
    error(w)
end

%% Applying the ECG projector

fprintf(1,'\n Applying ECG projector \n')

temp = regexp(in_fif_File,'.fif'); 
name = in_fif_File(1:temp-4);
ECGprojectfile=strcat(name,'ECG-proj','.fif');
out_fif_File= strcat(name,'ECG_clean','.fif');
command = ['mne_process_raw --cd ' in_path ' --raw ' in_fif_File ' --proj ' ECGprojectfile ' --projon --save ' out_fif_File  ' --filteroff >& proj.log'];

fprintf(1,'\n Command executed: %s \n',command);


[s, w] = unix(command)

if s ~=0
    error(w)
end
%% Geting EOG Channel
channelNames = fiffsetup.info.ch_names;
ch_EOG = strmatch('EOG',channelNames);

fprintf(1,'\n EOG channel index for this subject is: %d \n',ch_EOG)

if isempty(ch_EOG)
error('EOG channel not found !!')
end

sampRate = fiffsetup.info.sfreq;

start_samp = fiffsetup.first_samp;
end_samp = fiffsetup.last_samp;
[eog] = fiff_read_raw_segment(fiffsetup, start_samp ,end_samp, ch_EOG);

fprintf(1,'\n Filtering the data to remove DC offset to help distinguish blinks from saccades \n')

filteog = eegfilt(eog, sampRate,2,[]); % filtering to remove dc ofset so that we know which is blink and saccade.
temp=sqrt(sum(filteog.^2,2));
[temp1, indexmax ]=max(temp);
clear temp temp1 
filteog = eegfilt(eog(indexmax,:), sampRate,0,10); % easy to detect peaks with this filtering.

%% detecting eog blinks and generating event file

fprintf(1,'\n Now detecting blinks and generating corresponding event file \n')

EOG_type = 998;
firstSamp = fiffsetup.first_samp;  

temp = filteog-mean(filteog);

if abs(max(temp)) > abs(min(temp))
  eog_events = peakfinder(abs(filteog),[],1);  
else
    eog_events = peakfinder(abs(filteog),[],-1);
end
clear temp 

fprintf(1,'\n Saving event file \n')

writeEventFile(eog_eventFileName, firstSamp, eog_events, EOG_type);

%% Making projector for EOG

fprintf(1,'\n Computing EOG projector \n')

command = ['mne_process_raw --cd ' in_path ' --raw ' in_fif_File ' --events ' eog_eventFileName ' --makeproj --projtmin ' '-0.2' ' --projtmax ' '0.2' ' --saveprojtag ' '_EOG-proj' ' --projnmag ' '2' ' --projngrad ' '2' ' --projevent 998  '  ' --lowpass ' '35 ' ' --projmagrej   4000  --projgradrej 3000'];

fprintf(1,'\n Command executed: %s \n',command);


[s,w] = unix(command)
if s ~=0
    error(w)
end



%% Applying the EOG projector

fprintf(1,'\n Applying EOG projector \n')

temp = regexp(in_fif_File,'.fif'); 
name = in_fif_File(1:temp-4);
EOGprojectfile=strcat(name,'EOG-proj','.fif');
out_fif_File= strcat(name,'ECG_EOG_clean','.fif');
in_fif_File=strcat(name,'ECG_clean_raw','.fif');
command = ['mne_process_raw --cd ' in_path ' --raw ' in_fif_File ' --proj ' EOGprojectfile ' --projon --save ' out_fif_File  ' --filteroff >& proj.log'];


fprintf(1,'\n Command executed: %s \n',command);

[s, w] = unix(command)

if s ~=0
    error(w)
end

out_clean_fif_File= strcat(name,'_ECG_clean_raw','.fif');

fprintf(1, '\n Done removing ECG and EOG artifacts. IMPORTANT : Please eye-ball the data !! \n')


