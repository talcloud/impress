function [labrep rsrcind lsrcind] = do_labelmean(label,inv,sol,isMean)

% Computes the mean over a large label after taking geometry into account
% 
% USAGE:
%    labrep = labelmean(label,inv,sol,projorflip);
%          or
%    labrep = labelmean(label,inv,sol)
% INPUTS:
%  inv - An MNE inv structure (See MNE manual)
%  label - A .label file corresponding to the source space in inv.src
%  sol - A matrix containing the inverse solution:-
%               nverts x time/freq x [epochs], [] = optional
%  [projorflip] - 0 for projecting to the reference direction
%    and 1 for just flipping the sign of vertices in 1 hemisphere of
%    directions. Default is 1. [] = optional
%
%   The reference direction is the principal right singular
%   vector direction of the matrix of normal orientations:
%      See the MNE 2.6 manual about the --align_z flag of
%      mne_compute_raw_inverse  :)
%
% Output:
%  labrep - An average over the vertices after projection or flipping
%
%  IMPORTANT: This function DOES NOT check thoroughly to see if the labels
%  and solutions actually belong to the source-space in inv.
%
%--------------
% Dependancies:
%   Calls the read_label function from the freesurfer matlab toolbox


labverts = read_label('',label);
% Getting only the vertex numbers. Read the help for read_label.
% Vertex numbers are zero based.
labverts = 1+squeeze(labverts(:,1)); 

[~,~,lsrcind] = intersect(labverts,inv.src(1).vertno);
[~,~,rsrcind] = intersect(labverts,inv.src(2).vertno);

if(strfind(label,'lh.'))
    srcind = lsrcind;
elseif(strfind(label,'rh.'))
    srcind = inv.src(1).nuse + int32(rsrcind);
end

% % Refernce direction set to orientation of most energetic source
% energy = sum(sum(sol(srcind,:,:).^2,2),3);
% [maxpow,refind] = max(energy);
% refdir = inv.source_nn(refind);

% Using the right signular vector direction
orientmat = zeros(numel(srcind),3);
for j = 1:numel(srcind)
    orientmat(j,:) = inv.source_nn(srcind(j),:);
end
[~,~,V] = svd(orientmat); 

refdir = V(:,1)';


projorflip = 1;


if(projorflip == 1)
    multfactor = sign(refdir*inv.source_nn');
elseif(projorflip == 0)
    multfactor = refdir*inv.source_nn';
else
    error(me,'projorflip should be 0 or 1');
end

sol=sol(srcind,:,:);
multfactor=multfactor(srcind);

for j = 1:size(sol,1)
    sol(j,:,:) = sol(j,:,:)*multfactor(j);
end


% Changed SK 11dec 2010
if isMean
labrep = squeeze(mean(single(sol))); 
else
labrep = sol;
end


