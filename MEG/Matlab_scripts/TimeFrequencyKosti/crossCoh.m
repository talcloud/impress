function Coh=crossCoh(TF1,TF2)
% Compute Coherence
% TF1: Input Complex time frequency Epochs x Time x Frequency 
% TF2: Input Complex time frequency Epochs x Time x Frequency 

% Coh: Output Real Time X Frequency

Coh=TF1.*conj(TF2);




Coh=abs(squeeze((mean(Coh)))./sqrt((squeeze(mean(abs(TF1).^2))).*(squeeze(mean(abs(TF2).^2)))));

