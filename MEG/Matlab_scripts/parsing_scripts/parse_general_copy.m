function [infoCell,unique_subjects]=parse_general_copy(logfile,protocol)
% Reads logfile created by MNE during sss step 2 and find out
% lists the subject name and date, for the specified protocol
%
% USAGE:
%    counter= parse_mne_sss_step2_log(logfile)
%
% INPUTS:
%   logfile - The name of the MNE logfile (ascii file, any
%   extension) *_fmm_40fil-ave.log; sss_onfif_SK.info
%   protocol -  amp
%               fix
%               fmm
%               fmmn
%               gabor
%               tacr
%               wmm
%
%
% OUTPUTS:
%               subject name
%               file name
%               date of file creation
%               
%    
%--------------------------------------
% Sheraz Khan, Ph.D. , October 12, 2010
% Santosh Ganesan, November 4th, 2010
%--------------------------------------






% ls /space/megraid/*/MEG/tal/*/* > & megfiles.info
% 
% fprintf(1,'Parsing logfile: %s \n',logfile);
% 
% % Reading log file 
% % system(['ls /space/megraid/*/MEG/tal/*/* > & megfiles_tal.info'])
% system(['ls /space/megraid/*/MEG/kenet/*/* > & megfiles_kenet.info'])


fid = fopen(logfile,'r');
counter=1;
infoCell=cell(1);





while(1)
% Reading each line    
    dline = fgetl(fid);
    if(dline == -1)
        break;
    end
% Comparing it with skipped tag
    
    I = strmatch('/space/megraid/', dline);
    M=dline;
    
    if ~isempty(I)
    pathName=M(1:end-1); 
    dline = fgetl(fid);
    ind=regexp(dline,'_');
    
     
    
    if ~isempty(ind)
    subjectName=dline(1:ind(1)-1);
    newsubjectName=subjectName;
    display(strcat('Processing Subject: ', subjectName))
    
        while(subjectName==newsubjectName);
        ind=regexp(dline,'.fif');
        R = regexp(dline,protocol);
                if ~isempty(ind)
                if ~isempty(R)
              
                ind=regexp(dline,' ');    
                if ~isempty(ind)    
                fileName=dline(ind(end)+1:end);
                
                else
                ind=regexp(dline,'.fif');
                fileName=dline(1:ind(1)+3);
       
                end
            pathName=M(1:end-1);
           mneString=[' mne_show_fiff  --in    ' pathName   '/'  fileName  '  --tag 204 --verbose '];
             [~, w]=system(mneString);

             date=M(end-6:end-1);
%            mneString=[' mne_show_fiff  --in    ' '/autofs/space/amiga_001/users/meg/tacr_new/',subjectName,'/',fileName  '  --tag 204 --verbose '];
             [~, w]=system(mneString);
              if (isempty(w)),
                  date=0;
              else
              date=deblank(w(end-24:end));
              end
            infoCell{counter,1}=subjectName;
            infoCell{counter,2}=fileName;
%             source = strcat(pathName ,'/',fileName);
% %                source = strcat(pathName ,'/',subjectName,'_erm_1_raw.fif');
%             destination=strcat('/autofs/space/amiga_001/users/meg/tacrvib', '/',subjectName);
%             try
%             [status,message,messageid] = copyfile(source,destination);
%             catch
%             fprintf('Error copy %s\n',subjectName)
%             continue
%             end
             infoCell{counter,3}=date;
             counter=counter+1;
            
%          [s1,mess,messid] =  mkdir('/autofs/space/amiga_001/users/meg/erm',subjectName);
%   if (isempty(messid)),
%               destination=strcat('/autofs/space/amiga_001/users/meg/erm/',subjectName);
% %             source=strcat(pathName,'/','*','_fix_1_raw.fif');
%           source2=strcat(pathName,'/','*','_erm_*.fif');
% %             [status,message]=copyfile(source,destination);
%              [status2,message2]=copyfile(source2,destination);
%   end          
                end
            end
            
            
        dline = fgetl(fid);
    if(dline == -1)
        break;
    end
        ind=regexp(dline,'_');

        a=('n');
      
        if isempty(ind)
            I=[];
            ind=[];
            newsubjectName=strcat(a,subjectName(1:end-1));

            
        else
            newsubjectName=subjectName;
           
        end


            end  
        
    
    end 
    
    I = strmatch('/space/megraid/', dline);   
    M=dline;
end 


    
end %while(1)
% 
% 
unique_subjects{1,1}=infoCell{1,1};
unique_subjects{1,2}=infoCell{1,2};
unique_subjects{1,3}=infoCell{1,3};
temp=1;
for i=2:length(infoCell),
    r=strcmp(infoCell{i,1},unique_subjects{temp,1});
    if(r==0),
        temp=temp+1;
        unique_subjects{temp,1}=infoCell{i,1};
         unique_subjects{temp,2}=infoCell{i,2};
         unique_subjects{temp,3}=infoCell{i,3};
    else
        unique_subjects{temp,1}=unique_subjects{temp,1};

    end
end