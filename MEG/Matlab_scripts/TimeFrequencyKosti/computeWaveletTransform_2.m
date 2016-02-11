function TF = computeWaveletTransform(x,cfg)
% Description
%-------------------------------------------------------------
% Compute Time Frequency decomposition
%
% TF = computeMorletTransform(x,fs,freq)
%-------------------------------------------------------------
% INPUTS:
%   x       - Time series 1 (Timepoints x nEpochs)
%   fs      - Sampling Frequency (Scalar)
%   freq    - frequency range of interest (1 x Frequencies)
%   cycles  - Number of Cycles (Normally 7)
%   wavetype - gabor or morlet
% OUTPUTS:
%   TF    - Time Frequency Decomposition (nEpochs xFrequencies x Timepoints)
% ----------------------------------------------------------- 
%------------------------------------------------------------
% Sheraz Khan, Ph.D. , October 20, 2010
%------------------------------------------------------------

%---------------------------Usage---------------------------
% time=0:1/600.615:10;
% for i=1:100
% x(:,i)=sin(2*pi*10*time);
% end
% x=x+randn(6007,100);
% TF = computeMorletTransform(x,600.615,7:20,5,'morlet');
% figure;imagesc(time,7:20,squeeze(mean(abs(TF).^2)));axis xy
% TF = computeMorletTransform(x,600.615,7:20,5,'gabor');
% figure;imagesc(time,7:20,squeeze(mean(abs(TF).^2)));axis xy
%-------------------------------------------------------------

nTime=size(x,1);
nEpochs=size(x,2);
nFreq=length(cfg.freq);




TF=zeros(nEpochs,nFreq,nTime);

for iEpochs=1:nEpochs

for iFreq=1:nFreq
    
    nWavelet= length(cfg.W{iFreq});
    
    % Convolution
    Wx = fconv(x(:,iEpochs),cfg.W{iFreq});  

    % Adjusting length
    nt = fix(nWavelet/2);
    Wx = Wx(nt:size(Wx,1)-nt,:);   
    
    TF(iEpochs,iFreq,:) = Wx;

end
end

%TF = single(abs(TF).^2); 


