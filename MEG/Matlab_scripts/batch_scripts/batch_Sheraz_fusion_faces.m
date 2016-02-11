%% Global Variables

    %  Necessary for functions

cfg.protocol='Deception';
% .Ave file for ERM
cfg.covdir = ('/autofs/cluster/fusion/Sheraz/MEG/erm');
% .Ave file for Protocol
% cfg.protocol_covdir = ('/space/sondre/2/users/meg/wmm');
cfg.protocol_avedir=('/autofs/cluster/fusion/Sheraz/MEG/Faces');
% Data Directory
cfg.data_rootdir=('/autofs/cluster/fusion/Sheraz/MEG');
%cfg.data_rootdir=('/autofs/space/amiga_001/users/meg/tacr_new');
% ERM Directory
% cfg.erm_rootdir=('/autofs/cluster/transcend/manfred/erm');
cfg.erm_rootdir=('/autofs/cluster/fusion/Sheraz/MEG/erm/');


%!export SUBJECTS_DIR=/autofs/space/calvin_001/marvin/1/users/MRI/WMA/recons/

% For calc/forward inverse
cfg.setMRIdir=('/space/sondre/1/users/mri/mit/recon');
addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/');

%% Default Settings

% AS DEFAULT, ALL FUNCTIONS/SUBFUNCTIONS WILL RUN/PLEASE UNCOMMENT IN ORDER TO DISABLE A PARTICULAR FUNCTION/SUB-FUNCTION(S). IF A MAIN
% FUNCTION IS DISABLED, ALL SUBFUNCTIONS WILL ALSO BE DISABLED 
% 
% cfg.do_erm_and_data_sss_main=[];
% %  
%                    cfg.do_sss_hpifit=[];
%                  cfg.do_sss_bad_channels=[];
%                    cfg.do_sss_movementcomp_combined=[];
%                   cfg.do_sss_no_movementcomp_combined=[];
%                 cfg.do_sss_transform_allrunsto_singlerun=[];
%                 cfg.do_sss_decimation_combined=[];
% 
%     cfg.do_mne_preproc_main=[];
% 
%                 cfg.do_mne_preproc_heartbeat=[];
%                        cfg.do_erm_filtering_mne=[];
%                      cfg.do_erm_noise_covariance_mne=[];
%                      cfg.do_mne_preproc_filtered=[];
                     cfg.do_mne_preproc_grand_average=[];
  
       cfg.do_calc_forward_inverse_main=[];
%                 cfg.do_calc_forward=[];
%                cfg.do_calc_inverse=[];
%             
   cfg.do_epochMEG_main=[];
   cfg.frame_tag_checker_off=[];     
   cfg.mne_preproc_filt.hpf(1)=.1;
   cfg.mne_preproc_filt.lpf(1)=55;
   cfg.filt.hpf(1)=.1;  
   cfg.filt.lpf(1)=55;
   
 subject={'AC065','043202','012301','012301','002901','AC047','AC047','AC069'};
 visitNo=[1];