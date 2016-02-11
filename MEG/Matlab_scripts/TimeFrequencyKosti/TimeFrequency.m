%% Loading data that is already in complex domain after convolving with
% wavelets. morlet_transform.m of brainstorm3 for example can also be used for it
load TF_SampleData.mat


% powspctrm: Power Spectrum, Complex values, Trials x ROIs x Frequencies x Times
% freq:      Frequencies
% times:     Time Points 

crsspctrm=squeeze(powspctrm(:,1,:,:)).*squeeze(conj(powspctrm(:,2,:,:)));

%% Cross Coherence and Phase Locking between ROI X and Y
Cross_plv=squeeze(abs(mean(crsspctrm./abs(crsspctrm))));
Cross_coherence=abs(squeeze((mean(crsspctrm)))./sqrt((squeeze(mean(abs(powspctrm(:,1,:,:)).^2))).*(squeeze(mean(abs(powspctrm(:,2,:,:)).^2)))));

% Ploting
figure;imagesc(times,freq,Cross_coherence);axis xy;colorbar
xlabel('Time (Sec)','fontsize',20,'fontweight','b')
ylabel('Frequency (Hz)','fontsize',20,'fontweight','b')
title('Coherence between X & Y','fontsize',20,'fontweight','b')
set(gca,'fontsize',20,'fontweight','b')



figure;imagesc(times,freq,Cross_plv);axis xy;colorbar
xlabel('Time (Sec)','fontsize',20,'fontweight','b')
ylabel('Frequency (Hz)','fontsize',20,'fontweight','b')
title('Phase Locking between X & Y','fontsize',20,'fontweight','b')
set(gca,'fontsize',20,'fontweight','b')


%% Auto Phase Locking Between trials at ROI X
Auto_plv=abs(squeeze(mean(powspctrm(:,1,:,:)./abs(powspctrm(:,1,:,:)))));

% Ploting
figure;imagesc(times,freq,Auto_plv);axis xy;colorbar
xlabel('Time (Sec)','fontsize',20,'fontweight','b')
ylabel('Frequency (Hz)','fontsize',20,'fontweight','b')
title('Auto Phase Locking at ROI X between Trials','fontsize',20,'fontweight','b')
set(gca,'fontsize',20,'fontweight','b')

%% Evoked and Induced Power at ROI X

Evoked_Power=squeeze(abs(mean(powspctrm(:,1,:,:)))).^2; 
Total_Power=squeeze(mean(abs(powspctrm(:,1,:,:)).^2));
Induced_Power=Total_Power-Evoked_Power;

figure;imagesc(times,freq,Evoked_Power);axis xy;colorbar
xlabel('Time (Sec)','fontsize',20,'fontweight','b')
ylabel('Frequency (Hz)','fontsize',20,'fontweight','b')
title('Evoked Power at ROI X','fontsize',20,'fontweight','b')
set(gca,'fontsize',20,'fontweight','b')


figure;imagesc(times,freq,Induced_Power);axis xy;colorbar
xlabel('Time (Sec)','fontsize',20,'fontweight','b')
ylabel('Frequency (Hz)','fontsize',20,'fontweight','b')
title('Induced Power at ROI X','fontsize',20,'fontweight','b')
set(gca,'fontsize',20,'fontweight','b')


figure;imagesc(times,freq,Total_Power);axis xy;colorbar
xlabel('Time (Sec)','fontsize',20,'fontweight','b')
ylabel('Frequency (Hz)','fontsize',20,'fontweight','b')
title('Total Power at ROI X','fontsize',20,'fontweight','b')
set(gca,'fontsize',20,'fontweight','b')