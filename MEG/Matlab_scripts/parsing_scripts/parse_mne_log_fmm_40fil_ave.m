function [Standard Deviant]=parse_mne_log_fmm_40fil_ave(logfile1)
% Reads logfile created by MNE during sss step 2 and find out
% movement compensation fails or successful
%
% USAGE:
%    counter= parse_mne_sss_step2_log(logfile)
%
% INPUTS:
%   logfile - The name of the MNE logfile (ascii file, any
%   extension) *_fmm_40fil-ave.log; sss_onfif_SK.info
%
% OUTPUTS:
%   Center
%    
%--------------------------------------
% Sheraz Khan, Ph.D. , October 12, 2010
%--------------------------------------



%fprintf(1,'Parsing logfile: %s \n',logfile);

% Reading log file 
fid = fopen(logfile1,'r');



while(1)

% Reading each line    
    dline = fgetl(fid);
    if(dline == -1)
        break;
    end
% Comparing it with skipped tag

     I = strmatch('Standard : nave =', dline);
    
    if ~isempty(I)
    Standard=sscanf(dline, '%*s %*s %*s %*s %d', [1, inf]);
    I=[];
    continue;
    end
    
      I = strmatch('Deviant : nave =', dline);
    
    if ~isempty(I)
    Deviant=sscanf(dline, '%*s %*s %*s %*s %d', [1, inf]);
    I=[];
    continue;
    end
    
    
      I = strmatch('Movement Compensation:', dline);
    
    if ~isempty(I)
    Deviant=sscanf(dline, '%*s %*s %*s %*s %d', [1, inf]);
    I=[];
    continue;
    end
end