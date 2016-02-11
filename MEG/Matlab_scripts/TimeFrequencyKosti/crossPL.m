function [PL, Coh]=crossPL(TF1,TF2)

%Compute Phase Locking
% TF1: Input Complex time frequency Epochs x Time x Frequency 
% TF2: Input Complex time frequency Epochs x Time x Frequency 

% PL: Output Real Time X Frequency



PL=TF1.*conj(TF2);

Coh=abs((squeeze(mean(PL)))./sqrt((squeeze(mean(abs(TF1).^2))).*(squeeze(mean(abs(TF2).^2)))));

PL=squeeze(abs(mean(PL./abs(PL))));
