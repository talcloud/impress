
function [argA,argB,varargout]= do_erm_decimation(subj,varargin) 
    
    % Generates filtered variants of SSS data of all subjects for a
    % paradigm. Assumes default subject list. 
    %--------------------------------------
    % Dr Engr. Sheraz Khan,  P.Eng, Ph.D.
    % Engr. Nandita Shetty,  MS.
    %
    % Modified By Santosh Ganesan
    % Date:   June 15, 2011
    %--------------------------------------

%     diary(strcat(subj,'_erm_mne_preproc_noise_files_',protocol,'.info'));
%     diary on

optargin = size(varargin,2);
stdargin = nargin - optargin;

fprintf('Number of inputs = %d\n', nargin)

fprintf('  Inputs from individual arguments(%d):\n', ...
        stdargin)
if optargin==1
   argA=1;
   argB=144;
    fprintf('     %d\n', argA)
    fprintf('     %d\n', argB)
end

% if stdargin >= 1
%     fprintf('     %d\n', argA)
% end
% if stdargin == 2
%     fprintf('     %d\n', argB)
% end

fprintf('  Inputs packaged in varargin(%d):\n', optargin)
 for k= 1 :2: size(varargin,2)-1 
     fprintf('     %d to %d\n', varargin{k},varargin{k+1})
 end
 
 
 
%  vartest(10,20,30,40,50,60,70)
% Number of inputs = 7
%   Inputs from individual arguments(2):
%      10
%      20
%   Inputs packaged in varargin(5):
%      30
%      40
%      50
%      60
%      70


%% Computation of noise  files.MM
    
%     cd(subjdir); 
% 
% 
%     fprintf('computing noise files %s\n',s);
%     
%     
%     raw_tag = ['--raw ' subj '_' protocol '_1_sss.fif '];
%     raw_dec_tag = [subj '_' protocol '_1_dec_sss'];
%     mne_dec_tag = ['--raw ' subj '_' protocol '_1_dec_sss_raw.fif '];
%   
%     
%     
%     filt1_25_tag = [' --highpass 1 --lowpass 25 --projoff ' ' --save ' s '_' p '_' num2str(run),'_1_25fil.fif '];
%     filt25_tag = [' --highpass .1 --lowpass 25 --projoff ' ' --save ' s '_' p '_' num2str(run),'_.1_25fil.fif '];
%     filt20_tag = [' --highpass .1 --lowpass 20 --projoff ' ' --save ' s '_' p '_' num2str(run),'_1_20fil.fif '];
%     filt40_tag = [' --highpass 1 --lowpass 40 --projoff ' ' --save ' s '_' p '_' num2str(run),'_1_40fil.fif '];
%     filt144_tag = [' --highpass 1 --lowpass 144 --projoff ' ' --save ' s '_' p '_' num2str(run),'_1_144fil.fif '];
%     
%      fprintf(1,'\n Generating Tags: \n'); 
%   % Decimating to 600 HZ sampling  
%   
%     fprintf('decimating to 600 Hz sampling %s\n',s);
% [info] = fiff_read_meas_info([s '_' p '_1_sss.fif']);
%         
%         if info.sfreq >= 3000
%          fprintf('decim=5 \n');
%             ds_tag=' --decim  5';
%         elseif  info.sfreq >= 600 
%                fprintf('decim=1 \n');
%             ds_tag=' --decim 1 ';
%         else      
%             error('Check sampling rate');
%         end
% 
% 
%         
%     fprintf('lowpass 144 Hz \n');
%     command = ['mne_process_raw ' raw_tag  ds_tag '  --lowpass 144  --projoff  --save ' raw_dec_tag ' >& ' s '_' p '_decim.log'];
%     [st,wt] = unix(command);
%         fprintf(1,'\n Command executed: %s \n',command);
% 
%     if st ~=0
%         error('ERROR : error in downsampling')
%     end
%     
%     
%          fprintf('bandpass 1-25 Hz \n');
% 
%     command = ['mne_process_raw ' mne_dec_tag ' --projoff ' filt1_25_tag '--cov ' covdir p '.cov ' ' --savecovtag -1_25fil-cov  ' ' >& ' s '_' p '_1_25fil-cov.log'];
%     [st,wt] = unix(command);
%         fprintf(1,'\n Command executed: %s \n',command);
% 
%     if st ~=0
%         error('ERROR : error in computing cov with 1 to 25 LPF')
%     end
% 
%     movefile([s '_' p '_1_dec_sss-1_25fil-cov.fif'],[s '_' p '_1-1-25fil-cov.fif'])
%        
%     
%     fprintf('bandpass .1-25 Hz \n');
% 
%     command = ['mne_process_raw ' mne_dec_tag ' --projoff ' filt25_tag '--cov ' covdir p '.cov ' ' --savecovtag -.1_25fil-cov  ' ' >& ' s '_' p '_.1_25fil-cov.log'];
%     [st,wt] = unix(command);
%         fprintf(1,'\n Command executed: %s \n',command);
% 
%     if st ~=0
%         error('ERROR : error in computing cov with .1 to 25 LPF')
%     end
% 
%     movefile([s '_' p '_1_dec_sss-.1_25fil-cov.fif'],[s '_' p '_1-.1-25fil-cov.fif']);
%     
%     
%     
%     
%     
%     fprintf('bandpass 1-20 Hz \n');
% 
%     command = ['mne_process_raw ' mne_dec_tag ' --projoff ' filt20_tag '--cov ' covdir p '.cov ' ' --savecovtag -20fil-cov  ' ' >& ' s '_' p '_1_20fil-cov.log'];
%     [st,wt] = unix(command);
%         fprintf(1,'\n Command executed: %s \n',command);
% 
%     if st ~=0
%         error('ERROR : error in computing cov with 20 LPF')
%     end
% 
%     movefile([s '_' p '_1_dec_sss-20fil-cov.fif'],[s '_' p '_1-1-20fil-cov.fif'])
%     
%     
%             
%     fprintf('bandpass 1-40 Hz \n');
%       
%     command = ['mne_process_raw ' mne_dec_tag ' --projoff ' filt40_tag '--cov ' covdir p '.cov ' ' --savecovtag -40fil-cov  ' ' >& ' s '_' p '_1_40fil-cov.log'];
%     [st,wt] = unix(command);
%         fprintf(1,'\n Command executed: %s \n',command);
% 
%     if st ~=0
%         error('ERROR : error in computing cov with 40 LPF')
%     end
% 
%     movefile([s '_' p '_1_dec_sss-40fil-cov.fif'],[s '_' p '_1-1-40fil-cov.fif'])
%     
%     
%     
%     
%     fprintf('bandpass 1-144 Hz \n');
% 
%     command = ['mne_process_raw ' mne_dec_tag ' --projoff ' filt144_tag ' --cov ' covdir p '.cov ' ' --savecovtag -144fil-cov ' ' >& ' s '_' p '_1_144fil-cov.log'];
%     [st,wt] = unix(command);
%         fprintf(1,'\n Command executed: %s \n',command);
% 
%     if st ~=0
%         error('ERROR : error in computing cov with 144 LPF')
%     end
% 
%     movefile([s '_' p '_1_dec_sss-144fil-cov.fif'],[s '_' p '_1-1-144fil-cov.fif']);
%     
%     diary off
%     clear all