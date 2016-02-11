function eventFileName=add_triggers(in_fif_File,eventDistance,eventNumber,stemEventFile)

% clean_ecg: Clean ECG from raw fif file
%
% USAGE: clean_fif_File = clean_ecg(fif_File)
%
% INPUT:
%     in_fif_File     =  Raw fif File
%     eventDistance   =  Distance between ecvents inseconds
%     eventNumber     =  Event number you want to assign
%     stemEventFile   =  Name of the new event file you want to give.
% OUTPUT:
%      eventFile      =  event file containing event information
%
% Author: Sheraz Khan, PhD
%         Martinos Center
%         MGH, Boston, USA
% --------------------------- Script History ------------------------------
% SK 20-DEC-2010  Creation
% sheraz@nmr.mgh.harvard.edu
% -------------------------------------------------------------------------


% Reading File Parameters

[fiffsetup] = fiff_setup_read_raw(in_fif_File);

sampRate = fiffsetup.info.sfreq;
start_samp = fiffsetup.first_samp;
end_samp = fiffsetup.last_samp;

% Making appropraite name for event file
temp = regexp(in_fif_File,'.fif'); 
name = in_fif_File(1:temp-1);
eventFileName=strcat(name,'_',stemEventFile,'-eve','.fif');


% Finding events
totalLength=end_samp-start_samp+1;

events=1:round(sampRate*eventDistance):totalLength;


% Removing last event if it less than other evetns
if (totalLength-events(end))<round(sampRate*eventDistance)
    
    events(end)=[];
end

% writing event file
writeEventFile(eventFileName, start_samp, events, eventNumber)

