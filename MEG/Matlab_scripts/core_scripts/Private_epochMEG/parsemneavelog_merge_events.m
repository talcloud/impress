function [indgood,indbad_EOG,indbad_MEG] = parsemneavelog_merge_events(logfile,eventnum)
% Reads logfile created by MNE averaging process and returns the indices of
% the good epochs
%
% USAGE:
%    [indgood, indbad] = parsemneavelog(logfile,eventnum)
%
% INPUTS:
%   logfile - The name of the MNE logfile (ascii file, any extension)
%   eventnum - The trigger value corresponding to the event of interest
%
% OUTPUTS:
%   indgood - An array of indices (integers) corresponding the good epochs
%   indbad - Indices of bad epochs
%  
% NOTE:
%   This function is intended to be used in conjunction with
%   mne_ex_read_epochs()


fprintf(1,'Parsing logfile: %s \n',logfile);

fid = fopen(logfile,'r');

pat = '(?<sampnum>\d+)\s+(?<time>\d+\.\d+)\s+(?<initvalue>\d+)\s+(?<finalvalue>\d+)\s+(?<comments>.*)';


count = 1;
indgood = [];
indbad_EOG = [];
indbad_MEG=[];
step=0; 


dline = fgetl(fid);
    if(dline == -1);
       return;
    end
    
previous=regexp(dline,pat,'names');



while(1)
    dline = fgetl(fid);
    if(dline == -1);
        break;
    end

    res = regexp(dline,pat,'names');

 if str2double(previous.sampnum)>str2double(res.sampnum)||step==1  
     step=1;  
    if((str2double(res.initvalue) == 0) && (str2double(res.finalvalue) == eventnum))
       
        if(strfind(res.comments,'EEG'))
            indbad_EOG =[indbad_EOG count];
        elseif(strfind(res.comments,'EOG'))
            indbad_EOG =[indbad_EOG count];
        elseif(strfind(res.comments,'MEG'))
            indbad_MEG=[indbad_MEG count];
        else
            indgood = [indgood count];
        end
 
 count = count + 1;
    end
    
 end
 
 previous=res;

end

