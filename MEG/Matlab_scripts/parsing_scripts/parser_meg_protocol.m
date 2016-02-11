
function infoCell=parser_meg_protocol(para,que)


directoryName=strcat('/space/sondre/2/users/meg/',para,'/');
quename=strcat(directoryName,que,'*');



sub_folders=dir(quename);

infoCell=cell(1);

for i=1:length(sub_folders)
    
            mneString=[' mne_show_fiff  --in   '  directoryName   sub_folders(i).name '/'  sub_folders(i).name  '_' para '_1_raw.fif  --tag 204 --verbose '];
            [~, w]=system(mneString);
            date=deblank(w(end-24:end));
            
            infoCell{i,1}=deblank(sub_folders(i).name);
            infoCell{i,2}=deblank(date);

    
    
    
    
    
    
    
    
end