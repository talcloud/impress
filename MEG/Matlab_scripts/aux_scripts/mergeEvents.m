function newfile=mergeEvents(eventfile,orignalevents,newevents)

% mergeEvents: Merge Event in the event file
%
% USAGE: newfile=mergeEvents(eventfile,orignalevents,newevents)
%
% INPUT:
%      eventfile = Orignal Event File
%      orignalevents= Structure containg orignal event you want to merge
%      newevents= Number of the new events
%  OUTPUT:
%      newfile= New Event file Name
%     Example Use
%     orignalevents{1}=[1 2 3];
%     orignalevents{2}=[4 5];
%     newevents(1)=[997]
%     newevents(2)=[998]
%     newfile=mergeEvents('Orignal_eventfile-eve.fif',orignalevents,newevents)
%     This code will merge events 1 2 3 to event 997 and 4 and 5 to 998
%
% Author: Sheraz Khan, PhD
%         Martinos Center
%         MGH, Boston, USA
%         sheraz@nmr.mgh.harvard.edu
% --------------------------- Script History ------------------------------
% SK 19-Nov-2010  Creation
% -------------------------------------------------------------------------

if size(orignalevents,2)~=length(newevents)
    error('both need to be same')
end

[eventlist] = mne_read_events(eventfile);
eventlist_temp = eventlist;

for i=1:size(orignalevents,2)

events=orignalevents{i};
for j=1:length(events)
    eventlist(eventlist==events(j))=newevents(i);

end
end
eventlist=[eventlist_temp;eventlist];

temp = regexp(eventfile,'.fif'); 
name = eventfile(1:temp-1);
newfile=strcat(name,'_merg-eve','.fif');

mne_write_events(newfile,eventlist)