function proj=computeProj(raw)

projs=raw.info.projs;

for k = 1:length(projs)
    projs(k).active=1;   
end

proj = mne_make_projector(projs,raw.info.ch_names);
proj=proj(1:306,1:306);