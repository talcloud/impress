function calc_sensitivity_maps_Santosh(subjs,visitNo,ifForward)
% Create sensitivity maps for the paradigm
%
% USAGE:
%    calc_sensitivity_maps(subjs,visitNo)
%
% INPUTS:
%   subjs -   Subject Name   (string)
%   visitNo - Visit number   (as integer)
% OUTPUTS:
%   Save the sensitivity map in subject dir
%
%--------------------------------------
% Sheraz Khan,  P.Eng, Ph.D.
% Creation date::  Jan 29, 2011
%--------------------------------------

visitNo=num2str(visitNo);
para='emo1';
rootdir=('/autofs/space/calvin_002/users/meg');
subjdir=[rootdir '/' para '/' subjs '/'];
% subjdir=[rootdir '/' para '/' subjs '/' visitNo '/'];
cd(subjdir) % cd to the fif dir



covdir=['/autofs/space/amiga_001/users/meg/erm1/' subjs '/' visitNo '/'];
mri_tag=[' --mri ' covdir subjs '_1-trans.fif  '];



in_fif = strcat(subjs,'_',para,'_',num2str(1),'_raw.fif ');
in_fif =[subjdir in_fif];
forward_fif = strcat(subjs,'_',para,'-fwd.fif ');
forward_fif =[subjdir forward_fif];


if ifForward

command=['mne_do_forward_solution --meas '  in_fif ' --megonly --overwrite --spacing ico-5   ' mri_tag  '  --subject  ' subjs  ' --fwd  ' forward_fif ];


[st,w] = unix(command);


%if st ~=0
%    error('ERROR : check Forward step')
%end


end

% proj_tag=[' --proj ' subjs  '_' para '_1_eog_proj.fif ' ]; 
     
proj_tag=[' --proj ' subjs  '_' para '_1_sss_proj.fif  --proj '   subjs  '_' para '_2_sss_proj.fif  --proj '   subjs  '_' para '_3_sss_proj.fif ']; 
        

stem=[subjs '_sensitivity_maps'];

command=['mne_sensitivity_map  --fwd ' forward_fif   proj_tag   '  --map   5   --smooth  5 '  '  --w  ' stem]; 
[st,w] = unix(command);

if st ~=0
   w
   error('ERROR : check Inverse step 20 fil')
end
