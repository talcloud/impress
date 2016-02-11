function flag= parse_mne_average(logfile)
% Reads logfile created by MNE during sss step 2 and find out
% movement compensation fails or successful
%
% USAGE:
%    counter= parse_mne_sss_step2_log(logfile)
%
% INPUTS:
%   logfile - The name of the MNE sss step 2 logfile (ascii file, any extension)
%
% OUTPUTS:
%   counter- number of data tag skip each tag about 1 second
%  
%--------------------------------------
% Sheraz Khan, Ph.D. , October 12, 2010
%--------------------------------------



fprintf(1,'Parsing logfile: %s \n',logfile);

% Reading log file 
fid = fopen(logfile,'r');


flag=0;

while(1)

% Reading each line    
    dline = fgetl(fid);
    if(dline == -1)
        break;
    end
% Comparing it with skipped tag
    indicator = strfind(dline,'Number of channels do not match');

    if ~isempty(indicator)
% increasing counter        
    
    flag=1;

    end
    


end