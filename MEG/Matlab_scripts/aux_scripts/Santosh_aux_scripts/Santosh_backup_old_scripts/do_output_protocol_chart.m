function [cfgsheet,spreadsheet_start]=do_output_protocol_chart(subj,visitNo,run,cfgsheet,cfg,spreadsheet_start,filenamecode)

addpath('/autofs/space/marvin_001/users/MEG/scripts/kenet/ml/curr/Santosh/SVN/Private_spreadsheet');
if nargin<7,
    filenamecode=4;
end

if nargin<6,
    spreadsheet_start=2;
end

erm_subjdir=['  ',cfg.erm_rootdir '/' subj '/' num2str(visitNo) '/'];
data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
cd(data_subjdir) % cd to the subject directory
%%
% Inputs
    
    % subject
    % cfg
    % filenamecode
    
             % filenamecode==1  subj,'_sss_cfg'
             % filenamecode==2  subj,'_mne_preproc_cfg'
             % filenamecode==3  subj,'_calc_forward_inverse_main_cfg'  
             % filenamecode==4  subj,'_epochMEG_main_cfg' 
             % filenamecode==5  subj,'_labrep_main_cfg' 
             
A=0;
             
while(A==0)
    
    if filenamecode==1,
        filename=strcat(subj,'_sss_cfg.mat');
        A=exist(filename,'file');
            if A==0,
               fprintf('Sorry but the basic processing for this subject has not been completed  %s\n',subj);
               return
            end
        
    elseif filenamecode==2,
        filename=strcat(subj,'_mne_preproc_cfg.mat');
         A=exist(filename,'file');
            if A==0,
               filenamecode=1;
            end
        
    elseif filenamecode==3,
        filename=strcat(subj,'_calc_forward_inverse_main_cfg.mat');
         A=exist(filename,'file');
            if A==0,
               filenamecode=2;
            end
        
    elseif filenamecode==4,
               filename=strcat(cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_epochMEG_main_cfg.mat');
               A=exist(filename,'file');
            if A==0,
               filenamecode=3;
            else
                load(filename)
            end
        
    else
        filename=strcat(subj,'_labrep_main_cfg.mat');
             A=exist(filename,'file');
            if A==0,
               filenamecode=4;
            end
    end

end





%%



if ~isfield(cfgsheet,'output_fields')
cfgsheet.output_fields={
    'Subject',
    'Type',
    'Age @ MEG',
    'Gender',
    'Status',
    'Date of ERM',
    'Date of MEG-Protocol',
    'Match',
    'Visit',
    'Evoked Responses',
    'Source Space Responses',
    'total # of runs',
    'particular run'
    'erm (yes or no)',
    'Sampling rate',
    'SSS',
    'origin',
    'bad_channels',
    'Movement compensation: Counter value',
    'ECG Clean'
    'Forward operator used for Inverse'
    'Projections Used in Inverse'
    'Subspace Co-relationship value'
    }';
if filenamecode>=4,
    for event=1:length(cfg.epochMEG_event_order),
      for  iepochMEG_filter=1:length(cfg.epochMEG_filt.hpf)
        if isfield(cfg,'epochMEG_merge_events'),
            cfgsheet.output_epoch_fields{event}=strcat('good_epochs_merged_cond_',num2str(event),'_',num2str(cfg.epochMEG_filt.hpf(iepochMEG_filter)),'-',num2str(cfg.epochMEG_filt.lpf(iepochMEG_filter)));
            cfgsheet.output_epoch_fields_indbad_EOG{event}=strcat('bad_epochs_EOG_merged_cond_',num2str(event),'_',num2str(cfg.epochMEG_filt.hpf(iepochMEG_filter)),'-',num2str(cfg.epochMEG_filt.lpf(iepochMEG_filter)));
            cfgsheet.output_epoch_fields_indbad_MEG{event}=strcat('bad_epochs_MEG_merged_cond_',num2str(event),'_',num2str(cfg.epochMEG_filt.hpf(iepochMEG_filter)),'-',num2str(cfg.epochMEG_filt.lpf(iepochMEG_filter)));
   
        else
            cfgsheet.output_epoch_fields{event}=strcat('good_epochs_cond_',num2str(event),'_',num2str(cfg.epochMEG_filt.hpf(iepochMEG_filter)),'-',num2str(cfg.epochMEG_filt.lpf(iepochMEG_filter)));
            cfgsheet.output_epoch_fields_indbad_EOG{event}=strcat('bad_epochs_EOG_cond_',num2str(event),'_',num2str(cfg.epochMEG_filt.hpf(iepochMEG_filter)),'-',num2str(cfg.epochMEG_filt.lpf(iepochMEG_filter)));
            cfgsheet.output_epoch_fields_indbad_MEG{event}=strcat('bad_epochs_MEG_cond_',num2str(event),'_',num2str(cfg.epochMEG_filt.hpf(iepochMEG_filter)),'-',num2str(cfg.epochMEG_filt.lpf(iepochMEG_filter)));

        end
      end  

    end
else
    cfgsheet.output_epoch_fields='';
    cfgsheet.output_epoch_fields_indbad_EOG='';
    cfgsheet.output_epoch_fields_indbad_MEG='';
end
cfgsheet.output_fields=[cfgsheet.output_fields,cfgsheet.output_epoch_fields,cfgsheet.output_epoch_fields_indbad_EOG,cfgsheet.output_epoch_fields_indbad_MEG];

end
%% Filling in the Spreadsheet
 for irun=1:run,
data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
cd(data_subjdir);
    cfgsheet.output_fields{spreadsheet_start,1}=subj;


        if filenamecode==1,
            cfgsheet.output_fields{spreadsheet_start,5}='Upto SSS complete';
        elseif filenamecode==2,
            cfgsheet.output_fields{spreadsheet_start,5}='Upto MNE preprocesing complete';
        elseif filenamecode==3,
            cfgsheet.output_fields{spreadsheet_start,5}='Upto Calc forw/Inv complete';
        elseif filenamecode==4,
            cfgsheet.output_fields{spreadsheet_start,5}='Upto epoching complete';    
        else
            cfgsheet.output_fields{spreadsheet_start,5}='Upto labrep complete';    
        end
if filenamecode>=1,        
filename=strcat(subj,'_do_sss_decimation_combined_cfg.mat');
load(filename);
    mneString=[strcat('mne_show_fiff --in',erm_subjdir,subj,'_erm_1_raw.fif --tag 204 --verbose')];
      [~, w]=system(mneString);
              if (isempty(w)),
                  date='';
                  cfgsheet.output_fields{spreadsheet_start,14}='ERM NO';
              else
              date=deblank(w(end-24:end));
              cfgsheet.output_fields{spreadsheet_start,14}='ERM YES';
              end
    cfgsheet.output_fields{spreadsheet_start,6}=date;


    data_subjdir=['  ',data_subjdir];
    mneString=[strcat('mne_show_fiff --in  ',data_subjdir,subj,'_',cfg.protocol,'_',num2str(irun),'_raw.fif --tag 204 --verbose')];
      [~, w]=system(mneString);
              if (isempty(w)),
              date_protocol='';
              else
              date_protocol=deblank(w(end-24:end));
              end
    cfgsheet.output_fields{spreadsheet_start,7}=date_protocol;              
              
     matchdate=deblank(date(1:end-13));
     matchdateprotocol=deblank(date_protocol(1:end-13));
    I=strmatch(matchdate,matchdateprotocol);
 
            if isempty(I)==0,
    cfgsheet.output_fields{spreadsheet_start,8}='YES';              
            else
    cfgsheet.output_fields{spreadsheet_start,8}='NO'; 
            end 
 
    cfgsheet.output_fields{spreadsheet_start,9}=visitNo; 
    cfgsheet.output_fields{spreadsheet_start,12}=run;             
    cfgsheet.output_fields{spreadsheet_start,13}=irun; 
 
        if isfield(cfg,'ds_tag') 
            if length(cfg.ds_tag)>=irun
            cfgsheet.output_fields{spreadsheet_start,15}=cfg.ds_tag{irun};
            else
            cfgsheet.output_fields{spreadsheet_start,15}='  ';
            end
        end



        if filenamecode>1 
            cfgsheet.output_fields{spreadsheet_start,16}='YES';
        else
            cfgsheet.output_fields{spreadsheet_start,16}='NO';
        end
        
        
         filename=strcat(subj,'_do_sss_hpifit_cfg');
            load(filename);
        if isfield(cfg,'frame_tag')
           
            if length(cfg.frame_tag)>=irun
            cfgsheet.output_fields{spreadsheet_start,17}=cfg.frame_tag{irun};
            else
            cfgsheet.output_fields{spreadsheet_start,17}='  ';
            end
        end

    filename=strcat(subj,'_do_sss_bad_channels_cfg');
             load(filename);
        if isfield(cfg,'badch') 
         
            if length(cfg.badch)>=irun
            cfgsheet.output_fields{spreadsheet_start,18}=cfg.badch{irun};
            else
            cfgsheet.output_fields{spreadsheet_start,18}='  ';
            end
        end


            filename=strcat(subj,'_do_sss_movementcomp_combined_cfg');
             load(filename);
        if isfield(cfg,'HPI_DROP_COUNTER') 
 
            if length(cfg.HPI_DROP_COUNTER)>=irun
            cfgsheet.output_fields{spreadsheet_start,19}=cfg.HPI_DROP_COUNTER{irun};
            else
            cfgsheet.output_fields{spreadsheet_start,19}='  ';
            end
        end

        if filenamecode>2 
            cfgsheet.output_fields{spreadsheet_start,20}='ECG Clean YES';
        else
            cfgsheet.output_fields{spreadsheet_start,20}='ECG Clean NO';
        end
end

        if filenamecode>=3 
   filename=strcat(subj,'_do_calc_inverse_cfg');           
        load(filename);
            if isfield(cfg,'forward_operator_used_tag')
            cfgsheet.output_fields{spreadsheet_start,21}= cfg.forward_operator_used_tag;
            else
            cfgsheet.output_fields{spreadsheet_start,21}=' ';
            end
            
            
            
            

     
            if isfield(cfg,'inv_proj_tag')
              
            cfgsheet.output_fields{spreadsheet_start,22}= cfg.inv_proj_tag;
            else
            cfgsheet.output_fields{spreadsheet_start,22}=' ';
               
            end 
       


        

            
            
            if isfield(cfg,'subspace_corellationship_value')
               cfgsheet.output_fields{spreadsheet_start,23}= cfg.subspace_corellationship_value; 
            else
                 cfgsheet.output_fields{spreadsheet_start,23}=' ';
            end
            
        end
        
        
    if filenamecode>=4 
 filename=strcat(cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj,'_epochMEG_main_cfg.mat');
 load(filename);
        good_epoch_counter=24;

        for event=1:length(cfg.epochMEG_event_order)
                for iepochMEG_filter=1:length(cfg.epochMEG_filt.hpf)
                        try
                            epoch_meg=[cfg.data_rootdir,'/epochMEG'];
                            cd(epoch_meg);
    
                                epoched_filename=(strcat(cfg.data_rootdir,'/','epochMEG','/',subj,'_',cfg.protocol,'_VISIT_',num2str(visitNo),'_cond_',num2str(event), '_',num2str(cfg.epochMEG_filt.hpf(iepochMEG_filter)),'-',num2str(cfg.epochMEG_filt.lpf(iepochMEG_filter)),'fil_epochs.mat'));
                                load(epoched_filename);
                if isfield(cfg,'indgood')
                cfgsheet.output_fields{spreadsheet_start,good_epoch_counter}=length(cfg.indgood{irun});
                else
                cfgsheet.output_fields{spreadsheet_start,good_epoch_counter}=' ';
                end
                good_epoch_counter=good_epoch_counter+1;
    
    
    
                        catch
                        continue
                        end
    
    
                end 
        end
        
         for event=1:length(cfg.epochMEG_event_order)
                for iepochMEG_filter=1:length(cfg.epochMEG_filt.hpf)
                        try
                            epoch_meg=[cfg.data_rootdir,'/epochMEG'];
                            cd(epoch_meg);
    
                                epoched_filename=(strcat(cfg.data_rootdir,'/','epochMEG','/',subj,'_',cfg.protocol,'_VISIT_',num2str(visitNo),'_cond_',num2str(event), '_',num2str(cfg.epochMEG_filt.hpf(iepochMEG_filter)),'-',num2str(cfg.epochMEG_filt.lpf(iepochMEG_filter)),'fil_epochs.mat'));
                                load(epoched_filename);
                if isfield(cfg,'indbad_EOG')
                cfgsheet.output_fields{spreadsheet_start,good_epoch_counter}=length(cfg.indbad_EOG{irun});
                else
                cfgsheet.output_fields{spreadsheet_start,good_epoch_counter}=' ';
                end
                good_epoch_counter=good_epoch_counter+1;
    
    
    
                        catch
                        continue
                        end
    
    
                end 
        end
        
        
        
         for event=1:length(cfg.epochMEG_event_order)
                for iepochMEG_filter=1:length(cfg.epochMEG_filt.hpf)
                        try
                            epoch_meg=[cfg.data_rootdir,'/epochMEG'];
                            cd(epoch_meg);
    
                                epoched_filename=(strcat(cfg.data_rootdir,'/','epochMEG','/',subj,'_',cfg.protocol,'_VISIT_',num2str(visitNo),'_cond_',num2str(event), '_',num2str(cfg.epochMEG_filt.hpf(iepochMEG_filter)),'-',num2str(cfg.epochMEG_filt.lpf(iepochMEG_filter)),'fil_epochs.mat'));
                                load(epoched_filename);
                if isfield(cfg,'indbad_MEG')
                cfgsheet.output_fields{spreadsheet_start,good_epoch_counter}=length(cfg.indbad_MEG{irun});
                else
                cfgsheet.output_fields{spreadsheet_start,good_epoch_counter}=' ';
                end
                good_epoch_counter=good_epoch_counter+1;
    
    
    
                        catch
                        continue
                        end
    
    
                end 
        end       
        
        
        
        
        
        
        
        
        
        
     end

spreadsheet_start=spreadsheet_start+1;
end