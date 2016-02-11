function [subj,visitNo,run,cfg]=do_labelrep_main(subj,visitNo,run,cfg)


%% config file

    % Necessary for the main functions
%   1) labelrep_cortex(data,cfg);
    
% Inputs

        % A)         data                  % epoched data

        % B)         inverse operator      % read from config file by default into cfg.inverse_operator_name, if the sub-structure
                                           % is empty.

        % C)         nave                  % read from config file by default into cfg.nave, if the sub-structure is empty


        % D)         mne_normalization_method
                                            % read from config file into cfg.mne_normalization_method. If
                                            % the sub-structure is empty, default is = dspm. otherwise
                                            % cfg.mne_normalization_method =1, refers to sLoretta

           
                                           
                                           
                                        


                   
                                
    
    
    
%   2) cfg.do_calc_inverse=[];
    
%        cfg.inv_cov_tag=[];      % cfg.inv_cov_tag/ Please set filter bands here for do_calc_inverse
                                % IF EMPTY, DEFAULT FILTERING WILL BE ACCOMPLISHED
                                % at highpass 1 Hz and lowpass of 144 Hz
                                
                                % The structure is as follows:
                                % cfg.inv_cov_tag.lpf(1)=40;
                                % cfg.inv_cov_tag.hpf(2)=2;
                                % cfg.inv_cov_tag.lpf(1)=98;
                                % cfg.inv_cov_tag.hpf(2)=0;
                                % Filter Bands set between 2-40Hz & 0-98 Hz
%% Actions                                
 
fprintf('Starting Specified Actions %s\n',subj); 


if (cfg.do_labelrep_cortex)
fprintf('Starting labelrep cortex %s\n',subj);    
[cortex,cfg] = labelrep_cortex(data,cfg);
fprintf('Complete ! %s\n',subj); 
end   

if (cfg.do_labelmean_all_cortex_enhanced)
fprintf('Starting labelmean %s\n',subj);    
[labrep,cfg] = labelmean_all_cortex_enhanced(subj,cfg,inv,cortex,fcn,labelyear);
fprintf('Complete ! %s\n',subj); 
end  
