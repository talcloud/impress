
function plotfft_fm(in_fif_File)

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



f=nfft/2+1;

[chan]=size(data,1);
px=zeros(chan,f);
for i=1:chan
    i
[P,f] = pwelch(data(i,:),window,noverlap,nfft,fs);
px(i,:)=10.*log10(P);

end

figure;plot(f(1:round(end)),px(3:3:306,1:round(end)),'linewidth',2);title('magnetometers');axis tight;xlabel('Hz');ylabel('10.*log');
saveas(gcf,[in_fif_File(1:end-5) '_fft_magnetometers.png'])
ind=1:306;
ind(3:3:306)=[];

figure;plot(f(1:round(end)),px(ind,1:round(end)),'linewidth',2);title('Gradiometers');axis tight;xlabel('Hz');ylabel('10.*log');
saveas(gcf,[in_fif_File(1:end-5) '_fft_graiometers.png'])
