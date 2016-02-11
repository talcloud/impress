function [cfg]=do_epochMEG(subj,visitNo,run,cfg) 
  %% Error Check
if isfield(cfg,'error_mode')
    
   file= exist(strcat(subj,'_do_epochMEG_error_cfg.mat'),'file');
           if file~=2
               return
           else
               delete(file);
           end    
end
%% Parsing Ave Descriptor file to obtain tmin, tmax, bmin, bmax, if empty
 if ~isfield(cfg,'epochMEG_time')

if isfield(cfg,'epochMEG_merge_events'),
logfile=strcat(cfg.protocol_covdir,'/',cfg.protocol,'_merg.ave');
else
    logfile=strcat(cfg.protocol_covdir,'/',cfg.protocol,'.ave');
end
fprintf(1,'Parsing logfile: %s \n',logfile)
fid = fopen(logfile,'r');
pat2='\s+';
checktmin=0;checktmax=0;checkbmin=0;checkbmax=0;
counter=1;
while(1)
% Reading each line    
    dline = fgetl(fid);
    if(dline == -1)
        break;
    end

    res = regexp(dline,pat2,'split');
  
       for m=1:length(res) 
        
     a=strcmp(res{m},'tmin');
     b=strcmp(res{m},'tmax');
     c=strcmp(res{m},'bmin');
     d=strcmp(res{m},'bmax');
     e=strcmp(res{m},'event');
      if(checktmin==0)  
       if(a==1) 
        cfg.epochMEG_time(1)= str2double(res{m+1});
         checktmin=1;
       end
      end  
      if(checktmax==0)
        if(b==1)
        cfg.epochMEG_time(2)= str2double(res{m+1});
          checktmax=1;
        end
      end
      if(checkbmin==0)
        if(c==1)
          cfg.epochMEG_baseline(1)= str2double(res{m+1});
          checkbmin=1;
        end
      end
      if(checkbmax==0)
         if(d==1)
          cfg.epochMEG_baseline(2)= str2double(res{m+1});
         end
      end
      
   if ~isfield(cfg,'epochMEG_merge_events'),   
%           if(e==1)
%           cfg.epochMEG_event_order(counter)=str2double(res{m+1});
%           counter=counter+1;
%           end
   else
       cfg.epochMEG_event_order=cfg.newevents;
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

if isempty(cfg.epochMEG_time(1)||cfg.epochMEG_time(2)),
 error('Please enter a tmin & tmax value in sub-structure cfg.epochMEG_time: Thank you');
end

if ~isfield(cfg,'epochMEG_event_order'),
 error('Please enter an event order in sub-structure cfg.epochMEG_event_order: Thank you');
end


subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
cd(subjdir) % cd to the fif dir
%% epochMEG

diary(strcat(subj,'_epochMEG_sub.info'));
diary on

                if ~isfield(cfg,'removeECG_EOG')
                 cfg.removeECG_EOG=2;
                end


                if isempty(cfg.epochMEG_eventfilename)
                  cfg.epochMEG_eventfilename=cfg.removeECG_EOG;
                end
                
                if cfg.epochMEG_eventfilename==3,
                        cfg.epochMEG_eventfilename='sss';
                elseif cfg.epochMEG_eventfilename==2,
                    cfg.epochMEG_eventfilename='ecgeogClean';
                else
                    cfg.epochMEG_eventfilename='ecgClean';
                end
                
       cfg.mne_preproc_filt.hpf(length(cfg.mne_preproc_filt.hpf)+1)=2;
  cfg.mne_preproc_filt.lpf(length(cfg.mne_preproc_filt.lpf)+1)=20;          
                cfg.epochMEG_filt=cfg.mne_preproc_filt;
                
                if isempty(cfg.epochMEG_filt),
                    cfg.epochMEG_filt.hpf(1)=1;
                    cfg.epochMEG_filt.lpf(1)=144;
                    fprintf(' Default highpass   %d to lowpass %d\n', cfg.epochMEG_filt.hpf(1),cfg.epochMEG_filt.lpf(1));

  
                end
             
 for iepochMEG_filter=1:length(cfg.epochMEG_filt.hpf),               
    for cond=1:length(cfg.epochMEG_event_order)                
        for irun=1:run,
    
       
    
        

                fileData=strcat(cfg.data_rootdir,'/', subj, '/',num2str(visitNo),'/', subj,'_',cfg.protocol,'_',num2str(irun),'_',num2str(cfg.epochMEG_filt.hpf(iepochMEG_filter)),'_',num2str(cfg.epochMEG_filt.lpf(iepochMEG_filter)),'fil_raw.fif');
                A=exist(fileData);
                if isfield(cfg,'epochMEG_merge_events'),
                 
                eventfile=strcat(cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/', subj ,'_',cfg.protocol,'_',num2str(irun),'_',cfg.epochMEG_eventfilename,'_raw-eve_merg-eve.fif');
                else
                eventfile=strcat(cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/', subj ,'_',cfg.protocol,'_',num2str(irun),'_',cfg.epochMEG_eventfilename,'_raw-eve.fif');
                end
                B=exist(eventfile);
%                 goodtrialLog=strcat(cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj ,'_',cfg.protocol,'_',num2str(irun),'_',num2str(cfg.epochMEG_filt.hpf(iepochMEG_filter)),'_',num2str(cfg.epochMEG_filt.lpf(iepochMEG_filter)),'fil-ave.log'); 
          if isfield(cfg,'epochMEG_merge_events')     
                 
              goodtrialLog=strcat(cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj ,'_',cfg.protocol,'_',num2str(irun),'_',num2str(2),'_',num2str(20),'fil-merge-ave.log'); 
          else
              goodtrialLog=strcat(cfg.data_rootdir,'/',subj,'/',num2str(visitNo),'/',subj ,'_',cfg.protocol,'_',num2str(irun),'_',num2str(2),'_',num2str(20),'fil-ave.log'); 

          end
              
              C=exist(goodtrialLog);
                
              if (A+B+C~=6)
                 fprintf(' One of the input files doesnt exist, skipping the run');
     
                  continue
          
              end   
        
              
                [data,cfg.times,cfg.epoch_ch_names] = mne_read_epochs(fileData,cfg.epochMEG_event_order(cond),eventfile,cfg.epochMEG_time(1),cfg.epochMEG_time(2));



                            if ~isempty(cfg.epochMEG_baseline)&& isfield(cfg,'implement_baseline_correction'),
        
                                fprintf(' Implementing baseline correction: bmin  %d to bmax %d\n', cfg.epochMEG_baseline(1),cfg.epochMEG_baseline(2));

                                first_sample=find(cfg.times  >=cfg.epochMEG_baseline(1),1,'first');
                                zero_sample=find(cfg.times  >=cfg.epochMEG_baseline(2),1,'first');

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
                                        [cfg.indgood{irun},cfg.indbad_EOG{irun},cfg.indbad_MEG{irun}] = parsemneavelog_enhanced(goodtrialLog,cfg.epochMEG_event_order(cond));
                                        else
                                        [cfg.indgood{irun},cfg.indbad_EOG{irun},cfg.indbad_MEG{irun}] = parsemneavelog_merge_events(goodtrialLog,cfg.epochMEG_event_order(cond));
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
                                     
                                            
                                            
                                            
                                            good_epochs.data_run{irun}=cfg.indgood{irun};
           
                                            all_epochs.data_run{irun}=data(:,:,:);
                                           
                                           

              cfg.ratioGoodTrials(irun)=length(cfg.indgood{irun})/(length(cfg.indgood{irun})+length(cfg.indbad_EOG{irun}+length(cfg.indbad_MEG{irun})));      
              

        end

cd(cfg.data_rootdir);
A=exist('epochMEG','dir');
if A~=7
   mkdir('epochMEG') 
end
if size(good_epochs)~=0,
 good_epochs=cat(2,good_epochs.data_run{1,:});
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
                  save(strcat(cfg.data_rootdir,'/','epochMEG','/',subj,'_',cfg.protocol,'_VISIT_',num2str(visitNo),'_cond_',num2str(cond_save), '_',num2str(cfg.epochMEG_filt.hpf(iepochMEG_filter)),'-',num2str(cfg.epochMEG_filt.lpf(iepochMEG_filter)),'fil_epochs.mat'),'run','cond','good_epochs','all_epochs','cfg','visitNo');
    
         
   end

end
diary off
