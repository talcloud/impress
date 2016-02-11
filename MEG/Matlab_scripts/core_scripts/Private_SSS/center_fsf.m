function cost=center_fsf(xyzr,hs)


ctr=xyzr(1:3);
r=xyzr(4);

nhs=size(hs,2);
hs=hs-repmat(ctr,1,nhs);
cost=sum((sqrt(sum(hs.^2))-r*ones(1,nhs)).^2);