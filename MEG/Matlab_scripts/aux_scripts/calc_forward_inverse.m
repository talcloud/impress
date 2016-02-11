function calc_forward_inverse(subjs,para,nRuns,visitNo,ifForward,only20)
% Create Forward and inverse solution for the paradigm
%
% USAGE:
%    calc_forward_inverse(subjs,visitNo)
%
% INPUTS:
%   subjs -   Subject Name   (string)
%   para  -   Protocol Name  (string)
%   nRuns -   Number of runs (as integer)
%   visitNo - Visit number   (as integer)
% OUTPUTS:
%   Save the forward and inverse operator in the subject directory
%
%--------------------------------------
% Sheraz Khan,  P.Eng, Ph.D.
% Engr. Nandita Shetty,  MS.
% Engr. Santosh Ganesan, MS.
%
% Creation date::  October 15, 2010
%--------------------------------------
nRuns=num2str(nRuns);
visitNo=num2str(visitNo);

rootdir=('/autofs/space/amiga_001/users/meg');
subjdir=[rootdir '/' para '/' subjs '/' visitNo '/'];
cd(subjdir) % cd to the fif dir



covdir=['/autofs/space/amiga_001/users/meg/erm1/' subjs '/' visitNo '/'];
mri_tag=[' --mri ' covdir subjs '_1-trans.fif  '];



in_fif = strcat(subjs,'_',para,'_',num2str(1),'_raw.fif ');
in_fif =[subjdir in_fif];
forward_fif = strcat(subjs,'_',para,'-fwd.fif ');
forward_fif =[subjdir forward_fif];


if ifForward % want forward or not

command=['mne_do_forward_solution --meas '  in_fif ' --megonly --overwrite --spacing ico-5   ' mri_tag  '  --subject  ' subjs  ' --fwd  ' forward_fif ];


[st,w] = unix(command);
return 

if st ~=0
    w
    error('ERROR : check Forward step')
end
end% ifforward

if str2double(nRuns)==1
 
    proj_tag=[' --proj ' subjs  '_' para '_1_sss_proj.fif '];
    
elseif str2double(nRuns)==2
    
    proj_tag=[' --proj ' subjs  '_' para '_1_sss_proj.fif  --proj '   subjs  '_' para '_2_sss_proj.fif ']; 
        
elseif str2double(nRuns)==3

    proj_tag=[' --proj ' subjs  '_' para '_1_sss_proj.fif  --proj '   subjs  '_' para '_2_sss_proj.fif  --proj '   subjs  '_' para '_3_sss_proj.fif ']; 
     
else
            
    error('ERROR : This script does not support analysis of 3 or more runs')
            
end
        

%% covriance tags
cov20_tag = [' --senscov ' covdir subjs '_erm_1-20fil-cov.fif  --inv '  subjs '_' para '_20fil_proj-inv.fif  ' ];
cov40_tag = [' --senscov ' covdir subjs '_erm_1-40fil-cov.fif  --inv '  subjs '_' para '_40fil_proj-inv.fif  ' ];
cov144_tag =[' --senscov ' covdir subjs '_erm_1-144fil-cov.fif  --inv '  subjs '_' para '_144fil_proj-inv.fif  ' ];



mne_do_inverse_operator --meg --depth --loose 0.3  --megreg 0.05 --senscov ${covdir}/${subj}_erm_1-40fil-cov.fif  --fwd ${subj}_${task}-fwd.fif --inv ${subj}_${task}-depth3-40fil-inv.fif 

command=['mne_do_inverse_operator --meg --depth --loose 0.3  --megreg 0.05 --fwd ' forward_fif   proj_tag cov20_tag]; 
[st,w] = unix(command);

if st ~=0
    w
    error('ERROR : check Inverse step 20 fil')
end

if ~only20 %only wanted 20
    
command=['mne_do_inverse_operator --meg --fixed  --megreg 0.1 --fwd ' forward_fif   proj_tag cov40_tag];
[st,w] = unix(command);

if st ~=0
    w
    error('ERROR : check Inverse step 40 fil')
end

command=['mne_do_inverse_operator --meg --fixed  --megreg 0.1 --fwd ' forward_fif   proj_tag cov144_tag];
[st,w] = unix(command);

if st ~=0
    w
    error('ERROR : check Inverse step 144 fil')
end



end





