



fmm_sub_folders_0=dir('/autofs/space/calvin_001/users/meg/fmm/0*');

for iO=1:length(fmm_sub_folders_0)
    
try
display(strcat('Runing Subject: ', fmm_sub_folders_0(iO).name))
logfile=strcat('/autofs/space/calvin_001/users/meg/fmm/',fmm_sub_folders_0(iO).name,'/sss_onfif_SK.info');
[Center Decimation]=parse_mne_sss_log(logfile)

catch
    display(strcat('Following subject fails: ', fmm_sub_folders_0(iO).name))
   
    continue
end


end