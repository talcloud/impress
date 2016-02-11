function TF = computeMorletTransform(x,fs,freq)
% Description
%-------------------------------------------------------------
% Compute Time Frequency decomposition
%
% TF = computeMorletTransform(x,fs,freq)
%-------------------------------------------------------------
% INPUTS:
%   x       - Time series 1 (1 x Timepoints)
%   Fs      - Sampling Frequency (Scalar)
%   freq    - frequency range of interest (1 x Frequencies)
% OUTPUTS:
%   TF    - Time Frequency Decomposition (Frequencies x Timepoints)
% ----------------------------------------------------------- 
%------------------------------------------------------------
% Sheraz Khan, Ph.D. , October 20, 2010
%------------------------------------------------------------



nTime=size(x,1);
nFreq=length(freq);


% First compute wavelets for given frequecy range to safe time they can be
% precomputed as they are data independent
W = computeWavelets(fs,freq);


% Now compute Phase Locking
TF=zeros(nFreq,nTime);
times=0:1/fs:length(x)/fs-1/fs;

for iFreq=1:nFreq
    
    nWavelet= length(W{iFreq});
    
    % Convolution
    Wx = fconv(x,W{iFreq});  

    % Adjusting length
    nt = fix(nWavelet/2);
    Wx = Wx(nt:size(Wx,1)-nt,:);   
    
    TF(iFreq,:) = Wx;

end

%TF = single(abs(TF).^2); 


% if verbose
%  scrsz = get(0,'ScreenSize'); 
%  
%     figure;
%     set(gcf,'Position',[scrsz(3) scrsz(4)/2 scrsz(3)/2 scrsz(4)/2])
%     xlabel('Time (sec)')
%     ylabel('Frequency (Hz)')
%     title('Time Frequency decomposition')
%     for index=1:round(0.25*chunk*fs):nTime
%         if (index+chunk*fs-1) < nTime
%     imagesc(times(index:index+chunk*fs-1),freq,20.*log10(TF(:,index:index+chunk*fs-1)));axis xy;colormap jet
%     xlabel('Time (sec)')
%     ylabel('Frequency (Hz)')
%     title('Time Frequency decomposition')
%     pause(0.5)
%     
%         else
%     imagesc(times(index:end),freq,20.*log10(TF(:,index:end)));axis xy;colormap jet
%     xlabel('Time (sec)')
%     ylabel('Frequency (Hz)')
%     title('Time Frequency decomposition')
%    
%   
%         end 
% 
%     end
% end