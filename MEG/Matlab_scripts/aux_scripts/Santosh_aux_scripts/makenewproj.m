
function [cfg]=makenewproj(cfg,subj,run)

%data_subjdir=[cfg.data_rootdir '/' subj '/' num2str(visitNo) '/'];
%cd(data_subjdir);

rawfile=[subj,'_',cfg.protocol,'_',num2str(run),'_','new_ecgeogClean_raw.fif'];

cfg.manual_projection=[subj,'_',cfg.protocol,'_',num2str(run),'_','ecgeog_checked-proj.fif'];
info= fiff_read_meas_info(rawfile);
indexActive=zeros(1,length(info.projs));

for i=1:length(info.projs)
indexActive(i)=info.projs(i).active;
end

projdata=info.projs;

projdata(indexActive==0)=[];

fid = fiff_start_file(cfg.manual_projection);


fiff_write_proj(fid, projdata);

fclose(fid);


