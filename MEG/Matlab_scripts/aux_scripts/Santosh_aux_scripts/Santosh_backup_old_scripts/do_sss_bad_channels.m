function [cfg]= do_sss_bad_channels(subj,visitNo,run,cfg)
%% Error Check
if isfield(cfg,'current')
    I=strmatch(cfg.current,'do_sss_bad_channels');
           if isempty(I)
               return
           else
               cfg=rmfield(cfg, 'current');
           end    
end


%% Global Variables

if ~isfield(cfg,'data_rootdir'),
 error('Please enter a root directory in sub-structure cfg.data_rootdir: Thank you');
end

if ~isfield(cfg,'protocol'),
 error('Please enter a protocol name in sub-structure cfg.protocol: Thank you');
end

if ~isfield(cfg,'frame_tag'),
 error('Please check hpifit/error in sub-structure cfg.frame_tag: Thank you');
end

data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
cd(data_subjdir) % cd to the fif dir

diary(strcat(subj,'_sss_bad_channels.info'));
diary on
%% Bad Channels

if ~isfield(cfg,'start_run_from')
cfg.start_run_from=1;
end

for irun = cfg.start_run_from:run
    try
    fprintf('\n Maxfilter Step 1: IDENTIFYING BAD CHANNELS %d\n',irun)
    command=['/space/orsay/8/megdev/megsw-neuromag/bin/util/maxfilter -f  '  subj '_' cfg.protocol '_' num2str(irun) '_raw.fif'...
        ' -o  '  subj '_' cfg.protocol '_' num2str(irun) '_badch.fif ' cfg.frame_tag{irun}  '-autobad 20 -skip 21 999999 -force -v >& step1-badch.log' ];
    fprintf(1,'\n Command executed: %s \n',command);
    [st,wt]=system(command)
    if st ~=0
        error(strcat('ERROR : check maxfilter step 1:',wt));
    end

    badchlog=[subj '_' cfg.protocol '_badch_run' num2str(irun) '.log']; % generate bad channel file for each run


    ! cat step1-badch.log | sed -n  '/Static bad channels/p' | cut -f 5- -d ' '   | uniq | tee  badch.txt

    [badch]=textread('badch.txt');
    cfg.badch{irun}=num2str(badch,'%04.0f ');
    fprintf(1,'\n Bad channels for this run are: %s \n',cfg.badch{irun})

    copyfile('badch.txt', badchlog);
    catch
              fprintf(1,'\n Failed run %d \n',irun);
  
    continue
    end
    
end
    fprintf('\n Changing permissions of files created by this script \n')
    ! /usr/pubsw/bin/setgrp acqtal *
    ! chmod 775 
diary off

        filename=strcat(subj,'_do_sss_bad_channels_cfg');
        save(filename,'cfg','visitNo','run','subj');