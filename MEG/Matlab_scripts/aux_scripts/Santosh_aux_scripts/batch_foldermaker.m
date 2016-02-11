


erm_folders=dir('/space/sondre/2/users/meg/erm/*');


for i=1:length(erm_folders)
    
    
   % [s] = mkdir('/autofs/space/calvin_001/users/meg/erm/', erm_folders(i).name)
    

        
%         [s] = mkdir(strcat('/autofs/space/calvin_001/users/meg/erm/', erm_folders(i).name,'/'),'3')
%         [s] = mkdir(strcat('/autofs/space/calvin_001/users/meg/erm/', erm_folders(i).name,'/'),'4')
        
        
        D = dir(strcat('/space/sondre/2/users/meg/erm/', erm_folders(i).name,'/'));
        
        for j=1:length(D)
            
            if D(j).isdir
                
            if strcmp(D(j).name,'1')
                copyfile(strcat('/space/sondre/2/users/meg/erm/', erm_folders(i).name,'/','1'),strcat('/autofs/space/calvin_001/users/meg/erm/', erm_folders(i).name,'/','1'),'f') 
            end
            
            if strcmp(D(j).name,'2')
                copyfile(strcat('/space/sondre/2/users/meg/erm/', erm_folders(i).name,'/','2'),strcat('/autofs/space/calvin_001/users/meg/erm/', erm_folders(i).name,'/','2'),'f') 
            end
            
            if strcmp(D(j).name,'3')
                copyfile(strcat('/space/sondre/2/users/meg/erm/', erm_folders(i).name,'/','3'),strcat('/autofs/space/calvin_001/users/meg/erm/', erm_folders(i).name,'/','3'),'f') 
            end
            
            
            end

            
        
        end
    
    
    
    
    
end