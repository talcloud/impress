load('/autofs/cluster/transcend/MEG/voices/subj_manny/1/subj_manny_voices_VISIT_1_fil_selective_filtering.mat')
events(:,1)=int32(events(:,1))-int32(fiffsetup.first_samp);
durrFile=int32(fiffsetup.last_samp)-int32(fiffsetup.first_samp);
events(:,3)=[];

events_1=events(events(:,2)==1,:);
events_2=events(events(:,2)==2,:);
events_3=events(events(:,2)==3,:);
events_4=events(events(:,2)==4,:);
events_5=events(events(:,2)==5,:);
events_6=events(events(:,2)==6,:);

indgood_1 = parsemneavelog(['/autofs/cluster/transcend/MEG/voices/subj_manny/1/' goodtrialLog],1);
indgood_2 = parsemneavelog(['/autofs/cluster/transcend/MEG/voices/subj_manny/1/' goodtrialLog],2);
indgood_3 = parsemneavelog(['/autofs/cluster/transcend/MEG/voices/subj_manny/1/' goodtrialLog],3);
indgood_4 = parsemneavelog(['/autofs/cluster/transcend/MEG/voices/subj_manny/1/' goodtrialLog],4);
indgood_5 = parsemneavelog(['/autofs/cluster/transcend/MEG/voices/subj_manny/1/' goodtrialLog],5);
indgood_6 = parsemneavelog(['/autofs/cluster/transcend/MEG/voices/subj_manny/1/' goodtrialLog],6);

events_1=events_1(indgood_1,:);
events_2=events_2(indgood_2,:);
events_3=events_3(indgood_3,:);
events_4=events_4(indgood_4,:);
events_5=events_5(indgood_5,:);
events_6=events_6(indgood_6,:);

events_1(events_1(:,1)<3000,:)=[];
events_1(events_1(:,1)>durrFile-3000,:)=[];

events_2(events_2(:,1)<3000,:)=[];
events_2(events_2(:,1)>durrFile-3000,:)=[];

events_3(events_3(:,1)<3000,:)=[];
events_3(events_3(:,1)>durrFile-3000,:)=[];

events_4(events_4(:,1)<3000,:)=[];
events_4(events_4(:,1)>durrFile-3000,:)=[];

events_5(events_5(:,1)<3000,:)=[];
events_5(events_5(:,1)>durrFile-3000,:)=[];

events_6(events_6(:,1)<3000,:)=[];
events_6(events_6(:,1)>durrFile-3000,:)=[];


event1=[events_1(:,1)' events_2(:,1)'];

event2=[events_3(:,1)' events_4(:,1)'];

event3=[events_5(:,1)' events_6(:,1)'];

%%
low_event1=zeros(size(low_filter,1),size(low_filter,2),1200,length(event1));

for i=1:length(event1)

    low_event1(:,:,:,i)=(low_filter(:,:,event1(i):event1(i)+1199));

end
low_event1=reshape(low_event1,size(low_event1,1),size(low_event1,2),size(low_event1,3)*size(low_event1,4));



low_event2=zeros(size(low_filter,1),size(low_filter,2),1200,length(event2));

for i=1:length(event2)

    low_event2(:,:,:,i)=(low_filter(:,:,event2(i):event2(i)+1199));

end
low_event2=reshape(low_event2,size(low_event2,1),size(low_event2,2),size(low_event2,3)*size(low_event2,4));

low_event3=zeros(size(low_filter,1),size(low_filter,2),1200,length(event3));

for i=1:length(event3)

    low_event3(:,:,:,i)=(low_filter(:,:,event3(i):event3(i)+1199));

end
low_event3=reshape(low_event3,size(low_event3,1),size(low_event3,2),size(low_event3,3)*size(low_event3,4));

%%
hi_event1=zeros(size(hi_filter,1),size(hi_filter,2),1200,length(event1));

for i=1:length(event1)

    hi_event1(:,:,:,i)=(hi_filter(:,:,event1(i):event1(i)+1199));

end
hi_event1=reshape(hi_event1,size(hi_event1,1),size(hi_event1,2),size(hi_event1,3)*size(hi_event1,4));


hi_event2=zeros(size(hi_filter,1),size(hi_filter,2),1200,length(event2));

for i=1:length(event2)

    hi_event2(:,:,:,i)=(hi_filter(:,:,event2(i):event2(i)+1199));

end
hi_event2=reshape(hi_event2,size(hi_event2,1),size(hi_event2,2),size(hi_event2,3)*size(hi_event2,4));


hi_event3=zeros(size(hi_filter,1),size(hi_filter,2),1200,length(event3));

for i=1:length(event3)

    hi_event3(:,:,:,i)=(hi_filter(:,:,event3(i):event3(i)+1199));

end
hi_event3=reshape(hi_event3,size(hi_event3,1),size(hi_event3,2),size(hi_event3,3)*size(hi_event3,4));























