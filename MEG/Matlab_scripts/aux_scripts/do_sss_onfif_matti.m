function do_sss_onfif_matti(subj,para,nrun)


%% Global Variables

s=subj;
p=para;
rootdir=('/cluster/fusion/msh/MMSC11/MEG');


% number of runs
switch nrun
    case 1
        run = 1;

    case 2
        run = [1,2];
    case 3
        run = [1,2,3]; % emo1 paradigm usually has 3 runs
    case 4
        run = [1,2,3,4]; % emo1 paradigm usually has 3 runs

    otherwise
        display('ERROR : This script does not support analysis of 4 or more runs');
        return;
end


% generates mne_proces_raw tags for ave/gave calculations

sss_trans_tag = [' -trans ' s '_' p '_1_raw.fif']; % transforms head position in accordance to run 1

subjdir=[rootdir '/' p '/' ];

cd(subjdir); % cd to the fif dir







%% SSS Only
for n = 1:numel(run)
    in_fif = strcat(s,'_',p,'_',num2str(run(n)),'_raw.fif');

    [c hpifit]=system(['/usr/pubsw/packages/mne/nightly/bin/mne_show_fiff --in ' in_fif ' --tag 242 --verbose']); % extract info on goodness of hpi fit
    
    if str2num(hpifit(27))==1 %#ok<ST2NM> % check if hpi fit is good or not
        computecenterflag = 1;
        if(~computecenterflag)
            frame_tag =' -frame head -origin 0 0 40 '; % if hpi fit is good, use a head frame co-ordinate system
        else
            [ctr, radius, hs] = computecenterofsphere(in_fif); %#ok<NASGU>
            ctr = num2str(round(ctr*1000)'); % 1000 for going from m to mm
            frame_tag = [' -frame head -origin ' ctr ' '];
        end
        movecomp_tag=' ';
        if n==1
            sss_trans_tag = '';
        end

    else
        frame_tag = ' -frame device -origin 0 13 -6 '; % if hpi fit is not good, use a device frame co-ordinate system
        movecomp_tag='' ;
    end

    % MAXFILTER Step 1 - identifying bad channels

   
%     command=['/space/orsay/8/megdev/megsw-neuromag/bin/util/maxfilter -f  '  s '_' p '_' num2str(run(n)) '_raw.fif'...
%         ' -o  '  s '_' p '_' num2str(run(n)) '_badch.fif ' frame_tag  '-autobad  -force -v >& step1-badch.log' ];
%     fprintf(1,'%s',command);
%     [st,wt]=system(command);
%     if st ~=0
%         error(strcat('ERROR : check maxfilter step 1:',wt));
%     end
% 
%     badchlog=['badch_run' num2str(run(n)) '.log']; % generate bad channel file for each run
% 
% 
%     ! cat step1-badch.log | sed -n  '/Static bad channels/p' | cut -f 5- -d ' '   | uniq | tee  badch.txt
% 
%     [badch]=textread('badch.txt');
%     badch=num2str(badch,'%04.0f ');
% 
%     copyfile('badch.txt', badchlog);

    % MAXFILTER Step 2-a - i/p file : <subj>_<paradigm>_<run>_raw.fif ; o/p file : <subj>_<paradigm>_<run>_raw1.fif

    
    % Removed: -st 16 -corr 0.96 from the command... Add if doing tSSS
    command=['/space/orsay/8/megdev/megsw-neuromag/bin/util/maxfilter -f  '  s '_' p '_' num2str(run(n)) '_raw.fif'...
        ' -o  '  s '_' p '_' num2str(run(n)) '_sss1.fif ' ' -autobad   -hp ' s '_' p '_' num2str(run(n)) 'hp.log'...
        ' -format short -force -hpisubt amp -format short -force  '   frame_tag movecomp_tag ' -v >& ' s '_' p '_' num2str(run(n)) '_sss1.log'];

    [st,wt] = system(command);

    if st ~=0
        error(strcat('ERROR : check maxfilter step 2:',wt));
    end

    % MAXFILTER Step 3 - i/p file : <subj>_<paradigm>_<run>_sss1.fif ; o/p file : <subj>_<paradigm>_<run>_sss.fif

    if n > 1 % only when more than one run -> transform everything to Run 1
        command=['/space/orsay/8/megdev/megsw-neuromag/bin/util/maxfilter -f ' s '_' p '_' num2str(run(n)) '_sss1.fif'...
            ' -o ' s '_' p '_' num2str(run(n)) '_sss.fif' ' -autobad    '  sss_trans_tag  frame_tag  ' -format short -force -v >& ' s '_' p '_' num2str(run(n)) '_sss2.log' ];

        [st,wt] = system(command);

        if st ~=0
            error(strcat('ERROR : check maxfilter step 3:',wt));
        end
    else
        movefile( [s '_' p '_' num2str(run(n)) '_sss1.fif'],[s '_' p '_' num2str(run(n)) '_sss.fif']);
    end

%     [info] = fiff_read_meas_info([s '_' p '_' num2str(run(n)) '_sss.fif']);
% 
%     dfactor = num2str(round(info.sfreq/600));
%     ds_tag = [' --decim ' dfactor ' '];
%     
% 
% 
%     % Have to filter in the decimation step, else MNE
%     % filters it between 0.1 and 40 Hz
% 
%     command = ['/usr/pubsw/packages/mne/nightly/bin/mne_process_raw --raw ' s '_' p '_' num2str(run(n)) '_sss.fif'  ds_tag ' --lowpass 98  --projoff  --save ' s '_' p '_' num2str(run(n)) '_sss.fif' ' >& ' s '_' p '_decim.log'];
%     % Removed Highpass on June 28, 2010
%     
%     [st,wt] = system(command);
% 
%     if st ~=0
%         error(strcat('ERROR : error in downsampling:',wt));
%     end
%     movefile( [s '_' p '_' num2str(run(n)) '_sss_raw.fif'],[s '_' p '_' num2str(run(n)) '_sss.fif'],'f');

    % Works on bash
    ! chgrp acqtal *
    ! chmod 775 *


end 



