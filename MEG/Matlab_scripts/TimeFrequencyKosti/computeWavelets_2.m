function W = computeWavelets(fs,freq,cycles,wavetype)
% USAGE:
%-------------------------------------------------------------
% Compute Wavelets for the given frequency range
%
% PLV = computePLV(x,y,sfr,freq);
%-------------------------------------------------------------
% INPUTS:
%   fs      - Sampling Frequency (Scalar)
%   freq    - frequency range of interest (1 x Frequencies)
%   wavetype - gabor or morlet
% OUTPUTS:
%    W    - Wavelets  (Cell Array- 1 x Frequencies)
% -----------------------------------------------------------   
%------------------------------------------------------------
% Sheraz Khan, Ph.D. , October 20, 2010
%------------------------------------------------------------

W=cell(1);



for ifreq=1:length(freq)
f=freq(ifreq);    
if strcmp(wavetype,'gabor')
sig = cycles/f; 
elseif strcmp(wavetype,'morlet')
sig=cycles./(2*pi.*f); 
elseif strcmp(wavetype,'shannon')
sig = cycles/f; 
end
T = 50/f;  
t1 = -T/2;
t2 =  T/2;
t = (t1:1/fs:t2-1/fs)';
if mod(length(t),2)
    t = (t1:1/fs:t2)';
end;
if or(strcmp(wavetype,'gabor'), strcmp(wavetype,'morlet'))
W{ifreq} = exp(- t.^2/(2*sig^2)) .* exp(1i*2*pi*f*t);
elseif strcmp(wavetype,'shannon')
 W{ifreq} = sinc(- t.^2/(2*sig^2)) .* exp(1i*2*pi*f*t);
end
end


        