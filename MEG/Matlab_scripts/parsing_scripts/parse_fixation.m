function infoCell=parse_fixation(logfile,protocol)
% Reads logfile created by MNE during sss step 2 and find out
% lists the subject name and date, for the specified protocol
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
% Santosh Ganesan, November 4th, 2010
%--------------------------------------

% ls /space/megraid/*/MEG/tal/*/* > & megfiles.info

%fprintf(1,'Parsing logfile: %s \n',logfile);

% Reading log file 
%  system(['ls /space/megraid/*/MEG/tal/*/* > & megfiles_tal.info'])
% system(['ls /space/megraid/*/MEG/kenet/*/* > & megfiles_kenet.info'])


fid = fopen(logfile,'r');
counter=0;
infoCell=cell(1);



while(1)
% Reading each line    
    dline = fgetl(fid);
    if(dline == -1)
        break;
    end
% Comparing it with skipped tag
    
    I = strmatch('/space/megraid/', dline);
    
    if ~isempty(I)
    counter=counter+1;
    
    pathName=dline(1:end-1); 
    dline = fgetl(fid);
    ind=regexp(dline,'_');
    
    R = regexp(dline, protocol);
    
    
    
    while~isempty(R);
    
    
        if ~isempty(ind)
        subjectName=dline(1:ind(1)-1);
     
        
        ind=regexp(dline,'.fif');
            if ~isempty(ind)
              
                ind=regexp(dline,' ');    
                if ~isempty(ind)    
                fileName=dline(ind(end)+1:end);
                
                else
                    ind=regexp(dline,'.fif');
                fileName=dline(1:ind(1)+3);
       
                end
            mneString=[' mne_show_fiff  --in    ' pathName   '/'  fileName  '  --tag 204 --verbose '];
            [~, w]=system(mneString);
            date=deblank(w(end-24:end));
            end
            
            infoCell{counter,1}=subjectName;
            infoCell{counter,2}=fileName;
            infoCell{counter,3}=date;
            
        end
        
        dline = fgetl(fid);
        ind=regexp(dline,protocol);
        if ~isempty(ind)
            R;
            counter=counter+1;
        else
            R=[];
            
        end
         
    end
            
            
            
            
        
            

end
    
    
    

   
    
    


end