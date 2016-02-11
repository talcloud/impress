 subject={  'AC013'; '018301';
     '010401';
     '010001';

'017801';




'041901';
'042201';
'042301';
'015402';
'015601';
'051901';
'009101';








'007501';
'013001';
'038301';
'038502';
'040701';
'042401';

'051301';


'AC003';




'AC023';

'AC046';
'AC047';


'AC053';
'AC058';
'AC061';



'AC067';


'AC054';

'AC064';

'AC068';


'AC070';
'AC072';
'AC073';
'AC075';

'AC0066';


'AC076';
'AC077';'AC042';'AC069';'014002';'014901';'012301';'014001';'AC050';'AC063';'AC065'};
counter=1;
visitNo=[ones(39,1);2;2;2;2;2;2;2]; 
   newImageSize = [256,256]; %# or anything else that is even


for i=1:length(subject)
    
   try
   path=['/autofs/cluster/transcend/MEG/tacr_new/',subject{i},'/',num2str(visitNo(i))];
   cd(path);

   
   file=[subject{i},'_tacr_1_eog.png'];
   [X, map] = imread(file);
   [Y, newmap] = imresize(X,newImageSize);

    
   
     imshow(Y);
      hold on;text(100,100,subject{i});hold off
     eval([ 'M' num2str(i) ' = Y;' ]);

     
        close() 
        
    
   catch
       
    fprintf('Subject Failed ! %s\n',subject{i});
    failed_subjects{counter,1}= subject{i}; 
   continue
   
   end
  
end   

 
 %% EOG
%  
%  cd('/autofs/space/amiga_001/users/meg/tacrvib');
% collImg=[M1,M3,M4;M5,M6,M7];
% imshow(collImg)
% eog_figfile=strcat('eog1_new_collage','.png');
% print( gcf, '-dpng', eog_figfile )
% collImg=[M8,M11,M12;M13,M14,M15];
% imshow(collImg)
% eog_figfile=strcat('eog2_new_collage','.png');
% print( gcf, '-dpng', eog_figfile )
% collImg=[M16,M17,M18;M19,M20,M21];
% imshow(collImg)
% eog_figfile=strcat('eog3_new_collage','.png');
% print( gcf, '-dpng', eog_figfile )
% collImg=[M22,M23,M24;M25,M26,M27];
% imshow(collImg)
% eog_figfile=strcat('eog4_new_collage','.png');
% print( gcf, '-dpng', eog_figfile )
% collImg=[M28,M30,M31;M32,M33,M34];
% imshow(collImg)
% eog_figfile=strcat('eog5_new_collage','.png');
% print( gcf, '-dpng', eog_figfile )
% collImg=[M36,M39,M40;M41,M43,M44];
% imshow(collImg)
% eog_figfile=strcat('eog6_new_collage','.png');
% print( gcf, '-dpng', eog_figfile )
% collImg=[M46];
% imshow(collImg)
% eog_figfile=strcat('eog7_new_collage','.png');
% print( gcf, '-dpng', eog_figfile )
%  

 %% EOG Tacr
 
 cd('/autofs/cluster/transcend/MEG/tacr_new');
collImg=[M1,M3,M4;M5,M6,M7];
imshow(collImg)
eog_figfile=strcat('eog1_new_collage','.png');
print( gcf, '-dpng', eog_figfile )
collImg=[M8,M11,M12;M13,M14,M15];
imshow(collImg)
eog_figfile=strcat('eog2_new_collage','.png');
print( gcf, '-dpng', eog_figfile )
collImg=[M16,M17,M18;M19,M20,M21];
imshow(collImg)
eog_figfile=strcat('eog3_new_collage','.png');
print( gcf, '-dpng', eog_figfile )
collImg=[M22,M23,M24;M25,M26,M27];
imshow(collImg)
eog_figfile=strcat('eog4_new_collage','.png');
print( gcf, '-dpng', eog_figfile )
collImg=[M28,M30,M31;M32,M33,M34];
imshow(collImg)
eog_figfile=strcat('eog5_new_collage','.png');
print( gcf, '-dpng', eog_figfile )
collImg=[M36,M39,M40;M41,M43,M44];
imshow(collImg)
eog_figfile=strcat('eog6_new_collage','.png');
print( gcf, '-dpng', eog_figfile )
collImg=[M45,M46];
imshow(collImg)
eog_figfile=strcat('eog7_new_collage','.png');
print( gcf, '-dpng', eog_figfile )
 

%% ECG
% collImg=[M1,M3,M4;M5,M6,M7];
% imshow(collImg)
% eog_figfile=strcat('ecg1_new_collage','.png'); 
% print( gcf, '-dpng', eog_figfile )
% collImg=[M8,M11,M12;M13,M14,M15];
% imshow(collImg)
% eog_figfile=strcat('ecg2_new_collage','.png'); 
% print( gcf, '-dpng', eog_figfile )
% collImg=[M16,M17,M18;M19,M20,M21];
% imshow(collImg)
% eog_figfile=strcat('ecg3_new_collage','.png'); 
% print( gcf, '-dpng', eog_figfile )
% collImg=[M23,M24,M25;M26,M27,M28];
% imshow(collImg)
% eog_figfile=strcat('ecg4_new_collage','.png'); 
% print( gcf, '-dpng', eog_figfile )
% collImg=[M30,M31,M32;M33,M34,M36];
% imshow(collImg)
% eog_figfile=strcat('ecg5_new_collage','.png'); 
% print( gcf, '-dpng', eog_figfile )
% collImg=[M39,M40,M41;M43,M44,M46];
% imshow(collImg)
% eog_figfile=strcat('ecg6_new_collage','.png'); 
% print( gcf, '-dpng', eog_figfile )
% 
% collImg=[M46];
% imshow(collImg)
% eog_figfile=strcat('eog7_new_collage','.png'); 
% print( gcf, '-dpng', eog_figfile )
