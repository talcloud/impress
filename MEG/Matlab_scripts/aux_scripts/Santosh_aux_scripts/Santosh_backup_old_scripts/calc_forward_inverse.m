function calc_forward_inverse(subjs,para,nRuns,visitNo,ECG_EOG)
% Create Forward and inverse solution for the paradigm
%
% USAGE:
%    calc_forward_inverse(subjs,visitNo)
%
% INPUTS:
%   subjs -   Subject Name
%   para  -   Protocol Name
%   nRuns -   Number of runs (as string in quotes)
%   visitNo - Visit number   (as string in quotes)
% OUTPUTS:
%   Save the forward and inverse operator in the subject directory
%
%--------------------------------------
% Dr Engr. Sheraz Khan,  P.Eng, Ph.D.
% Engr. Nandita Shetty,  MS.
% Creation date::  October 15, 2010
%--------------------------------------

rootdir=('/autofs/space/amiga_001/users/meg/tacr_new');
subjdir=[rootdir '/' subjs '/'];
% subjdir=[rootdir '/' para '/' subjs '/'];
cd(subjdir) % cd to the fif dir

diary('calc_fwd-inv.info');
visitNo=num2str(visitNo);
covdir=['/autofs/space/amiga_001/users/meg/erm_tacr/' subjs '/' visitNo '/'];
mri_tag=[' --mri ' covdir subjs '_1-trans.fif  '];



in_fif = strcat(subjs,'_',para,'_',num2str(1),'_raw.fif ');
in_fif =[subjdir in_fif];
forward_fif = strcat(subjs,'_',para,'-fwd.fif ');
forward_fif =[subjdir forward_fif];

command=['mne_do_forward_solution --meas '  in_fif ' --megonly --overwrite --spacing ico-5   ' mri_tag  '  --subject  ' subjs  ' --fwd  ' forward_fif ' >& '   subjs '_calc_fwd_soltn.info'  ];
fprintf(1,'\n Command executed: %s \n',command);

[st,~] = unix(command)

if st ~=0
    error('ERROR : Check Calculation of Forward Solution')
end


if nRuns==1
    
    if ECG_EOG==1
 
    proj_tag=[' --proj ' subjs  '_' para '_1_sss_proj.fif '];
    
    elseif ECG_EOG==2
        
    proj_tag=[' --proj ' subjs  '_' para '_1_sss_proj.fif ' ' --proj ' subjs  '_' para '_1_eog_proj.fif '      ];   
        
    end
    
elseif nRuns==2
    
    if ECG_EOG==1
        
    proj_tag=[' --proj ' subjs  '_' para '_1_sss_proj.fif  --proj '   subjs  '_' para '_2_sss_proj.fif ' ]; 
    
    elseif ECG_EOG==2
    
   proj_tag=[' --proj ' subjs  '_' para '_1_sss_proj.fif  --proj '   subjs  '_' para '_2_sss_proj.fif ' ' --proj ' subjs  '_' para '_1_eog_proj.fif  --proj '   subjs  '_' para '_2_eog_proj.fif ' ];      
        
    end
        
elseif nRuns==3

    if ECG_EOG==1
    
    proj_tag=[' --proj ' subjs  '_' para '_1_sss_proj.fif  --proj '   subjs  '_' para '_2_sss_proj.fif  --proj '   subjs  '_' para '_3_sss_proj.fif ']; 
    
    elseif ECG_EOG==2
        
    proj_tag=[' --proj ' subjs  '_' para '_1_sss_proj.fif  --proj '   subjs  '_' para '_2_sss_proj.fif  --proj '   subjs  '_' para '_3_sss_proj.fif ' ' --proj ' subjs  '_' para '_1_eog_proj.fif  --proj '   subjs  '_' para '_2_eog_proj.fif  --proj '   subjs  '_' para '_3_eog_proj.fif '];     
        
    end
     
else
            
    error('ERROR : This script does not support analysis of 3 or more runs')
            
end
        

%% covriance tags
 cov20_tag = [' --senscov ' covdir subjs '_erm_1-1-20fil-cov.fif  --inv '  subjs '_' para '1_20fil_proj-inv.fif  '    ' >& '   subjs '_' para '1_20fil_proj-inv.info  ' ];
 cov25_tag = [' --senscov ' covdir subjs '_erm_1-1-25fil-cov.fif  --inv '  subjs '_' para '1_25fil_proj-inv.fif  '    ' >& '   subjs '_' para '1_25fil_proj-inv.info  ' ];
 covpt1_25_tag = [' --senscov ' covdir subjs '_erm_1-.1-25fil-cov.fif  --inv '  subjs '_' para '.1_25fil_proj-inv.fif  '    ' >& '   subjs '_' para '.1_25fil_proj-inv.info  ' ];
cov40_tag = [' --senscov ' covdir subjs '_erm_1-1-40fil-cov.fif  --inv '  subjs '_' para '1_40fil_proj-inv.fif  '  ' >& '   subjs '_' para '1_40fil_proj-inv.info  '  ];
cov144_tag =[' --senscov ' covdir subjs '_erm_1-1-144fil-cov.fif  --inv '  subjs '_' para '1_144fil_proj-inv.fif  '  ' >& '   subjs '_' para '1_144fil_proj-inv.info  '];



command=['mne_do_inverse_operator --meg --fixed  --megreg 0.1 --fwd ' forward_fif   proj_tag covpt1_25_tag ' >&  ' subjs '_' para '_.1_25filinvop.log']; 
fprintf(1,'\n Command executed: %s \n',command);
[st,~] = unix(command)

if st ~=0
    error('ERROR : check Inverse step .1-25 fil')
end

command=['mne_do_inverse_operator --meg --fixed  --megreg 0.1 --fwd ' forward_fif   proj_tag cov25_tag ' >&  ' subjs '_' para '_1_25filinvop.log']; 
fprintf(1,'\n Command executed: %s \n',command);
[st,~] = unix(command)

if st ~=0
    error('ERROR : check Inverse step 25 fil')
end



command=['mne_do_inverse_operator --meg --fixed  --megreg 0.1 --fwd ' forward_fif   proj_tag cov20_tag ' >&  ' subjs '_' para '_1_20filinvop.log']; 
fprintf(1,'\n Command executed: %s \n',command);
[st,~] = unix(command)

if st ~=0
    error('ERROR : check Inverse step 20 fil')
end


command=['mne_do_inverse_operator --meg --fixed  --megreg 0.1 --fwd ' forward_fif   proj_tag cov40_tag ' >&  ' subjs '_' para '_1_40filinvop.log'];
fprintf(1,'\n Command executed: %s \n',command);
[st,~] = unix(command)

if st ~=0
    error('ERROR : Check Inverse Solution Calculation for 40 fil')
end

command=['mne_do_inverse_operator --meg --fixed  --megreg 0.1 --fwd ' forward_fif  cov144_tag ' >&  ' subjs '_' para '_1_144filinvop.log'];
fprintf(1,'\n Command executed: %s \n',command);
[st,~] = unix(command)

if st ~=0
    error('ERROR : Check Inverse Solution Calculation for 144 fil')
end

diary off




