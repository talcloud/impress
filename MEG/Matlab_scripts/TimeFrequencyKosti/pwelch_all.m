function pwelch_all(in_fif_File,type,tit)

[fiffsetup] = fiff_setup_read_raw(in_fif_File);
start_samp = fiffsetup.first_samp;
end_samp = fiffsetup.last_samp;
[data] = fiff_read_raw_segment(fiffsetup, start_samp ,end_samp);
data=data(1:306,:);

fs=fiffsetup.info.sfreq;

window=4*fs;
noverlap=2*fs;
nfft=4*fs;


window=round(window);
noverlap=round(noverlap);
nfft=round(nfft);
fs=round(fs);




ind_grad=1:306;  ind_grad(3:3:306)=[];
ind_mag=3:3:306;

if type== 1
data=data(ind_grad,:);
elseif type==2
data=data(ind_mag,:);   
end


f=nfft/2+1;

[chan]=size(data,1);
px=zeros(chan,f);
for i=1:chan
    i
[P,f] = pwelch(data(i,5*fs:fs*180),window,noverlap,nfft,fs);
px(i,:)=10.*log10(P);

end

figure;plot(f(1:round(end/2)),px(:,1:round(end/2)),'linewidth',2)
axis tight
xlabel('Hz')
ylabel('10.*log')
title(tit)