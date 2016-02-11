function [cfg]=clean_ecg(in_fif_File,out_fif_File,eventFileName,in_path,cfg,visitNo,subj,run,force171,force159)

% clean_ecg: Clean ECG from raw fif file
%
% USAGE: clean_fif_File = clean_ecg(fif_File)
%
% INPUT:
%       Raw fif File
%
% OUTPUT:
%       clean Raw fif File
%
% Author: Sheraz Khan, 2009
%         Martinos Center
%         MGH, Boston, USA
%
% --------------------------- Script History ------------------------------
% SK 19-Nov-2009  Creation
% -------------------------------------------------------------------------

%%
% Reading fif File

%% CHECKING TO SEE IF SSS RECORDING DONE WITH NEW MEG ELECTRONICS (10/1/12)

fiff_file_raw=fiff_setup_read_raw(in_fif_File);
cfg.raw_file_sfreq=fiff_file_raw.info.sfreq;

if cfg.raw_file_sfreq==600
    cfg.mne_process_raw_digtrig='  --digtrig STI101  --digtrigmask 0xff ';  % km: --digtrigmask 0xff was inserted for 8 bits
else
    cfg.mne_process_raw_digtrig=' --digtrigmask 0xff ';
    
end


if ~isfield(cfg,'apply_projections_only')
    
    if ~exist('force159')
        force159=0;
    end
    
    if ~exist('force171')
        force171=0;
    end
    
    [fiffsetup] = fiff_setup_read_raw(in_fif_File);
    
    %Geting ECG Channel
    channelNames = fiffsetup.info.ch_names;
    ch_ECG = strmatch('ECG',channelNames);
    
    if isempty(ch_ECG)
        ch_ECG = strmatch('EEG 063',channelNames);
    end
    % start_samp = fiffsetup.first_samp;
    % end_samp = fiffsetup.last_samp;
    %
    % [ecg,ecgtimes] = fiff_read_raw_segment(fiffsetup, start_samp ,end_samp, ch_ECG);
    
    
    if isempty(ch_ECG) || force171~=0
        ch_ECG= 171; % closest to the heart normally, IN future we can search for it.
    end
    
    if isempty(ch_ECG) || force159~=0
        ch_ECG= 159; % closest to the heart normally, IN future we can search for it.
    end
    
    if isfield(cfg,'manual_ch_ECG')
        ch_ECG=cfg.manual_ch_ECG;
    end
    
    
    start_samp = fiffsetup.first_samp;
    end_samp = fiffsetup.last_samp;
    [ecg] = fiff_read_raw_segment(fiffsetup, start_samp ,end_samp, ch_ECG);
    
    if sum(ecg)==0
        ch_ECG=171;
        [ecg] = fiff_read_raw_segment(fiffsetup, start_samp ,end_samp, ch_ECG);
    end
    
    
    
    %% detecting QRS and generating event file
    sampRate = fiffsetup.info.sfreq;
    firstSamp = fiffsetup.first_samp;
    thresh_value = 0.6;     %(qrs detection threshold)
    levels = 2.5;           %(number of std from mean to include for detection)
    num_thresh = 3;         %(max number of crossings)
    ECG_type = 999;
    [ecg_events,filtecg] = qrsDet2(sampRate, ecg, thresh_value, levels, num_thresh);
    
    temp=regexp(eventFileName,'.fif');
    newevefile=eventFileName(1:temp-14);
    eventfileoutput=strcat(newevefile,'-eve.fif');
    
    writeEventFile(eventfileoutput, firstSamp, ecg_events, ECG_type);
    
    
    %% Making projector
    if ~isfield(cfg,'manually_checked_proj')
        
        if ~isfield(cfg,'ecg_grad_number')
            cfg.ecg_grad_number=6; % 05-Jan-2015 -KM , previously 2
        end
        
        if ~isfield(cfg,'ecg_mag_number')
            cfg.ecg_mag_number=6;  % 05-Jan-2015 -KM , previously 1
        end
        
        
        if isfield (cfg,'eyeballed_ecg')
            
            cfg.manual_ecg_eventfilename=[subj,'_',cfg.protocol,'_',num2str(run),'_eyeballed_ecg-eve.eve'];
            temp=load([subj,'_',cfg.protocol,'_',num2str(run),'_eyeballed_ecg-eve.eve']);
            xx=temp(:,1)-temp(1,1)+1;
            xx(1)=[];
            
            ecg_figfile=[subj,'_',cfg.protocol,'_',num2str(run),'_manual_ecg.png'];
            t=1:length(filtecg);
            plot(t,filtecg);
            hold on
            grid minor
            axis tight
            plot((t(xx)'),filtecg((xx)'),'r+')
            print( gcf, '-dpng', ecg_figfile )
            close all
            
            
            if ~isfield(cfg,'proj_event')
                
                error(1,'\n You have indicated a manual event file but have not specified an event number. Please do so under the field cfg.proj_event \n')
            end
            
            fprintf(1,'\n User is specifying a manually generated event file \n')
            
            fprintf(1,'\n Generating EOG Plot with Manual Detection Overlay \n')
            fprintf(1,'\n Event number used: %d \n',cfg.proj_event)
            
            if ~isfield(cfg,'no_data_sss')
                ending = '_decim_sss_proj'; % DECIM SSS DATA FILE INPUT
                
            else
                
                ending = '_decim_raw_proj'; % RAW DATA FILE INPUT
                
            end
            
            command = ['mne_process_raw --cd ' in_path ' --raw ' in_fif_File ' --events ' cfg.manual_ecg_eventfilename cfg.mne_process_raw_digtrig ' --makeproj --projtmin ' '-0.08' ' --projtmax ' '0.08' ' --saveprojtag ' ending ' --projnmag ' num2str(cfg.ecg_mag_number)  ' --projngrad ' num2str(cfg.ecg_grad_number) ' --projevent ',num2str(cfg.proj_event),' --highpass ' '5' ' --lowpass ' '35 ' ' --projmagrej   4000  --projgradrej 3000 >& ' subj,'_',cfg.protocol,'_',num2str(run),'_ecgproj.log'];
            
            
            
        else
            
            if ~isfield(cfg,'no_data_sss')
                
                ending = '_sss_proj'; % SSS DATA FILE INPUT
                
            else
                
                ending = '_raw_proj'; % RAW DECIM DATA FILE INPUT
                
            end
            
            
            command = ['mne_process_raw --cd ' in_path ' --raw ' in_fif_File ' --events ' eventfileoutput cfg.mne_process_raw_digtrig ' --makeproj --projtmin ' '-0.08' ' --projtmax ' '0.08' ' --saveprojtag ' ending ' --projnmag ' num2str(cfg.ecg_mag_number)  ' --projngrad ' num2str(cfg.ecg_grad_number) ' --projevent 999 --highpass ' '5' ' --lowpass ' '35 ' ' --projmagrej   4000  --projgradrej 3000 >& ' subj,'_',cfg.protocol,'_',num2str(run),'_ecgproj.log'];
            [s,w] = unix(command);
            
            
            % test=strcat(subj,'_',cfg.protocol,'_',num2str(run),'_raw-eve.fif');
            % ecg_construct=test(1:end-12);
            % ecg_event_filename=strcat(ecg_construct,'-ecg-eve.fif');
            % movefile(test,ecg_event_filename)
        end
        
        if s ~=0
            error('some thing is wrong here')
        end
        
        if ~isfield (cfg,'eyeballed_ecg')
            
            
            temp = regexp(in_fif_File,'.fif');
            name = in_fif_File(1:temp-1);
            old_in_fif_File=strcat(name,'_proj','.fif');
            
            
            name = in_fif_File(1:temp-4);
            ecg_figfile=strcat(name,'ecg','.png');
            t=1:length(filtecg);
            plot(t,filtecg);
            hold on
            grid minor
            axis tight
            plot(t(ecg_events),filtecg(ecg_events),'r+')
            print( gcf, '-dpng', ecg_figfile )
            close all
        end
        new_in_fif_File=strcat(name,'ecg_proj','.fif');
        
        movefile(old_in_fif_File,new_in_fif_File)
    end
end
temp = regexp(in_fif_File,'.fif');
name = in_fif_File(1:temp-4);


if ~isfield(cfg,'turnprojoff')
    cfg.turnprojoff=' --projon ';
else
    cfg.turnprojoff=' --projoff ';
end


if ~isfield(cfg,'no_projector_application_on_data')
    
    if ~isfield(cfg,'manually_checked_proj')
        projectfile=strcat(name,'ecg_proj','.fif');
        
        
        %% Applying projector on Data
        command = ['mne_process_raw --cd ' in_path ' --raw ' in_fif_File ' --proj ' projectfile cfg.turnprojoff cfg.mne_process_raw_digtrig ' --save ' out_fif_File  ' --filteroff >&  ',subj,'_',cfg.protocol,'_',num2str(run),'_ECGprojapplication.log'];
        [s, w] = unix(command);
    else
        projectfile=strcat(name,'ecg_checked-proj','.fif');
        command = ['mne_process_raw --cd ' in_path ' --raw ' in_fif_File ' --proj ' projectfile cfg.turnprojoff '  --save ' out_fif_File  ' --filteroff >& ECGprojapplication.log'];
        fprintf(1,'\n Applying manually created projections on data: %s \n',command);
        
        [s, w] = unix(command);
        if s ~=0
            error('some thing is wrong here')
        end
    end
end


%%  Applying projector on ERM

if ~isfield(cfg,'no_projector_application_on_erm')
    erm_path=[cfg.erm_rootdir '/' subj '/' num2str(visitNo) '/'];
    
    
    if isfield(cfg,'manually_checked_proj')
        
        cfg.manual_projection=[subj,'_',cfg.protocol,'_',num2str(run),'_','ecg_checked-proj.fif'];
        source=[in_path,'/',cfg.manual_projection];destination=erm_path;copyfile(source,destination);
        
        command = ['mne_process_raw --cd ' erm_path ' --raw ' cfg.in_fif_erm ' --proj ' cfg.manual_projection cfg.turnprojoff cfg.erm_mne_process_raw_digtrig ' --save ' cfg.out_fif_erm  ' --filteroff >& ECG_erm_projapplication.log'];
        fprintf(1,'\n Applying manually created projections on erm: %s \n',command);
        
        [s, w] = unix(command);
        manualproj_delete=[erm_path,cfg.manual_projection];
        delete(manualproj_delete);
    else
        
        source=[in_path,'/',projectfile];destination=erm_path;copyfile(source,destination);
        
        command = ['mne_process_raw --cd ' erm_path ' --raw ' cfg.in_fif_erm '  --proj  '  projectfile  cfg.turnprojoff cfg.erm_mne_process_raw_digtrig '  --save ' cfg.out_fif_erm  ' --filteroff >& ECG_erm_projapplication.log'];
        [s, w] = unix(command);
        ECGproj_delete=[erm_path,projectfile];
        delete(ECGproj_delete);
    end
    
    
    
    
    
    source=[erm_path,deblank(cfg.out_fif_erm(1:end-4)),'_raw.fif'];
    destination=in_path;
    movefile(source,destination)
    
    
    
    
    fprintf(1,'\n Command erm projection executed: %s \n',command);
    
    
    if s ~=0
        
        error(w)
    end
else
    fprintf(1, '\n You have chosen not to apply the ECG projection on ERM !! \n')
end
