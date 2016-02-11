function [cfg]=do_epochMEG(subj,visitNo,run,cfg)

%   Sheraz Khan <sheraz@nmr.mgh.harvard.edu>
%   Santosh Ganesan <santosh@nmr.mgh.harvard.edu>
%   Fahimeh Mamashli
%   EPOCHS DATA
% Local variables:
%   1) subj = subject name
%   2) visitNo = visit number
%   3) run = run number
%   4) cfg = data structure with global variables
% OPTIONS:
% 1) cfg.removeECG_EOG // if set (cfg.removeECG_EOG=1), indicates removing heartbeat only, cfg.removeECG_EOG=2 indicates removing heartbeat and blinks
% 2) cfg.epochMEG_merge_events // if set,(cfg.epochMEG_merge_events), events will be merged

% PARAMETERS:
% 1) cfg.epochMEG_event_order // must set order of original events in ave file
% For merging events, 1 & 4, 2 & 5
% EXAMPLE: cfg.epochMEG_event_order{1}=[1,4];
% cfg.epochMEG_event_order{2}=[2,5];

% 2) cfg.newevents // must set order of new events in ave file
% EXAMPLE: cfg.newevents(1)=[90]
% cfg.newevents(2)=[91]

% 3) cfg.mne_preproc_filt:

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

% 4) cfg.use_epoching_with_nonmerge_eventfile // if set, (cfg.use_epoching_with_nonmerge_eventfile=[]), then merge events, but use a nonmerge eventfile
% 5) cfg.use_specific_file_for_epoching // epoching using a particularly chosen LOG filename, not the automatically generated one.
% 6) cfg.grand_avg_manual_filename // if set,can manually set naming convention of grand average
% 7) cfg.epoch_folder_name // set the folder name for epoching, default name is cfg.epoch_folder_name='epochMEG'
% 8) cfg.epochMEG_cond_number_manual_set // set the condition number to be saved in the folder


% EXAMPLE: cfg.epochMEG_cond_number_manual_set=3;
% subj_protocol_visitnumber_cond_3_HPF-LPF_fil_epochs.mat



%% Error Check
if isfield(cfg,'error_mode')
    
    file= exist(strcat(subj,'_do_epochMEG_error_cfg.mat'),'file');
    if file~=2
        return
    else
        delete(file);
    end
end

if ~isfield(cfg,'protocol_avename')
    error('Please enter a cfg.protocol_avename: Thank you');
end

%% Parsing Ave Descriptor file to obtain tmin, tmax, bmin, bmax, if empty

if ~isfield(cfg,'epochMEG_event_order'),
    error('Please enter an event order in sub-structure cfg.epochMEG_event_order: Thank you');
end

if isfield(cfg,'epochMEG_merge_events'),
    cfg.epochMEG_event_order=cfg.newevents;
    logfile=strcat(cfg.protocol_avedir,'/',cfg.protocol_avename,'_merg.ave');
else
    logfile=strcat(cfg.protocol_avedir,'/',cfg.protocol_avename,'.ave');
end



if ~isfield(cfg,'epochMEG_time')
    
    fprintf(1,'Parsing logfile: %s \n',logfile)
    read=0;
    cfg.tminvalue=zeros(1,length(cfg.epochMEG_event_order));
    cfg.tmaxvalue=zeros(1,length(cfg.epochMEG_event_order));
    cfg.bminvalue=zeros(1,length(cfg.epochMEG_event_order));
    cfg.bmaxvalue=zeros(1,length(cfg.epochMEG_event_order));
    
    for i=1:length(cfg.epochMEG_event_order)
        
        fid = fopen(logfile,'r');
        pat2='\s+';
                
        
        
        while(1)
            
            % Reading each line
            dline = fgetl(fid);
            if(dline == -1)
                break;
            end
            
            res = regexp(dline,pat2,'split');
            
                        
            e=strcmp(res,'event');
            particular_event=num2str(cfg.epochMEG_event_order(i));
            f=strcmp(res,particular_event);
            
            
            commentcheck=strcmp(res,'#');
            
            
            if (sum(commentcheck)==0)
                
                if(sum(e+f)==2)
                    read=1;
                end
                
                while(read==1)
                    dline = fgetl(fid);
                    if(dline == -1)
                        break;
                    end
                    
                    res = regexp(dline,pat2,'split');
                    
                    a=strcmp(res,'tmin');
                    b=strcmp(res,'tmax');
                    c=strcmp(res,'bmin');
                    d=strcmp(res,'bmax');
                                                            
                    
                    
                    if(sum(a)==1)
                        place=find(a==1);
                        cfg.tminvalue(i)= str2double(res{place+1});
                        
                    end
                    
                    
                    if(sum(b)==1)
                        place=find(b==1);
                        cfg.tmaxvalue(i)= str2double(res{place+1});
                        
                    end
                    
                    if(sum(c)==1)
                        place=find(c==1);
                        cfg.bminvalue(i)= str2double(res{place+1});
                        
                    end
                    
                    if(sum(d)==1)
                        place=find(d==1);
                        cfg.bmaxvalue(i)= str2double(res{place+1});
                        read=0;
                    end
                    
                                                           
                end
            end
            
        end
    end
end


%% Global Variables

if ~isfield(cfg,'data_rootdir'),
    error('Please enter a root directory in sub-structure cfg.rootdir: Thank you');
end

if ~isfield(cfg,'protocol'),
    error('Please enter a protocol name in sub-structure cfg.protocol: Thank you');
end

% if isempty(cfg.epochMEG_time(1)||cfg.epochMEG_time(2)),
%  error('Please enter a tmin & tmax value in sub-structure cfg.epochMEG_time: Thank you');
% end

subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
cd(subjdir) % cd to the fif dir
%% epochMEG

diary(strcat(subj,'_epochMEG_sub_',datestr(clock),'.info'));
diary on

if ~isfield(cfg,'start_run_from')
    cfg.start_run_from=1;
end

if ~isfield(cfg,'removeECG_EOG'),
    for irun=cfg.start_run_from:run,
        cfg.removeECG_EOG(irun)=2;
    end
    fprintf('\n Remove ECG_EOG is not set %s\n',subj);
    fprintf('\n Default will be used/ Removal of ECG & EOG! %s\n',subj);
    fprintf('\n ECG_EOG=2! %s\n',subj);
end

if ~isfield(cfg,'epochMEG_eventfilename')
    cfg.epochMEG_eventfilename=cell(1,run);
end

for xx=cfg.start_run_from:run,
    
    
    if cfg.removeECG_EOG(xx)==3,
        cfg.epochMEG_eventfilename{xx}='sss';
    elseif cfg.removeECG_EOG(xx)==2,
        cfg.epochMEG_eventfilename{xx}='ecgeogClean';
    else
        cfg.epochMEG_eventfilename{xx}='ecgClean';
    end
    
end

%  cfg.mne_preproc_filt.hpf(length(cfg.mne_preproc_filt.hpf)+1)=2;
%cfg.mne_preproc_filt.lpf(length(cfg.mne_preproc_filt.lpf)+1)=20;
cfg.epochMEG_filt=cfg.mne_preproc_filt;

if isempty(cfg.epochMEG_filt),
    
    cfg.epochMEG_filt.hpf(1)=1;
    cfg.epochMEG_filt.lpf(1)=144;
    fprintf(' Default highpass   %d to lowpass %d\n', cfg.epochMEG_filt.hpf(1),cfg.epochMEG_filt.lpf(1));
    
    
end

for iepochMEG_filter=1:length(cfg.epochMEG_filt.hpf),
    for cond=1:length(cfg.epochMEG_event_order)
        for irun=cfg.start_run_from:run,
            
            % cd to the fif dir
            cd(subjdir)
            
            
            fileData=strcat(cfg.data_rootdir,'/', subj, '/',num2str(visitNo),'/', subj,'_',cfg.protocol,'_',num2str(irun),'_',num2str(cfg.epochMEG_filt.hpf(iepochMEG_filter)),'_',num2str(cfg.epochMEG_filt.lpf(iepochMEG_filter)),'fil_raw.fif');
            A=exist(fileData);
            
            if isfield(cfg,'epochMEG_merge_events'),
                
                eventfile=strcat(cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/', subj ,'_',cfg.protocol,'_',num2str(irun),'_',cfg.epochMEG_eventfilename{irun},'_raw-eve_merg-eve.fif');
            elseif isfield(cfg,'add_event_trigger')
                
                if isfield(cfg,'customeventFileName')
                    
                    eventfile=cfg.customeventFileName;
                else
                    
                    eventfile=strcat(cfg.data_rootdir,'/', subj, '/',num2str(visitNo),'/', subj,'_',cfg.protocol,'_',num2str(irun),'_',num2str(cfg.epochMEG_filt.hpf(iepochMEG_filter)),'_',num2str(cfg.epochMEG_filt.lpf(iepochMEG_filter)),'fil_raw_',cfg.add_event_trigger.stemEventFile,'-eve.fif');
                end
                
            elseif isfield(cfg,'add_emg_triggers')
                eventfile = cfg.manual_event_file_name;
                
            else
                if cfg.removeECG_EOG(irun)==3
                    eventfile=strcat(cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/', subj ,'_',cfg.protocol,'_',num2str(irun),'_',cfg.epochMEG_eventfilename{irun},'-eve.fif');
                    
                else
                    
                    eventfile=strcat(cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/', subj ,'_',cfg.protocol,'_',num2str(irun),'_',cfg.epochMEG_eventfilename{irun},'_raw-eve.fif');
                end
            end
            
            B=exist(eventfile);
            
            if B~=2
                if isfield(cfg,'epochMEG_merge_events') && isfield(cfg,'use_epoching_with_nonmerge_eventfile')
                    eventfile=strcat(cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/', subj ,'_',cfg.protocol,'_',num2str(irun),'_',cfg.epochMEG_eventfilename{irun},'_raw-eve.fif');
                    B=exist(eventfile);
                end
            end
            
            
            if isfield(cfg,'epochMEG_merge_events')
                if isfield(cfg,'use_specific_file_for_epoching')
                    if isfield(cfg,'grand_avg_manual_filename')
                        goodtrialLog=strcat(cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj ,'_',cfg.protocol,'_',num2str(irun),'_',num2str(cfg.use_specific_file_for_epoching.hpf(1)),'_',num2str(cfg.use_specific_file_for_epoching.lpf(1)),'fil-',cfg.grand_avg_manual_filename,'-ave.log');
                        
                    else
                        
                        goodtrialLog=strcat(cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj ,'_',cfg.protocol,'_',num2str(irun),'_',num2str(cfg.use_specific_file_for_epoching.hpf(1)),'_',num2str(cfg.use_specific_file_for_epoching.lpf(1)),'fil-merge-ave.log');
                    end
                    
                else
                    
                    if isfield(cfg,'grand_avg_manual_filename')
                        
                        goodtrialLog=strcat(cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj ,'_',cfg.protocol,'_',num2str(irun),'_',num2str(cfg.epochMEG_filt.hpf(iepochMEG_filter)),'_',num2str(cfg.epochMEG_filt.lpf(iepochMEG_filter)),'fil-',cfg.grand_avg_manual_filename,'-ave.log');
                        
                    else
                        
                        goodtrialLog=strcat(cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj ,'_',cfg.protocol,'_',num2str(irun),'_',num2str(cfg.epochMEG_filt.hpf(iepochMEG_filter)),'_',num2str(cfg.epochMEG_filt.lpf(iepochMEG_filter)),'fil-merge-ave.log');
                    end
                end
                
                %goodtrialLog=strcat(cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj ,'_',cfg.protocol,'_',num2str(irun),'_',num2str(2),'_',num2str(20),'fil-merg-no-vib-ave.log');
                %            goodtrialLog=strcat(cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj ,'_',cfg.protocol,'_',num2str(irun),'_',num2str(2),'_',num2str(20),'fil-merge-ave.log');
                % goodtrialLog=strcat(cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj ,'_',cfg.protocol,'_',num2str(irun),'_',num2str(2),'_',num2str(20),'fil-merge-13-ave.log');
                
            else
                if isfield(cfg,'use_specific_file_for_epoching')
                    if isfield(cfg,'grand_avg_manual_filename')
                        
                        goodtrialLog=strcat(cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj ,'_',cfg.protocol,'_',num2str(irun),'_',num2str(cfg.use_specific_file_for_epoching.hpf(1)),'_',num2str(cfg.use_specific_file_for_epoching.lpf(1)),'fil-',cfg.grand_avg_manual_filename,'-ave.log');
                        
                    elseif isfield(cfg,'use_specific_protocol')
                        
                        goodtrialLog=strcat(cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj ,'_',cfg.use_specific_protocol,'_',num2str(irun),'_',num2str(cfg.use_specific_file_for_epoching.hpf(1)),'_',num2str(cfg.use_specific_file_for_epoching.lpf(1)),'fil-ave.log');
                        
                    else
                        
                        goodtrialLog=strcat(cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj ,'_',cfg.protocol,'_',num2str(irun),'_',num2str(cfg.use_specific_file_for_epoching.hpf(1)),'_',num2str(cfg.use_specific_file_for_epoching.lpf(1)),'fil-ave.log');
                        
                    end
                    
                else
                    
                    if isfield(cfg,'grand_avg_manual_filename')
                        goodtrialLog=strcat(cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj ,'_',cfg.protocol,'_',num2str(irun),'_',num2str(cfg.epochMEG_filt.hpf(iepochMEG_filter)),'_',num2str(cfg.epochMEG_filt.lpf(iepochMEG_filter)),'fil_',cfg.grand_avg_manual_filename,'-ave.log');
                        
                    else
                        goodtrialLog=strcat(cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj ,'_',cfg.protocol,'_',num2str(irun),'_',num2str(cfg.epochMEG_filt.hpf(iepochMEG_filter)),'_',num2str(cfg.epochMEG_filt.lpf(iepochMEG_filter)),'fil-ave.log');
                        
                    end
                    
                    %  goodtrialLog=strcat(cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj ,'_',cfg.protocol,'_',num2str(irun),'_',num2str(2),'_',num2str(20),'fil-13-ave.log');
                    % goodtrialLog=strcat(cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj ,'_',cfg.protocol,'_',num2str(irun),'_',num2str(2),'_',num2str(20),'fil-13-ave.log');
                    
                end
            end
            
            C=exist(goodtrialLog);
        
            if (A+B+C~=6)
                
                fprintf(' One of the input files doesnt exist, skipping the run');
                
                continue
                
            end

            % this might need to go - KM
%             if isfield(cfg,'manual_event_file_name')
%                 %fileData=cfg.epochMEG.fiff_file;
%                 eventfile=cfg.manual_event_file_name;
%             end
                      
            
            [data,cfg.times,cfg.epoch_ch_names] = mne_read_epochs(fileData,cfg.epochMEG_event_order(cond),eventfile,cfg.tminvalue(cond),cfg.tmaxvalue(cond));
                        
            
            if  isfield(cfg,'implement_baseline_correction'),
                
                fprintf(' Implementing baseline correction: bmin  %d to bmax %d\n', cfg.bminvalue(cond),cfg.bmaxvalue(cond));
                
                first_sample=find(cfg.times  >=cfg.bminvalue(cond),1,'first');
                zero_sample=find(cfg.times  >=cfg.bmaxvalue(cond),1,'first');
               
                data=permute(data,[3 1 2]);
                data_mean=mean(data(:,:,first_sample:zero_sample),3);
                data_mean=repmat(data_mean,[1 1 size(data,3)]);
                data=(data-data_mean);
                data=permute(data,[2 3 1]);
                clear data_mean zero_sample
                
            else
                
                fprintf(' Not implementing baseline correction');
                
            end
            
            % [indexGoodTrial indexBadTrial ratioGoodTrials]=findGoodTrial(goodtrialLog,event(cond));
            if ~isfield(cfg,'epochMEG_merge_events')
                [cfg.indgood{irun},cfg.indbad_EOG{irun},cfg.indbad_MEG{irun}] = parsemneavelog(goodtrialLog,cfg.epochMEG_event_order(cond));
            else
                [cfg.indgood{irun},cfg.indbad_EOG{irun},cfg.indbad_MEG{irun}] = parsemneavelog(goodtrialLog,cfg.epochMEG_event_order(cond));
                %[cfg.indgood{irun},cfg.indbad_EOG{irun},cfg.indbad_MEG{irun}] = parsemneavelog_merge_events(goodtrialLog,cfg.epochMEG_event_order(cond));
                
            end
            
            
            if (run-irun~=run-1)
                index=max(cfg.indgood{irun-1});
                Z=isempty(index);
                if(Z==0)
                    cfg.indgood{irun}=index+cfg.indgood{irun};
                    cfg.indbad_EOG{irun}=index+cfg.indbad_EOG{irun};
                    cfg.indbad_MEG{irun}=index+cfg.indbad_MEG{irun};
                end
                
                if irun>1,
                    indexmain=max(cfg.indgood{1});
                    X=isempty(indexmain);
                    if(X==0)
                        cfg.indgood{irun}=indexmain+cfg.indgood{irun};
                        cfg.indbad_EOG{irun}=indexmain+cfg.indbad_EOG{irun};
                        cfg.indbad_MEG{irun}=indexmain+cfg.indbad_MEG{irun};
                    end
                end
            end
            
            if isfield(cfg,'use_specific_mat_epoch')
                mat_epoch=load([cfg.data_rootdir,'/epochMEG/',subj,'_',cfg.protocol,'_VISIT_',num2str(visitNo),'_run_',num2str(irun),...
                    '_cond_',num2str(cond),'_',num2str(cfg.use_specific_file_for_epoching.hpf(iepochMEG_filter)),'-',num2str(cfg.use_specific_file_for_epoching.lpf(iepochMEG_filter)),'fil','_epochs.mat']);
            
                cfg.indgood{irun}=mat_epoch.good_epochs;
                
            end
            
            good_epochs.data_run{irun}=cfg.indgood{irun};
            
            all_epochs.data_run{irun}=data(:,:,:);
                        
            
            cfg.ratioGoodTrials(irun)=length(cfg.indgood{irun})/(length(cfg.indgood{irun})+length(cfg.indbad_EOG{irun}+length(cfg.indbad_MEG{irun})));
                        
        end
        
        cd(cfg.data_rootdir);
        
        if ~isfield(cfg,'epoch_folder_name')
            
            A=exist('epochMEG','dir');
            if A~=7
                mkdir('epochMEG')                
            end
            cfg.epoch_folder_name='epochMEG';
        else
            A=exist(cfg.epoch_folder_name,'dir');
            if A~=7
                mkdir(cfg.epoch_folder_name)
            end
                                                                        
        end
        
        if size(good_epochs)~=0,
            good_epochs=cat(2,good_epochs.data_run{1,:});
            
%             all_epochs.data_run{1,1}=all_epochs.data_run{1,1}(1:306,:,:);
%             all_epochs.data_run{1,2}=all_epochs.data_run{1,2}(1:306,:,:);
            
            all_epochs=cat(3,all_epochs.data_run{1,:});
        else
            good_epochs=0;
            all_epochs=0;
        end
        
        if isfield(cfg,'epochMEG_cond_number_manual_set')
            
            if length(cfg.epochMEG_cond_number_manual_set)==length(cfg.epochMEG_event_order)
                cond_save=cfg.epochMEG_cond_number_manual_set;
            else
                error('ERROR : Condition numbers you have requested to save does not match total length of conditions. please make sure that you have identified how you want to save each condition ')
                
            end
        else
            cond_save=cond;
        end
        if ~isfield(cfg,'specific_save_tag')
        save(strcat(cfg.data_rootdir,'/',cfg.epoch_folder_name,'/',subj,'_',cfg.protocol,'_VISIT_',num2str(visitNo),'_run_',num2str(irun),'_cond_',num2str(cond_save), '_',num2str(cfg.epochMEG_filt.hpf(iepochMEG_filter)),'-',num2str(cfg.epochMEG_filt.lpf(iepochMEG_filter)),'fil','_epochs.mat'),'run','cond','good_epochs','all_epochs','cfg','visitNo','goodtrialLog','eventfile');
        else
           save_name= strcat(cfg.data_rootdir,'/',cfg.epoch_folder_name,'/',subj,'_',cfg.protocol,'_VISIT_',num2str(visitNo),'_run_',num2str(irun),'_cond_',num2str(cond_save), '_',num2str(cfg.epochMEG_filt.hpf(iepochMEG_filter)),'-',num2str(cfg.epochMEG_filt.lpf(iepochMEG_filter)),'fil',cfg.specific_save_tag,'_epochs.mat');
            save(save_name,'run','cond','good_epochs','all_epochs','cfg','visitNo','goodtrialLog','eventfile');
        end
        
        
    end
    
end
diary off
