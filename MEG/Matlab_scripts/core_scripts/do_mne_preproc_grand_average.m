function [cfg]=do_mne_preproc_grand_average(subj,visitNo,run,cfg)

%   Sheraz Khan <sheraz@nmr.mgh.harvard.edu>
%   Santosh Ganesan <santosh@nmr.mgh.harvard.edu>
%   Fahimeh Mamashli
%   Generates AVERAGES & GRAND AVERAGES
% Local variables:
%   1) subj = subject name
%   2) visitNo = visit number
%   3) run = run number
%   4) cfg = data structure with global variables
% OPTIONS:
% 1) cfg.2-20_epoching // if set, automatically epochs data 2-20. This field is passed through filtering, grand average, and epoching modules.
% 2) cfg.mne_preproc_filt:

% PARAMETERS:

% If you want the following files: highpass 1, lowpass 144; highpass 2, lowpass 25; highpass 1, lowpass 40
% cfg.mne_preproc_filt.hpf(1)=1;
% cfg.mne_preproc_filt.lpf(1)=144;
% cfg.mne_preproc_filt.hpf(2)=2;
% cfg.mne_preproc_filt.lpf(2)=25;
% cfg.mne_preproc_filt.hpf(3)=1;
% cfg.mne_preproc_filt.lpf(3)=40;
% cfg.mne_preproc_filt: if field is not set or empty, averaging/grand averaging will occur with the following parameters:
% cfg.mne_preproc_filt.hpf(1)=1;
% cfg.mne_preproc_filt.lpf(1)=144;
% cfg.mne_preproc_filt.hpf(2)=2;
% cfg.mne_preproc_filt.lpf(2)=20;


% 3) cfg.removeECG_EOG // if set (cfg.removeECG_EOG=1), indicates removing heartbeat only, cfg.removeECG_EOG=2 indicates removing heartbeat and blinks, default: cfg.removeECG_EOG=2
% 4) cfg.epochMEG_merge_events // if set,(cfg.epochMEG_merge_events), events will be merged

% PARAMETERS:

% 1) cfg.epochMEG_event_order // must set order of original events in ave file
% For merging events, 1 & 4, 2 & 5
% EXAMPLE: cfg.epochMEG_event_order{1}=[1,4];
% cfg.epochMEG_event_order{2}=[2,5];
% 2) cfg.newevents // must set order of new events in ave file

% EXAMPLE: cfg.newevents(1)=[90]
% cfg.newevents(2)=[91]
% 3) cfg.offset // if set,(cfg.offset=value), offset is enabled in reading events, default, offset=0

% 4) cfg.grand_avg_manual_filename // if set,can manually set naming convention of grand average
% EXAMPLE: cfg.grand_avg_manual_filename='event_unique';



%% Error Check
if isfield(cfg,'error_mode')
    
    file= exist(strcat(subj,'_do_mne_preproc_grand_average_error_cfg.mat'),'file');
    if file~=2
        return
    else
        delete(file);
    end
end

%% Need 2 or more runs
% if run<2,
%      fprintf('cannot perform grand average! there is only 1 run');
%
%     return
% end

%% Global Variables
if ~isfield(cfg,'data_rootdir'),
    error('Please enter a root directory in sub-structure cfg.data_rootdir: Thank you');
end

if ~isfield(cfg,'protocol'),
    error('Please enter a protocol name in sub-structure cfg.protocol: Thank you');
end

if ~isfield(cfg,'start_run_from')
    cfg.start_run_from=1;
end

if ~isfield(cfg,'removeECG_EOG'),  % IF FIELD IS NOT SET, DEFAULT IS EOG & ECG CLEAN BOTH PERFORMED
    for irun=cfg.start_run_from:run,
        cfg.removeECG_EOG(irun)=2;
    end
    fprintf('\n Remove ECG_EOG is not set %s\n',subj);
    fprintf('\n Default will be used/ Removal of ECG & EOG! %s\n',subj);
    fprintf('\n ECG_EOG=2! %s\n',subj);
end
if ~isfield(cfg,'protocol_avedir')
    error('Please enter a covariance directory in sub-structure cfg.protocol_avedir: Thank you');
end

if ~isfield(cfg,'protocol_avename')
    error('Please enter a cfg.protocol_avename: Thank you');
end

if ~isfield(cfg,'mne_preproc_filt')
    cfg.mne_preproc_filt=[];
end


data_subjdir=[cfg.data_rootdir,'/',subj,'/',num2str(visitNo), '/'];
cd(data_subjdir) % cd to the fif dir
%% MNE Preproc Grand Average

diary(strcat(subj,'_mne_preproc_grand_average',datestr(clock),'.info')); % Starting Diary
diary on



cfg.mne_preproc_grand_average=cfg.mne_preproc_filt;


if isempty(cfg.mne_preproc_grand_average) % IF FIELD EMPTY, DEFAULT PREPROCESSING SETTINGS ARE
    
    % SETS DEFAULT DATA FILTERING WITH FOLLOWING SETTINGS
    % 1-144  HZ
    % 2-20   HZ
    cfg.mne_preproc_grand_average.hpf(1)=1;
    cfg.mne_preproc_grand_average.lpf(1)=144;
    fprintf(' highpass    %d to lowpass %d\n',  cfg.mne_preproc_grand_average.hpf(1), cfg.mne_preproc_grand_average.lpf(1));
    
    cfg.mne_preproc_grand_average.hpf(2)=2;
    cfg.mne_preproc_grand_average.lpf(2)=20;
    
    fprintf(' highpass    %d to lowpass %d\n',  cfg.mne_preproc_grand_average.hpf(2), cfg.mne_preproc_grand_average.lpf(2));
    
else
    
    if isfield(cfg,'2-20_epoching')       % SET FIELD IF YOU WANT TO EPOCH ALL FILES WITH 2-20 HZ SETTINGS
        cfg.mne_preproc_grand_average.hpf(length(cfg.mne_preproc_grand_average.hpf)+1)=2;
        cfg.mne_preproc_grand_average.lpf(length(cfg.mne_preproc_grand_average.lpf)+1)=20;
    end
    
end



if (length( cfg.mne_preproc_grand_average.lpf)~=length(cfg.mne_preproc_grand_average.hpf))
    
    error(' There is something funky with the low pass and high pass settings you have entered, Please recheck');
else
    fprintf('Starting to Grand Average %s\n',subj);
end
cfg.preproc_filtered_file_tag=cell(1,run);
for irun=cfg.start_run_from:run,
    if (cfg.removeECG_EOG(irun)==1),
        cfg.preproc_filtered_file_tag{irun}='ecgClean';
    elseif (cfg.removeECG_EOG(irun)==2),
        cfg.preproc_filtered_file_tag{irun}='ecgeogClean';
    else
        cfg.preproc_filtered_file_tag{irun}='sss';
    end
    
end


%% CHECKING TO SEE IF SSS RECORDING DONE WITH NEW MEG ELECTRONICS (10/1/12)
cfg.in_fif{run}= strcat(subj,'_',cfg.protocol,'_',num2str(run),'_raw.fif');

fiff_file_raw=fiff_setup_read_raw(cfg.in_fif{run});
cfg.raw_file_sfreq=fiff_file_raw.info.sfreq;

if round(cfg.raw_file_sfreq)-cfg.raw_file_sfreq==0
    cfg.mne_process_raw_digtrig='  --digtrig STI101 --digtrigmask 0xff ';  % km: added mask for 8 bits
else
    cfg.mne_process_raw_digtrig='  --digtrigmask 0xff ';  % km: added mask for 8 bits
    
end

%%

if isfield(cfg,'grandaverageSK')
    grandaveSK_fm(cfg,subj,run)
else
    
    
    if ~isfield(cfg,'not_do_grandavg')
        
        
        for igrand_avg=1:length(cfg.mne_preproc_grand_average.hpf),
            
            fprintf('Now computing grand average highpass  %d to lowpass %d\n',cfg.mne_preproc_grand_average.hpf(igrand_avg),cfg.mne_preproc_grand_average.lpf(igrand_avg))
            
            cfg.mne_preproc_grand_average_file= ['--raw ' [subj '_' ,cfg.protocol, '_1_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'_',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil_raw.fif ']]; % takes as input raw files who's ecg component has been removed i.e <subj>_<paradigm>_<run>_ecgClean_raw.fif
        
            if isfield(cfg,'add_event_trigger')
                temp=regexp(cfg.mne_preproc_grand_average_file,'.fif');
                infiffile=cfg.mne_preproc_grand_average_file(7:temp+3);
                cfg.customeventFileName=add_triggers(infiffile,cfg.add_event_trigger.eventDistance,cfg.add_event_trigger.eventNumber,cfg.add_event_trigger.stemEventFile);
            end
            fprintf('\n Checking file existence for grand average %s\n',[subj '_' ,cfg.protocol, '_1_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'_',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil_raw.fif ']);
            cfg.mne_preproc_file_checker= exist(([subj '_' ,cfg.protocol, '_1_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'_',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil_raw.fif']),'file');
            
            
            if (cfg.mne_preproc_file_checker~=2)
                fprintf(' The filtered file you want to perform a grand average on does not seem to exist, Please recheck');
                fprintf(' The file will be ignored in averaging')
                cfg.mne_preproc_grand_average_file='';
            end
            
            if run>1,
                multiple_grand_avg_file_tag=cell(1,run-1);
                if isfield(cfg,'add_event_trigger')
                    cfg.customeventFileName_mult_runs=cell(1,run-1);
                end
                
                for irun=2:run
                    tempfilename=[subj '_' ,cfg.protocol, '_',num2str(irun),'_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'_',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil_raw.fif'];
                    fprintf('\n Checking file existence for grand average %s\n',tempfilename);
                    cfg.mne_preproc_file_checker= exist(tempfilename,'file');
                    if (cfg.mne_preproc_file_checker~=2)
                        fprintf(' The filtered file you want to perform a grand average on does not seem to exist, Please recheck');
                        fprintf(' The file will be ignored in averaging')
                        multiple_grand_avg_file_tag{irun}='';
                        if isfield(cfg,'add_event_trigger')
                            cfg.customeventFileName_mult_runs{irun}='';
                        end
                    else
                        if isfield(cfg,'add_event_trigger')
                            
                            cfg.customeventFileName_mult_runs{irun}=add_triggers(tempfilename,cfg.add_event_trigger.eventDistance,cfg.add_event_trigger.eventNumber,cfg.add_event_trigger.stemEventFile);
                        end
                        multiple_grand_avg_file_tag{irun}=['--raw ',subj '_' ,cfg.protocol, '_',num2str(irun),'_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'_',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil_raw.fif '];
                        if isfield(cfg,'add_event_trigger')
                            cfg.customeventFileName=[cfg.customeventFileName,' ',multiple_grand_avg_file_tag{1:run}];
                        end
                        
                        
                    end
                end
                cfg.mne_preproc_grand_average_file = [cfg.mne_preproc_grand_average_file,' ',multiple_grand_avg_file_tag{1:run}]; % takes as input raw files who's ecg component has been removed i.e <subj>_<paradigm>_<run>_ecgClean_raw.fif
                
                
                
                
                
                cfg.mne_preproc_grand_average_file= [cfg.mne_preproc_grand_average_file,' ',' --gave ', subj, '_', cfg.protocol,'_',cfg.preproc_filtered_file_tag{irun},'_',num2str(irun),'_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'_',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)) ,'_fil_gave.fif  '];
            end
            % fm: add_event_trigger option exist higher
            if isfield(cfg,'add_specific_event_trigger')
                cfg.eventFile_add_trigger=['  --events  '  cfg.customeventFileName ];
                
            else
                cfg.eventFile_add_trigger= '  ';
                
            end
            
            
            
            %%    MERGING EVENTS
            if isfield(cfg,'epochMEG_merge_events'),
                
                for irun=1:run
                    try
                        eventfile=strcat(cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/', subj ,'_',cfg.protocol,'_',num2str(irun),'_',cfg.preproc_filtered_file_tag{irun},'_raw-eve.fif');
                        B=exist(eventfile,'file');
                        
                        if (B~=2)
                            fprintf(' The event file doesnt exist, skipping the run');
                            
                            continue
                            
                        end
                        if ~isfield(cfg,'offset')
                            cfg.offset=0;
                        end
                        
                        %newfile=mergeEvents(eventfile,cfg.epochMEG_event_order,cfg.newevents,cfg.offset);
                        newfile=mergeEvents(eventfile,cfg.epochMEG_event_order,cfg.newevents);
                        cfg.eventFile_average=[' --events  '  newfile ];
                        cfg.epoch_merge=1;
                        
                        
                        fprintf(1,'\n Computing log file for merged events \n');
                        
                        
                        cfg.merge_ave_input_file{irun}=['--raw  ',subj,'_',cfg.protocol,'_',num2str(irun),'_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'_',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil_raw.fif'];
                        
                        
                        
                        if isfield(cfg,'grand_avg_manual_filename')
                            % MANUALLY SET MERGED EVENTS
                            command=['mne_process_raw ' cfg.merge_ave_input_file{irun} cfg.mne_process_raw_digtrig cfg.eventFile_add_trigger ' --filteroff' ,'  --projon',cfg.eventFile_average,'  --ave ', cfg.protocol_avedir,'/', cfg.protocol_avename '_merg.ave  ','  --saveavetag ','-',cfg.grand_avg_manual_filename,'-ave ', '  ', ' >& ', subj, '_', cfg.protocol, '_',cfg.preproc_filtered_file_tag{irun},'_',num2str(irun),'_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'-',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil-',cfg.grand_avg_manual_filename,'-ave.log' ];
                        else
                            % MERGED EVENTS
                            command=['mne_process_raw ' cfg.merge_ave_input_file{irun} cfg.mne_process_raw_digtrig cfg.eventFile_add_trigger ' --filteroff' ,'  --projon',cfg.eventFile_average,'  --ave ', cfg.protocol_avedir,'/', cfg.protocol_avename '_merg.ave  ','  --saveavetag ','-merge-ave ', '  ', ' >& ', subj, '_', cfg.protocol, '_',cfg.preproc_filtered_file_tag{irun},'_',num2str(irun),'_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'-',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil-merge-ave.log' ];
                        end
                        [st,wt] = unix(command)	;
                    catch
                        continue
                    end
                    
                    
                end
                
                %% NOT MERGED EVENTS
            else
                fprintf(1,'\n Computing grand average and logfile for unmerged events \n');
                
                if isfield(cfg,'grand_avg_manual_filename')
                    
                    command=['mne_process_raw ' cfg.mne_preproc_grand_average_file cfg.mne_process_raw_digtrig cfg.eventFile_add_trigger ' --filteroff' ,'  --projon','  --ave ', cfg.protocol_avedir,'/', cfg.protocol_avename '.ave  ','  --saveavetag ','-',cfg.grand_avg_manual_filename,'-ave ', '  ', ' >& ', subj, '_', cfg.protocol, '_',cfg.preproc_filtered_file_tag{irun},'_',num2str(run),'_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'-',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil-',cfg.grand_avg_manual_filename,'-ave.log'];
                    
                elseif isfield(cfg,'manual_event_file_name')
                    
                    command=['mne_process_raw ' cfg.mne_preproc_grand_average_file cfg.mne_process_raw_digtrig cfg.eventFile_add_trigger ' --filteroff' ,'  --projon','  --ave ', cfg.protocol_avedir,'/', cfg.protocol_avename '.ave  ','  --saveavetag ','-ave ', '  ', '--events ' cfg.manual_event_file_name ' >& ', subj, '_', cfg.protocol, '_',cfg.preproc_filtered_file_tag{irun},'_',num2str(run),'_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'-',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil-ave.log'];
                    
                else
                    
                    command=['mne_process_raw ' cfg.mne_preproc_grand_average_file cfg.mne_process_raw_digtrig  ' --filteroff' ,'  --projon  ','  --ave ', cfg.protocol_avedir,'/', cfg.protocol_avename '.ave  ','  --saveavetag ','-ave ', '  ', ' >& ', subj, '_', cfg.protocol, '_',cfg.preproc_filtered_file_tag{irun},'_',num2str(run),'_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'-',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil-ave.log'];
                    
                end
                try
                    [st,wt] = unix(command)	;
                    fprintf(1,'\n Command executed: %s \n',command);
                    
                    fprintf(1,'\n Grand Average: highpass  %d to lowpass %d\n',cfg.mne_preproc_grand_average.hpf(igrand_avg),cfg.mne_preproc_grand_average.lpf(igrand_avg));
                    if st ~=0
                        fprintf('MNE Grand averaging has failed; attempting manual computation of average')
                        grandaveSK(cfg,subj,run)
                        error('ERROR : error in computing grand average highpass  %d to lowpass %d\n',cfg.mne_preproc_grand_average.hpf(igrand_avg),cfg.mne_preproc_grand_average.lpf(igrand_avg))
                    end
                catch
                    continue
                end
                
            end
            
            
            fprintf(1,'\n Success!: highpass  %d to lowpass %d\n',cfg.mne_preproc_grand_average.hpf(igrand_avg),cfg.mne_preproc_grand_average.lpf(igrand_avg));
            
            
            
        end
        
    else
        
        for irun=cfg.start_run_from:run
            
            for igrand_avg=1:length(cfg.mne_preproc_grand_average.hpf),
                
                cfg.mne_preproc_grand_average_file= ['--raw ' [subj '_' ,cfg.protocol, '_' num2str(irun) '_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'_',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil_raw.fif ']]; % takes as input raw files who's ecg component has been removed i.e <subj>_<paradigm>_<run>_ecgClean_raw.fif
                
                if isfield(cfg,'add_event_trigger')
                    cfg.eventFile_add_trigger=['  --events  '  cfg.customeventFileName ];
                    
                elseif isfield(cfg,'add_digtrig')
                    cfg.eventFile_add_trigger= ' --digtrig STI101  ';
                    
                else
                    cfg.eventFile_add_trigger='';
                end
                
                if isfield (cfg,'manual_event_file_name')
                    command=['mne_process_raw ' cfg.mne_preproc_grand_average_file cfg.mne_process_raw_digtrig  ' --filteroff' ,'  --projon','  --ave ', cfg.protocol_avedir,'/', cfg.protocol_avename '.ave  ','  --saveavetag ','-ave ', '  ', '--events ' cfg.manual_event_file_name ' >& ', subj, '_', cfg.protocol, '_',cfg.preproc_filtered_file_tag{irun},'_',num2str(run),'_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'-',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil-ave.log'];
                else
                    command=['mne_process_raw ' cfg.mne_preproc_grand_average_file  cfg.eventFile_add_trigger ' --filteroff' ,'  --projon','  --ave ', cfg.protocol_avedir,'/', cfg.protocol_avename '.ave  ','  --saveavetag ','-ave ', '  ', ' >& ', subj, '_', cfg.protocol, '_',cfg.preproc_filtered_file_tag{irun},'_',num2str(run),'_',num2str(cfg.mne_preproc_grand_average.hpf(igrand_avg)),'-',num2str(cfg.mne_preproc_grand_average.lpf(igrand_avg)),'fil-ave.log'];
                end
                [st,wt] = unix(command);
                
                if st==0
                    fprintf(1,'\n Command executed: %s \n',command);
                    
                    fprintf(1,'\n average only run %d: highpass  %d to lowpass %d\n',irun,cfg.mne_preproc_grand_average.hpf(igrand_avg),cfg.mne_preproc_grand_average.lpf(igrand_avg));
                end
            end
        end
        
    end
    
end

if isfield(cfg,'2-20_epoching')  % Maintain settings in field cfg.mne_preproc_grand_average
    cfg.mne_preproc_grand_average.hpf=cfg.mne_preproc_grand_average.hpf(1:length(cfg.mne_preproc_grand_average.hpf)-1);
    cfg.mne_preproc_grand_average.lpf=cfg.mne_preproc_grand_average.lpf(1:length(cfg.mne_preproc_grand_average.lpf)-1);
end
filename=strcat(subj,'_do_mne_preproc_grand_average_cfg');
save(filename,'cfg','visitNo','run','subj');




diary off % Ending Diary











