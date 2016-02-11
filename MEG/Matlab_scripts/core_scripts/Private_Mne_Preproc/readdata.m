function [data,times,raw] = readdata(filename)

raw=fiff_setup_read_raw(filename);
[data,times]=fiff_read_raw_segment(raw);
times=times-times(1);
data=data(1:306,:);
proj=computeProj(raw);
data=proj*data;

end

