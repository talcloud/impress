function [indgood, indbad] = parsemneavelog(logfile,eventnum)
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


count = 0;
indgood = [];
indbad = [];
while(1)
    dline = fgetl(fid);
    if(dline == -1)
        break;
    end

    res = regexp(dline,pat,'names');

    if((str2double(res.initvalue) == 0) && (str2double(res.finalvalue) == eventnum))
        count = count + 1;
        if(strfind(res.comments,'omit'))
            indbad = [indbad count];
        else
            indgood = [indgood count];
        end
    end

end