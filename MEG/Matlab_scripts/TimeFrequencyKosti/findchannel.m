function chan=findchannel(in_fif_File,chanName)
raw = fiff_setup_read_raw(in_fif_File);
chan=raw.info.ch_names;
ind=1:306;
ind(3:3:306)=[];

chan=chan(ind);


temp=zeros(length(chanName),1);
for i=1:length(chanName)
    
    temp(i,1)=find(strcmp(chan,['MEG' num2str(chanName(i))]));
    
end

chan=(temp);