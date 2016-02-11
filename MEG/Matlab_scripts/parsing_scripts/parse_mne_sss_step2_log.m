function counter= parse_mne_sss_step2_log(logfile)
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

counter=0;


while(1)

% Reading each line    
    dline = fgetl(fid);
    if(dline == -1)
        break;
    end
% Comparing it with skipped tag
    indicator = strcmp(dline,'Skipped 1 raw data tags.');

    if indicator
% increasing counter        
    
    counter=counter+1;

    end
    


end