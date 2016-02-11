    function [cfg]= do_erm_SSS(subj,visitNo,run,cfg)
    
    % Generates SSS of the data of all subjects for a
    % paradigm. Assumes default subject list. 
    %--------------------------------------
    % Dr Engr. Sheraz Khan,  P.Eng, Ph.D.
    % Engr. Nandita Shetty,  MS.
    %
    % Date::  October, 2010
    
    % Modified By Santosh Ganesan
    % Date:   June 15, 2011
    %--------------------------------------


   
%% Global Variables

if ~isfield(cfg,'rootdir'),
 error('Please enter a root directory in sub-structure cfg.rootdir: Thank you');
end

subjdir=[cfg.rootdir '/' subj '/' num2str(visitNo) '/'];
cd(subjdir) % cd to the fif dir
%% SSS
diary(strcat(subj,'_erm_mne_preproc_SSS_.info'));
diary on



fprintf(1,'\n Beginning pre-processing for SUBJECT: %s \n',subj);
fprintf(1,'\n Analyzing paradigm: %s\n',subj);

     
        for irun=1:run,
        
                cfg.erm_frame_tag = ' -frame device -origin 0 13 -6 '; % if hpi fit is not good, use a device frame co-ordinate system
        
                % if you want tsss -st 16 -corr 0.96
                % MAXFILTER Step 1 - i/p file : <subj>_<paradigm>_<run>_raw.fif ; o/p file : <subj>_<paradigm>_<run>_sss1.fif
                command=['/space/orsay/8/megdev/megsw-neuromag/bin/util/maxfilter -f  ' subj '_' 'erm' '_' num2str(irun) '_raw.fif'...
                ' -o  '  subj '_' 'erm' '_' num2str(irun) '_sss.fif ' ' -autobad on -linefreq 60 '...
                ' -format short  -force ' cfg.erm_frame_tag ' -v >& ' subj '_' 'erm' '_' num2str(irun) '_sss.log'];
                [st,wt] = unix(command);
                fprintf(1,'\n Command executed: %s \n',command);

                    if st ~=0
                     error('ERROR : check maxfilter step')
                    end
        end
    
cfg.sss=1;
%%

diary off
