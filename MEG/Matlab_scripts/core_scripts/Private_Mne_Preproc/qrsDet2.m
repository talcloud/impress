function [clean_events,filtecg] = qrsDet2(sampRate, ecg, thresh_value, levels, num_thresh)
%thresh_value = 0.6; levels = 2.5;  num_thresh = 3; 
minInterval = round((60*sampRate)/120);

BLANK_PERIOD = minInterval;

%newecg = baslnfilt(ecg, sampRate);
%lenpts = length(newecg);
%qrsfilt = fir1(12, 35/(sampRate/2));
%filtecg = filter(qrsfilt,1,newecg);

filtecg = bandpassFilter(ecg, sampRate, 5, 35);
lenpts = length(filtecg);

absecg = abs(filtecg);
init = sampRate;

maxpt(1) = max(absecg(init*35:init*36));
maxpt(2) = max(absecg(init*45:init*46));
maxpt(3) = max(absecg(init*55:init*56));

init_max = mean(maxpt);

qrs_event.filtecg = filtecg;
qrs_event.thresh1 = init_max*thresh_value;
qrs_event.time=[];
k=1;
i=1;

while i < lenpts-BLANK_PERIOD+1
    if absecg(i) > qrs_event.thresh1 
        window = absecg(i:i+BLANK_PERIOD);
        [maxPoint, maxTime] = max(window(1:BLANK_PERIOD/2));
        rms = sqrt(mean(window.^2));
        
        %plot(window), hold on
        %plot(5,rms,'rx'), hold off
        
        x=find(window>qrs_event.thresh1);
        y=diff(x);
        numcross = length(find(y>1))+1;
        
        qrs_event.time(k) = maxTime+i;
        qrs_event.ampl(k) = maxPoint;
        qrs_event.numcross(k) = numcross;
        qrs_event.rms(k) = rms;

        i=i+BLANK_PERIOD;
        k=k+1; 
    else
        i=i+1;
    end
end
        
rms_mean = mean(qrs_event.rms);
rms_std = std(qrs_event.rms);
rms_thresh = rms_mean+(rms_std*levels);
b = find(qrs_event.rms < rms_thresh);
a = qrs_event.numcross(b);
c = find(a < num_thresh);
clean_events = qrs_event.time(b(c));




