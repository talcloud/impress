function [cfg]=clean_ecgeog(in_fif_File,out_fif_File,eventFileName,in_path,cfg,visitNo,subj,run)

% clean_ecg: Clean ECG from raw fif file
%
% USAGE: clean_fif_File = clean_ecg(fif_File)
%
% INPUT:
%      in_fif_File = Raw fif File
%      eog_eventFileName= name of EOG event file required.
%      ecg_eventFileName= name of ECG event file required.
%      in_path = Path where all the files are.
%
% Author: Sheraz Khan, Ph.D.2009
%         Martinos Center
%         MGH, Boston, USA
% Author: Nandita Shetty M.S., 2009
%         Martinos Center
%         MGH, Boston, USA
% sheraz@nmr.mgh.harvard.edu
% --------------------------- Script History ------------------------------
% SK 19-Nov-2009  Creation
% SK & NS Jun -2010 - added eog
% SK & NS 28-Oct 2010
% -------------------------------------------------------------------------

%%

if isfield(cfg,'apply_projections_only')
    fprintf(1,'\n Pipeline has been instructed to apply previously generated projections')
    temp = regexp(in_fif_File,'.fif');
    name = in_fif_File(1:temp-4);
    new_in_fif_File=strcat(name,'ecg_proj','.fif');
    projectfile=new_in_fif_File;
end

if ~isfield(cfg,'force171')
    cfg.force171=0;
end



if ~isfield(cfg,'apply_projections_only')
    if isfield(cfg,'clean_eog_only')
        fprintf(1,'\n Cleaning EOG only')
    end
    
    [fiffsetup] = fiff_setup_read_raw(in_fif_File);
    
    
    % Reading fif File
    
    if ~isfield(cfg,'clean_eog_only')
        
        %Geting ECG Channel
        channelNames = fiffsetup.info.ch_names;
        ch_ECG = strmatch('ECG',channelNames)
        fprintf(1,'\n ECG channel index for this subject is: %d \n',ch_ECG)
        
        warning off
        % start_samp = fiffsetup.first_samp;
        % end_samp = fiffsetup.last_samp;
        %
        % [ecg,ecgtimes] = fiff_read_raw_segment(fiffsetup, start_samp ,end_samp, ch_ECG);
        
        
        if isempty(ch_ECG) || cfg.force171
            ch_ECG= 171; % closest to the heart normally, IN future we can search for it.
            fprintf(1,'\n Using MEG0171 to identify heart beats \n')
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
        
        if isfield(cfg,'badtimes')
            
            if length(cfg.badtimes)>1
                ecg(cfg.badtimes(1)*fiffsetup.info.sfreq:cfg.badtimes(2)*fiffsetup.info.sfreq)=0;
            else
                ecg(cfg.badtimes(1)*fiffsetup.info.sfreq:end)=0;
            end
            
        end
        
        
        %% CHECKING TO SEE IF SSS RECORDING DONE WITH NEW MEG ELECTRONICS (10/1/12)
        
        fiff_file_raw=fiff_setup_read_raw(in_fif_File);
        cfg.raw_file_sfreq=fiff_file_raw.info.sfreq;
        
        if round(cfg.raw_file_sfreq)-cfg.raw_file_sfreq==0
            cfg.mne_process_raw_digtrig='  --digtrig STI101  ';
        else
            cfg.mne_process_raw_digtrig='  ';
            
        end
        
        %% detecting QRS and generating event file
        sampRate = fiffsetup.info.sfreq;
        firstSamp = fiffsetup.first_samp;
        thresh_value = 0.6;     %(qrs detection threshold)
        levels = 2.5;           %(number of std from mean to include for detection)
        num_thresh = 3;         %(max number of crossings)
        ECG_type = 999;
        [ecg_events,filtecg] = qrsDet2(sampRate, ecg, thresh_value, levels, num_thresh);
        
        writeEventFile(eventFileName, firstSamp, ecg_events, ECG_type);
        
    end
    
    %% Making projector
    
    
    
    if ~isfield(cfg,'clean_eog_only')
        
        if ~isfield(cfg,'mne_process_raw_digtrig')
            cfg.mne_process_raw_digtrig= '   ';
        end
        
        command = ['mne_process_raw --cd ' in_path ' --raw ' in_fif_File ' --events ' eventFileName cfg.mne_process_raw_digtrig ' --makeproj --projtmin ' '-0.08' ' --projtmax ' '0.08' ' --saveprojtag ' '_sss_proj' ' --projnmag ' '6' ' --projngrad ' '6' ' --projevent 999 --highpass ' '5' ' --lowpass ' '35 ' ' --projmagrej   3000  --projgradrej 2000 >& ' subj,'_',cfg.protocol,'_',num2str(run),'_ecgproj.log'];
        [s,w] = unix(command);
        test=regexp(eventFileName,'.fif');
        ecg_construct=eventFileName(1:test-21);
        ecg_event_filename=strcat(ecg_construct,'-ecg-eve.fif');
        movefile(eventFileName,ecg_event_filename)
        if s ~=0    
            error('some thing is wrong here')
        end
        
        temp = regexp(in_fif_File,'.fif');
        name = in_fif_File(1:temp-1);
        old_in_fif_File=strcat(name,'_proj','.fif');
        
        
        name = in_fif_File(1:temp-4);
        ecg_figfile=strcat(name,'ecg','.png');
        
        exist_ecg=exist(ecg_figfile,'file');
        
        if exist_ecg~=0
            ecg_figfile=strcat(name,'ecg2','.png');
        end
        
        t=1:length(filtecg);
        plot(t,filtecg);
        hold on
        grid minor
        axis tight
        plot(t(ecg_events),filtecg(ecg_events),'r+')
        print( gcf, '-dpng', ecg_figfile )
        close all
        
        new_in_fif_File=strcat(name,'ecg_proj','.fif');
        
        movefile(old_in_fif_File,new_in_fif_File)
        projectfile=new_in_fif_File;
        
    end
    
    
    if ~isfield(cfg,'manually_checked_proj')
        %% Geting EOG Channel
        channelNames = fiffsetup.info.ch_names;
        ch_EOG = strmatch('EOG',channelNames)
        
        fprintf(1,'\n EOG channel index for this subject is: %d \n',ch_EOG)
        
        
        if isempty(ch_EOG)
            
            if round(cfg.raw_file_sfreq)-cfg.raw_file_sfreq==0
                ch_EOG1 = strmatch('EEG061',channelNames);
                ch_EOG2 = strmatch('EEG062',channelNames);
            else
                
                ch_EOG1 = strmatch('EEG 061',channelNames);
                ch_EOG2 = strmatch('EEG 062',channelNames);
            end
            ch_EOG=[ch_EOG1 ch_EOG2];
            
        end
        
        
        
        
        
        if isempty(ch_EOG)
            
            error('EEG 61 or EEG 62 channel not found !!')
            
        end
        
        fprintf(1,'\n EOG channel index for this subject is: %d \n',ch_EOG)
        
        sampRate = fiffsetup.info.sfreq;
        
        start_samp = fiffsetup.first_samp;
        end_samp = fiffsetup.last_samp;
        [eog] = fiff_read_raw_segment(fiffsetup, start_samp ,end_samp, ch_EOG);
        
        fprintf(1,'\n Filtering the data to remove DC offset to help distinguish blinks from saccades \n')
        
        filteog = eegfilt(eog, sampRate,2,[]); % filtering to remove dc ofset so that we know which is blink and saccade.
        temp=sqrt(sum(filteog.^2,2));
        [~, indexmax ]=max(temp);
        clear temp temp1
        
        if isfield(cfg,'manual_eog_indexmax')
            indexmax=cfg.manual_eog_indexmax;
        end
        
        
        %-----------------------------------------------
        filteog = eegfilt(eog(indexmax,:), sampRate,0,30); % easy to detect peaks with this filtering.
        
        %% detecting eog blinks and generating event file
        
        if ~isfield (cfg,'eyeballed_eog')
            
            
            
            fprintf(1,'\n Now detecting blinks and generating corresponding event file \n')
            EOG_type = 998;
            firstSamp = fiffsetup.first_samp;
            
            temp = filteog-mean(filteog);
            
            
            
            
            eog_std_dev_value=0;
            cfg.eog_std_dev_value=4;
            
            while eog_std_dev_value==0,
                
                if skewness(temp)>0
                    
                    eog_events = peakfinder((filteog),cfg.eog_std_dev_value*std(filteog),1);
                    beta =  peakfinder((filteog),cfg.eog_std_dev_value*std(filteog),-1);
                else
                    eog_events = peakfinder((filteog),cfg.eog_std_dev_value*std(filteog),-1);
                    beta = peakfinder((filteog),cfg.eog_std_dev_value*std(filteog),1);
                end
                eog_std_dev_value=1;
                
                clear temp
                rev_switch=0;
                
                while rev_switch==0;
                    fprintf(1,'\n Saving event file \n')
                    temp = regexp(in_fif_File,'.fif');
                    name = in_fif_File(1:temp-4);
                    eog_eventFileName=strcat(name,'eog-eve','.fif');
                    eog_figfile=strcat(name,'eog','.png');
                    t=1:length(filteog);
                    plot(t,filteog);
                    hold on
                    grid minor
                    axis tight
                    plot(t(eog_events),filteog(eog_events),'r+')
                    print( gcf, '-dpng', eog_figfile )
                    
                    writeEventFile(eog_eventFileName, firstSamp, eog_events, EOG_type);
                    figure;plot(eog_events)
                    saveas(gcf,[name '-eog.fig'])
                    
                    if ~isfield(cfg,'eog_manual_sign_indicator')
                        rev_switch=1;
                    end
                    
                    if isfield(cfg,'eog_manual_sign_indicator')
                        checking=1;
                        while checking==1,
                            reponse = input('Press "y" to change eog_std_peak_value otherwise hit "Enter if happy with eog peakfinder::"','s');
                            
                            if strcmpi(reponse,'y')
                                fprintf(1,'\n You chose to change std_dev_value \n')
                                eog_std_dev_value=0;
                                reponse2 = input('Please enter the new std_dev_value::"','s');
                                value=str2double(reponse2);
                                if value <0,
                                    fprintf(1,'\n You have entered an invalid response, please try again \n')
                                    checking=1;
                                else
                                    cfg.eog_std_dev_value=value;
                                    checking=0;
                                    rev_switch=1;
                                end
                            else
                                fprintf(1,'\n You chose not to change std_dev_value \n')
                                eog_std_dev_value=1;
                                checking=0;
                                rev_switch=0;
                            end
                        end
                        if rev_switch==0,
                            reponse = input('Press "r" to invert otherwise hit "Enter if happy with eog peakfinder::"','s');
                            if strcmpi(reponse,'r')
                                fprintf(1,'\n You chose to invert \n')
                                rev_switch=0;
                                eog_events=beta;
                            else
                                fprintf(1,'\n You chose not to invert \n')
                                rev_switch=1;
                            end
                        end
                        
                        
                        
                        
                    end
                    
                    close all
                end
            end
            
        end
        
        
        %% Making projector for EOG
        
        fprintf(1,'\n Computing EOG projector \n')
        
        if isfield (cfg,'eyeballed_eog')
            
            if ~isfield(cfg,'proj_event')
                
                error(1,'\n You have indicated a manual event file but have not specified an event number. Please do so under the field cfg.proj_event \n')
            end
            
            
            
            fprintf(1,'\n User is specifying a manually generated event file \n')
            
            fprintf(1,'\n Generating EOG Plot with Manual Detection Overlay \n')
            fprintf(1,'\n Event number used: %d \n',cfg.proj_event)
            
            
            cfg.manual_eog_eventfilename=[subj,'_',cfg.protocol,'_',num2str(run),'_eyeballed_eog-eve.eve'];
            temp=load([subj,'_',cfg.protocol,'_',num2str(run),'_eyeballed_eog-eve.eve']);
            xx=temp(:,1)-temp(1,1)+1;
            xx(1)=[];
            
            eog_figfile=[subj,'_',cfg.protocol,'_',num2str(run),'_manual_eog.png'];
            t=1:length(filteog);
            plot(t,filteog);
            hold on
            grid minor
            axis tight
            plot((t(xx)'),filteog((xx)'),'r+')
            print( gcf, '-dpng', eog_figfile )
            close all
            
            if ~isfield(cfg,'mne_process_raw_digtrig')
                cfg.mne_process_raw_digtrig= '   ';
            end
            
            
            
            command = ['mne_process_raw --cd ' in_path ' --raw ' in_fif_File ' --events ' cfg.manual_eog_eventfilename cfg.mne_process_raw_digtrig ' --makeproj --projtmin ' '-0.15' ' --projtmax ' '0.15' ' --saveprojtag ' '_eyeballed_eog_proj' ' --projnmag ' '6' ' --projngrad ' '6' ' --projevent ',num2str(cfg.proj_event),' --filtersize 8192  --highpass 1 --lowpass ' '35 ' ' --projmagrej   3000  --projgradrej 2000 >& ' subj,'_',cfg.protocol,'_',num2str(run),'_eogproj.log'];
            
        else
            
            command = ['mne_process_raw --cd ' in_path ' --raw ' in_fif_File ' --events ' eog_eventFileName cfg.mne_process_raw_digtrig ' --makeproj --projtmin ' '-0.15' ' --projtmax ' '0.15' ' --saveprojtag ' '_eog_proj' ' --projnmag ' '6' ' --projngrad ' '6' ' --projevent 998  '  ' --filtersize 8192  --highpass 1 --lowpass ' '35 ' ' --projmagrej   3000  --projgradrej 2000 >& ' subj,'_',cfg.protocol,'_',num2str(run),'_eogproj.log'];
            
        end
        fprintf(1,'\n Command executed: %s \n',command);
        
        
        [s,w] = unix(command)
        if s ~=0
            
            error(w)
        end
        
        
    end
end

if ~isfield(cfg,'turnprojoff')
    cfg.turnprojoff=' --projon ';
else
    cfg.turnprojoff=' --projoff ';
end

if isfield(cfg,'clean_eog_only')
    temp = regexp(in_fif_File,'.fif');
    name = in_fif_File(1:temp-4);
    new_in_fif_File=strcat(name,'eog_proj','.fif');
    EOGprojectfile=new_in_fif_File;
    
end

%% CHECKING TO SEE IF SSS RECORDING DONE WITH NEW MEG ELECTRONICS (10/1/12)

fiff_file_raw=fiff_setup_read_raw(in_fif_File);
cfg.raw_file_sfreq=fiff_file_raw.info.sfreq;

if round(cfg.raw_file_sfreq)-cfg.raw_file_sfreq==0
    cfg.mne_process_raw_digtrig='  --digtrig STI101  ';
else
    cfg.mne_process_raw_digtrig='  ';
    
end


%% Applying the ECG EOG projector on Data

if ~isfield(cfg,'apply_projections_erm_only')
    
    fprintf(1,'\n Applying ECG EOG projector \n')
    
    temp = regexp(in_fif_File,'.fif');
    name = in_fif_File(1:temp-4);
    
    if ~isfield(cfg,'clean_eog_only')
        
        if ~isfield(cfg,'manually_checked_proj')
            
            if ~isfield (cfg,'eyeballed_eog')
                EOGprojectfile=strcat(name,'eog_proj','.fif');
            else
                EOGprojectfile=strcat(name,'eyeballed_eog_proj','.fif');
                
            end
            
            command = ['mne_process_raw --cd ' in_path ' --raw ' in_fif_File ' --proj ' EOGprojectfile cfg.mne_process_raw_digtrig '  --proj  '  projectfile  cfg.turnprojoff '  --save ' out_fif_File  ' --filteroff >& ' subj,'_',cfg.protocol,'_',num2str(run),'_ECGEOG_projapplication.log'];
            [s, w] = unix(command)
            
        elseif isfield(cfg,'applied_proj_raw')
            
            [cfg]=makenewproj(cfg,subj,run);
            EOGprojectfile=strcat(name,'ecgeog_checked-proj','.fif');
            
            command = ['mne_process_raw --cd ' in_path ' --raw ' in_fif_File ' --proj ' EOGprojectfile cfg.mne_process_raw_digtrig cfg.turnprojoff ' --save ' out_fif_File  ' --filteroff >& '  subj,'_',cfg.protocol,'_',num2str(run),'_ECGEOG_projapplication.log'];
            fprintf(1,'\n Applying manually created projections on data: %s \n',command);
            
            [s, w] = unix(command)
            
        elseif isfield(cfg,'manually_checked_proj')
            
            EOGprojectfile=strcat(name,'ecgeog_checked-proj','.fif');
            
            command = ['mne_process_raw --cd ' in_path ' --raw ' in_fif_File ' --proj ' EOGprojectfile cfg.mne_process_raw_digtrig cfg.turnprojoff ' --save ' out_fif_File  ' --filteroff >& '  subj,'_',cfg.protocol,'_',num2str(run),'_ECGEOG_projapplication.log'];
            fprintf(1,'\n Applying manually created projections on data: %s \n',command);
            
            [s, w] = unix(command)
            
        end
        
    end
    
    if isfield(cfg,'clean_eog_only')
        
        if isfield(cfg,'manual_event_file_name')
            
            cfg.mne_process_raw_digtrig=[' --events ' cfg.manual_event_file_name];
        end
        
        command = ['mne_process_raw --cd ' in_path ' --raw ' in_fif_File ' --proj ' EOGprojectfile cfg.mne_process_raw_digtrig cfg.turnprojoff ' --save ' out_fif_File  ' --filteroff >& '  subj,'_',cfg.protocol,'_',num2str(run),'_onlyEOG_projapplication.log'];
        
        fprintf(1,'\n Applying manually created projections on data: %s \n',command);
        
        [s, w] = unix(command)
    end
    
    fprintf(1,'\n Command executed: %s \n',command);
    
    
    
    if s ~=0
        
        error(w)
    end
    
end
%% Applying the ECG EOG projector on ERM

if ~isfield(cfg,'no_projector_application_on_erm')
    erm_path=[cfg.erm_rootdir '/' subj '/' num2str(visitNo) '/'];
    
    
    if isfield(cfg,'manually_checked_proj')
        
        cfg.manual_projection=[subj,'_',cfg.protocol,'_',num2str(run),'_','ecgeog_checked-proj.fif'];
        
        source=[in_path,'/',cfg.manual_projection];destination=erm_path;copyfile(source,destination);
        
        command = ['mne_process_raw --cd ' erm_path ' --raw ' cfg.in_fif_erm ' --proj ' cfg.manual_projection cfg.erm_mne_process_raw_digtrig cfg.turnprojoff '  --save ' cfg.out_fif_erm  ' --filteroff >& ' subj,'_',cfg.protocol,'_ECGEOG_erm_projapplication.log'];
        fprintf(1,'\n Applying manually created projections on erm: %s \n',command);
        [s, w] = unix(command)
        manualproj_delete=[erm_path,cfg.manual_projection];
        delete(manualproj_delete);
        
    elseif isfield(cfg,'clean_eog_only')
        
        source=[in_path,'/',EOGprojectfile];destination=erm_path;copyfile(source,destination);
        
        
        command = ['mne_process_raw --cd ' erm_path ' --raw ' cfg.in_fif_erm ' --proj ' EOGprojectfile   cfg.erm_mne_process_raw_digtrig  cfg.turnprojoff '  --save ' cfg.out_fif_erm  ' --filteroff >& '  subj,'_',cfg.protocol,'_ECGEOG_erm_projapplication.log'];
        [s, w] = unix(command)
        
        EOGproj_delete=[erm_path,EOGprojectfile];
        delete(EOGproj_delete);
        
        
    else
        
        
        source=[in_path,'/',EOGprojectfile];destination=erm_path;copyfile(source,destination);
        source=[in_path,'/',projectfile];destination=erm_path;copyfile(source,destination);
        
        
        command = ['mne_process_raw --cd ' erm_path ' --raw ' cfg.in_fif_erm ' --proj ' EOGprojectfile  '  --proj  '  projectfile cfg.erm_mne_process_raw_digtrig  cfg.turnprojoff '  --save ' cfg.out_fif_erm  ' --filteroff >& '  subj,'_',cfg.protocol,'_ECGEOG_erm_projapplication.log'];
        [s, w] = unix(command)
        
        EOGproj_delete=[erm_path,EOGprojectfile];
        ECGproj_delete=[erm_path,projectfile];
        delete(EOGproj_delete,ECGproj_delete);
    end
    
    
    
    
    source=[erm_path,deblank(cfg.out_fif_erm(1:end-4)),'_raw.fif'];
    destination=in_path;
    movefile(source,destination)
    
   
    
    
    
    fprintf(1,'\n Command erm projection executed: %s \n',command);
    
    
    
    if s ~=0
        
        error(w)
    end
    
    
    fprintf(1, '\n Done removing ECG and EOG artifacts. IMPORTANT : Please eye-ball the data !! \n')
else
    fprintf(1, '\n You have chosen not to apply the ECG EOG projection on ERM !! \n')
end

