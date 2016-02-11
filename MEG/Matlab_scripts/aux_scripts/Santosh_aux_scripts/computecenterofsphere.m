function [ctr,r,hs]=computecenterofsphere(fiff_file)


% Compute Center of sphere from head digitization points
%
% USAGE: [ctr,r]=computecenterofsphere(fiff_file)
%
% INPUT:
%      fif File
%
% OUTPUT:
%       ctr= center
%       r=   radius
%
% Author: Sheraz Khan, 2010
%         Martinos Center
%         MGH, Boston, USA
% --------------------------- Script History ------------------------------
% SK 23-July-2010  Creation
% -------------------------------------------------------------------------

[info] = fiff_read_meas_info(fiff_file);


nhsp=length(info.dig);
hs=zeros(3,nhsp);
for k=1:nhsp
    hs(:,k)=double(info.dig(k).r);
end

hs=hs(:,~(hs(3,:)<0 & hs(2,:)>0)); % removing nose points



xmin=min(hs(1,:));
xmax=max(hs(1,:));
xradius=(xmax-xmin)/2;

ymin=min(hs(2,:));
ymax=max(hs(2,:));
yradius=(ymax-ymin)/2;

radius=mean([xradius yradius]);

zmax=max(hs(3,:));

% ctr=[mean([xmin xmax]); ...
%      mean([ymin ymax]); ...
%      zmax-radius];
 ctr=[0;0;zmax-radius];

xyzr=fminsearch('center_fsf',[ctr;radius],[],hs);
ctr=xyzr(1:3);
r=xyzr(4);





