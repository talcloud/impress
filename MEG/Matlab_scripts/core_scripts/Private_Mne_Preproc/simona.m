
in_fif_File='st_sw_1back_audcue_05_raw.fif';
[fiffsetup] = fiff_setup_read_raw(in_fif_File);
channelNames = fiffsetup.info.ch_names;
ch_EOG = strmatch('EOG',channelNames);


start_samp = fiffsetup.first_samp;
end_samp = fiffsetup.last_samp;
[data times] = fiff_read_raw_segment(fiffsetup, start_samp ,end_samp,ch_EOG(2));

eog_events_pos = peakfinder(data,3.5.*std(data),1); 

eog_events_neg = peakfinder(data,3.5.*std(data),-1); 

eog_events=[eog_events_pos eog_events_neg];
eog_events=sort(eog_events);
figure;
t=1:length(data);
plot(t,data);
hold on
grid minor
axis tight
plot(t(eog_events_pos),data(eog_events_pos),'r+')
plot(t(eog_events_neg),data(eog_events_neg),'r+')
print( gcf, '-dpng', 'eog.png')

writeEventFile('eog_pos-eve.fif', start_samp, eog_events_pos, 997);

writeEventFile('eog_neg-eve.fif', start_samp, eog_events_neg, 996);

eog_eventFileName='eog_pos-eve.fif';

command = ['mne_process_raw  --raw ' in_fif_File ' --events ' eog_eventFileName ' --makeproj --projtmin ' '-0.15' ' --projtmax  0'  ' --saveprojtag ' '_eog_pos_proj' ' --projnmag ' '2' ' --projngrad ' '2' ' --projevent 997  '  ' --filtersize 8192  --highpass 0.1 --lowpass ' '35 ' ' --projmagrej   4000  --projgradrej 3000 >& eog_pos_proj.log'];


[s,w] = unix(command)

if s ~=0

    error('some thing is wrong here')
end


eog_eventFileName='eog_neg-eve.fif';

command = ['mne_process_raw  --raw ' in_fif_File ' --events ' eog_eventFileName ' --makeproj --projtmin ' '0' ' --projtmax  0.15'  ' --saveprojtag ' '_eog_neg_proj' ' --projnmag ' '2' ' --projngrad ' '2' ' --projevent 996  '  ' --filtersize 8192  --highpass 0.1 --lowpass ' '35 ' ' --projmagrej   4000  --projgradrej 3000 >& eog_neg_proj.log'];


[s,w] = unix(command)

if s ~=0

    error('some thing is wrong here')
end


command = ['mne_process_raw   --raw ' in_fif_File ' --proj ' 'st_sw_1back_audcue_05_eog_pos_proj.fif'  '  --proj  '  'st_sw_1back_audcue_05_eog_neg_proj.fif' '  --save ' 'st_sw_1back_audcue_05_proj_raw.fif'  ' --filteroff --projoff  >& apply_proj.log'];
    [s, w] = unix(command)
    
    
if s ~=0

    error('some thing is wrong here')
end
    