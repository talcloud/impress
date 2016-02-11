function [Total,Induced,Evoked,PLF,ITC]=ComputeAutoTF(TF,cfg)

if ~isfield(cfg,'Total')
cfg.Total=0;
end

if ~isfield(cfg,'Induced')
cfg.Induced=0;
end

if ~isfield(cfg,'Total_subtract')
cfg.Total_subtract=0;
end

if ~isfield(cfg,'Induced_subtract')
cfg.Induced_subtract=0;
end

if ~isfield(cfg,'Evoked')
cfg.Evoked=0;
end

if ~isfield(cfg,'PLF')
cfg.PLF=0;
end

if ~isfield(cfg,'ITC')
cfg.ITC=0;
end




if isfield(cfg,'startTime')
ind1=find(cfg.times>cfg.startTime,1,'first');
end

if isfield(cfg,'endTime')
ind2=find(cfg.times>cfg.endTime,1,'first');
end

TF=TF+eps;
PLF=squeeze(abs(mean(TF./abs(TF))));
ITC=(abs(squeeze(mean(TF))))./(sqrt(squeeze(mean(abs(TF).^2))));
Total=(squeeze(mean(abs(TF))));
Evoked=(squeeze(abs(mean(TF))));
TF_mean=squeeze(mean(TF));
TF_mean=repmat(TF_mean,[ 1 1 1 size(TF,1)]);
TF_mean=permute(TF_mean,[4 1 2 3]);
TF_induced=TF-TF_mean;
Induced=(squeeze(mean(abs(TF_induced))));
clear    TF_mean;





if cfg.Total
TF_mean=squeeze(mean(abs(TF(:,:,:,ind1:ind2)),4));
TF_mean=(repmat(TF_mean,[ 1 1 1 size(TF,4)]));
temp=abs(TF);    
temp=temp./(TF_mean);
Total=10.*log10(squeeze(mean((temp))));
clear    TF_mean;
end

if cfg.Total_subtract
TF_mean=squeeze(mean(abs(TF(:,:,:,ind1:ind2)),4));
TF_mean=(repmat(TF_mean,[ 1 1 1 size(TF,4)]));
temp=abs(TF);    
temp=temp-(TF_mean);
Total=(squeeze(mean((temp))));
clear    TF_mean;
end

if cfg.Induced
TF_mean=squeeze(mean(abs(TF_induced(:,:,:,ind1:ind2)),4));
TF_mean=(repmat(TF_mean,[ 1 1 1 size(TF_induced,4)]));
temp=abs(TF_induced);    
temp=temp./(TF_mean);
Induced=10.*log10(squeeze(mean((temp))));
clear    TF_mean;
end

if cfg.Induced_subtract
TF_mean=squeeze(mean(abs(TF_induced(:,:,:,ind1:ind2)),4));
TF_mean=(repmat(TF_mean,[ 1 1 1 size(TF_induced,4)]));
temp=abs(TF_induced);    
temp=temp-(TF_mean);
Induced=(squeeze(mean((temp))));
clear    TF_mean;
end

if cfg.Evoked
TF_mean=squeeze(mean((Evoked(:,:,ind1:ind2)),3));
TF_mean=(repmat(TF_mean,[1 1 size(Evoked,3)]));
Evoked=Evoked-(TF_mean); 
clear    TF_mean;
end


if cfg.PLF
TF_mean=squeeze(mean((PLF(:,:,ind1:ind2)),3));
TF_mean=(repmat(TF_mean,[1 1 size(PLF,3)]));
PLF=PLF-(TF_mean); 
clear    TF_mean;
end

if cfg.ITC
TF_mean=squeeze(mean((ITC(:,:,ind1:ind2)),3));
TF_mean=(repmat(TF_mean,[1 1 size(ITC,3)]));
ITC=ITC-(TF_mean);
clear    TF_mean;
end





end

