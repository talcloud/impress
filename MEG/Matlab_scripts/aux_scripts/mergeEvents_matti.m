function newfile=mergeEvents_matti(eventfile)



[eventlist] = mne_read_events(eventfile);


for i=1:size(eventlist,1)-2

if eventlist(i,3)==1 && eventlist(i+2,3)==32
    eventlist(i,3)=3;
    eventlist(i+1,2)=3;
elseif   eventlist(i,3)==2 && eventlist(i+2,3)==32 
        eventlist(i,3)=4;
    eventlist(i+1,2)=4;
    
end

end

temp = regexp(eventfile,'.fif'); 
name = eventfile(1:temp-1);
newfile=strcat(name,'_event-according-buttonpress-eve','.fif');

mne_write_events(newfile,eventlist)