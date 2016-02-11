




fmm_sub_folders_0=dir('/autofs/space/amiga_001/users/meg/fix/AC*');

for iO=1:length(fmm_sub_folders_0)
diary(strcat('/autofs/space/amiga_001/users/meg/fix/',fmm_sub_folders_0(iO).name,'/batch_data.log'));
    
try
    
display(strcat('Running Subject: ', fmm_sub_folders_0(iO).name))
logfile=strcat('/autofs/space/amiga_001/users/meg/fix/',fmm_sub_folders_0(iO).name,'/sss_onfif_SK.info');
% logfile1=strcat('/autofs/space/amiga_001/users/meg/fix/',fmm_sub_folders_0(iO).name,'/',fmm_sub_folders_0(iO).name,'_fmm_40fil-ave.log');
[Center Decimation Bad_channels Movement]=parse_mne_sss_log_sss_onfif_SK(logfile)
[Standard Deviant]=parse_mne_log_fmm_40fil_ave(logfile1)

catch
    display(strcat('Following subject fails: ', fmm_sub_folders_0(iO).name))
   
    continue
end




end
diary off


fmm_sub_folders_0=dir('/autofs/space/amiga_001/users/meg/fix/0*');

for iO=1:length(fmm_sub_folders_0)
diary(strcat('/autofs/space/amiga_001/users/meg/fix/',fmm_sub_folders_0(iO).name,'/batch_data.log'));
    
try
    
display(strcat('Running Subject: ', fmm_sub_folders_0(iO).name))
logfile=strcat('/autofs/space/amiga_001/users/meg/fix/',fmm_sub_folders_0(iO).name,'/sss_onfif_SK.info');
% logfile1=strcat('/autofs/space/calvin_002/users/meg/fmm/',fmm_sub_folders_0(iO).name,'/',fmm_sub_folders_0(iO).name,'_fmm_40fil-ave.log');
[Center Decimation Bad_channels Movement]=parse_mne_sss_log_sss_onfif_SK(logfile)
[Standard Deviant]=parse_mne_log_fmm_40fil_ave(logfile1)

catch
    display(strcat('Following subject fails: ', fmm_sub_folders_0(iO).name))
   
    continue
end




end
diary off
