function decimate_data_nonfixrate(cfg)
raw=fiff_setup_read_raw('/autofs/cluster/transcend/MEG/merge_erm/051301/1/051301_erm_1_raw.fif');
[data,times] = fiff_read_raw_segment(raw)

datadec=resample(data',1,2);