function detectbadchannels(filename,thresh)
 locs=strfind(filename,'/');
[data,~,raw] = readdata(filename);


data=data(1:306,:);

data = eegfilt(data,raw.info.sfreq,[],50);
data=detrend(data')';
data=data(1:306,round(raw.info.sfreq*5):end-round(raw.info.sfreq*5));


indm=3:3:306;
indg=1:306;
indg(indm)=[];

Zg = mean(abs(data(indg,:)),2);
Zg=(Zg-mean(Zg))./std(Zg);

Zm = mean(abs(data(indm,:)),2);
Zm=(Zm-mean(Zm))./std(Zm);


namesm=raw.info.ch_names(indm);



namesg=raw.info.ch_names(indg);

namesm=namesm(Zm>thresh);
namesg=namesg(Zg>thresh);

badchan=sort([namesm namesg]);

for i=1:length(badchan)
    badchan{i}=badchan{i}(4:end);
    if badchan{i}(1)=='0'
        badchan{i}(1)=[];
    end
end

dlmcell([ filename(1:locs(end)) 'badch.txt'],badchan)