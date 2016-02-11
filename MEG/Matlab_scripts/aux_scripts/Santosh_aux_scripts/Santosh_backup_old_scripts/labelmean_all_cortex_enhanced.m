function [labrep] = labelmean_all_cortex_enhanced(subj,cfg,inv,sol,fcn,labelyear)

cfg.MRIdir=strcat('/autofs/space/calvin_001/marvin/1/users/MRI/WMA/recons/',subj,'/',labelyear,'_labels');
count=1;
cd(cfg.MRIdir);




switch (labelyear)

    case '2009'
label={'lh.G_Ins_lg_and_S_cent_ins.label',1;'lh.G_and_S_cingul-Ant.label',2;'lh.G_and_S_cingul-Mid-Ant.label',3;'lh.G_and_S_cingul-Mid-Post.label',4;'lh.G_and_S_frontomargin.label',5;'lh.G_and_S_occipital_inf.label',6;'lh.G_and_S_paracentral.label',7;'lh.G_and_S_subcentral.label',8;'lh.G_and_S_transv_frontopol.label',9;'lh.G_cingul-Post-dorsal.label',10;'lh.G_cingul-Post-ventral.label',11;'lh.G_cuneus.label',12;'lh.G_front_inf-Opercular.label',13;'lh.G_front_inf-Orbital.label',14;'lh.G_front_inf-Triangul.label',15;'lh.G_front_middle.label',16;'lh.G_front_sup.label',17;'lh.G_insular_short.label',18;'lh.G_oc-temp_lat-fusifor.label',19;'lh.G_oc-temp_med-Lingual.label',20;'lh.G_oc-temp_med-Parahip.label',21;'lh.G_occipital_middle.label',22;'lh.G_occipital_sup.label',23;'lh.G_orbital.label',24;'lh.G_pariet_inf-Angular.label',25;'lh.G_pariet_inf-Supramar.label',26;'lh.G_parietal_sup.label',27;'lh.G_postcentral.label',28;'lh.G_precentral.label',29;'lh.G_precuneus.label',30;'lh.G_rectus.label',31;'lh.G_subcallosal.label',32;'lh.G_temp_sup-G_T_transv.label',33;'lh.G_temp_sup-Lateral.label',34;'lh.G_temp_sup-Plan_polar.label',35;'lh.G_temp_sup-Plan_tempo.label',36;'lh.G_temporal_inf.label',37;'lh.G_temporal_middle.label',38;'lh.Lat_Fis-ant-Horizont.label',39;'lh.Lat_Fis-ant-Vertical.label',40;'lh.Lat_Fis-post.label',41;'lh.Pole_occipital.label',42;'lh.Pole_temporal.label',43;'lh.S_calcarine.label',44;'lh.S_central.label',45;'lh.S_cingul-Marginalis.label',46;'lh.S_circular_insula_ant.label',47;'lh.S_circular_insula_inf.label',48;'lh.S_circular_insula_sup.label',49;'lh.S_collat_transv_ant.label',50;'lh.S_collat_transv_post.label',51;'lh.S_front_inf.label',52;'lh.S_front_middle.label',53;'lh.S_front_sup.label',54;'lh.S_interm_prim-Jensen.label',55;'lh.S_intrapariet_and_P_trans.label',56;'lh.S_oc-temp_lat.label',57;'lh.S_oc-temp_med_and_Lingual.label',58;'lh.S_oc_middle_and_Lunatus.label',59;'lh.S_oc_sup_and_transversal.label',60;'lh.S_occipital_ant.label',61;'lh.S_orbital-H_Shaped.label',62;'lh.S_orbital_lateral.label',63;'lh.S_orbital_med-olfact.label',64;'lh.S_parieto_occipital.label',65;'lh.S_pericallosal.label',66;'lh.S_postcentral.label',67;'lh.S_precentral-inf-part.label',68;'lh.S_precentral-sup-part.label',69;'lh.S_suborbital.label',70;'lh.S_subparietal.label',71;'lh.S_temporal_inf.label',72;'lh.S_temporal_sup.label',73;'lh.S_temporal_transverse.label',74;'rh.G_Ins_lg_and_S_cent_ins.label',75;'rh.G_and_S_cingul-Ant.label',76;'rh.G_and_S_cingul-Mid-Ant.label',77;'rh.G_and_S_cingul-Mid-Post.label',78;'rh.G_and_S_frontomargin.label',79;'rh.G_and_S_occipital_inf.label',80;'rh.G_and_S_paracentral.label',81;'rh.G_and_S_subcentral.label',82;'rh.G_and_S_transv_frontopol.label',83;'rh.G_cingul-Post-dorsal.label',84;'rh.G_cingul-Post-ventral.label',85;'rh.G_cuneus.label',86;'rh.G_front_inf-Opercular.label',87;'rh.G_front_inf-Orbital.label',88;'rh.G_front_inf-Triangul.label',89;'rh.G_front_middle.label',90;'rh.G_front_sup.label',91;'rh.G_insular_short.label',92;'rh.G_oc-temp_lat-fusifor.label',93;'rh.G_oc-temp_med-Lingual.label',94;'rh.G_oc-temp_med-Parahip.label',95;'rh.G_occipital_middle.label',96;'rh.G_occipital_sup.label',97;'rh.G_orbital.label',98;'rh.G_pariet_inf-Angular.label',99;'rh.G_pariet_inf-Supramar.label',100;'rh.G_parietal_sup.label',101;'rh.G_postcentral.label',102;'rh.G_precentral.label',103;'rh.G_precuneus.label',104;'rh.G_rectus.label',105;'rh.G_subcallosal.label',106;'rh.G_temp_sup-G_T_transv.label',107;'rh.G_temp_sup-Lateral.label',108;'rh.G_temp_sup-Plan_polar.label',109;'rh.G_temp_sup-Plan_tempo.label',110;'rh.G_temporal_inf.label',111;'rh.G_temporal_middle.label',112;'rh.Lat_Fis-ant-Horizont.label',113;'rh.Lat_Fis-ant-Vertical.label',114;'rh.Lat_Fis-post.label',115;'rh.Pole_occipital.label',116;'rh.Pole_temporal.label',117;'rh.S_calcarine.label',118;'rh.S_central.label',119;'rh.S_cingul-Marginalis.label',120;'rh.S_circular_insula_ant.label',121;'rh.S_circular_insula_inf.label',122;'rh.S_circular_insula_sup.label',123;'rh.S_collat_transv_ant.label',124;'rh.S_collat_transv_post.label',125;'rh.S_front_inf.label',126;'rh.S_front_middle.label',127;'rh.S_front_sup.label',128;'rh.S_interm_prim-Jensen.label',129;'rh.S_intrapariet_and_P_trans.label',130;'rh.S_oc-temp_lat.label',131;'rh.S_oc-temp_med_and_Lingual.label',132;'rh.S_oc_middle_and_Lunatus.label',133;'rh.S_oc_sup_and_transversal.label',134;'rh.S_occipital_ant.label',135;'rh.S_orbital-H_Shaped.label',136;'rh.S_orbital_lateral.label',137;'rh.S_orbital_med-olfact.label',138;'rh.S_parieto_occipital.label',139;'rh.S_pericallosal.label',140;'rh.S_postcentral.label',141;'rh.S_precentral-inf-part.label',142;'rh.S_precentral-sup-part.label',143;'rh.S_suborbital.label',144;'rh.S_subparietal.label',145;'rh.S_temporal_inf.label',146;'rh.S_temporal_sup.label',147;'rh.S_temporal_transverse.label',148;};

    case '2005'
label={'lh.bankssts.label',1;'lh.caudalanteriorcingulate.label',2;'lh.caudalmiddlefrontal.label',3;'lh.corpuscallosum.label',4;'lh.cuneus.label',5;'lh.entorhinal.label',6;'lh.frontalpole.label',7;'lh.fusiform.label',8;'lh.inferiorparietal.label',9;'lh.inferiortemporal.label',10;'lh.insula.label',11;'lh.isthmuscingulate.label',12;'lh.lateraloccipital.label',13;'lh.lateralorbitofrontal.label',14;'lh.lingual.label',15;'lh.medialorbitofrontal.label',16;'lh.middletemporal.label',17;'lh.paracentral.label',18;'lh.parahippocampal.label',19;'lh.parsopercularis.label',20;'lh.parsorbitalis.label',21;'lh.parstriangularis.label',22;'lh.pericalcarine.label',23;'lh.postcentral.label',24;'lh.posteriorcingulate.label',25;'lh.precentral.label',26;'lh.precuneus.label',27;'lh.rostralanteriorcingulate.label',28;'lh.rostralmiddlefrontal.label',29;'lh.superiorfrontal.label',30;'lh.superiorparietal.label',31;'lh.superiortemporal.label',32;'lh.supramarginal.label',33;'lh.temporalpole.label',34;'lh.transversetemporal.label',35;'rh.bankssts.label',36;'rh.caudalanteriorcingulate.label',37;'rh.caudalmiddlefrontal.label',38;'rh.corpuscallosum.label',39;'rh.cuneus.label',40;'rh.entorhinal.label',41;'rh.frontalpole.label',42;'rh.fusiform.label',43;'rh.inferiorparietal.label',44;'rh.inferiortemporal.label',45;'rh.insula.label',46;'rh.isthmuscingulate.label',47;'rh.lateraloccipital.label',48;'rh.lateralorbitofrontal.label',49;'rh.lingual.label',50;'rh.medialorbitofrontal.label',51;'rh.middletemporal.label',52;'rh.paracentral.label',53;'rh.parahippocampal.label',54;'rh.parsopercularis.label',55;'rh.parsorbitalis.label',56;'rh.parstriangularis.label',57;'rh.pericalcarine.label',58;'rh.postcentral.label',59;'rh.posteriorcingulate.label',60;'rh.precentral.label',61;'rh.precuneus.label',62;'rh.rostralanteriorcingulate.label',63;'rh.rostralmiddlefrontal.label',64;'rh.superiorfrontal.label',65;'rh.superiorparietal.label',66;'rh.superiortemporal.label',67;'rh.supramarginal.label',68;'rh.temporalpole.label',69;'rh.transversetemporal.label',70;};


end

if isfield(cfg,'generate_labels')
[cfg]=batchlabels(subj,cfg,labelyear);
end

if isfield(cfg,'specific_labels')

   label=cfg.specific_labels; 
    
end



for i=1:length(label)

    try
 
    
    
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
%--------------
% Hari M. Bharadwaj July 21, 2009
%--------------

me = 'HARI:labelmean';
labverts = read_label('',label{i});
% Getting only the vertex numbers. Read the help for read_label.
% Vertex numbers are zero based.
labverts = 1+squeeze(labverts(:,1)); 
inv=mne_read_inverse_operator(inv);
[t1,t2,lsrcind] = intersect(labverts,inv.src(1).vertno);
[t1,t2,rsrcind] = intersect(labverts,inv.src(2).vertno);

if(strfind(label{i},'lh.'))
    srcind = lsrcind;
elseif(strfind(label{i},'rh.'))
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
[t1,t2,V] = svd(orientmat); 

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



labrep = squeeze(mean(single(sol)));

switch (lower(fcn))       
    % MEAN : Average of the patch activity at each time instant
    case 'mean'
        labrep= mean(sol,1);
        
    % MEAN_NORM : Average of the norms of all the vertices each time instant 
    % If only one components: computes mean(abs(F)) => Compatibility with older versions

        
    % MAX : Strongest at each time instant (in absolue values)
    case 'max'
        % If one component: max(abs)
        
            % Get maximum absolute values
            [labrep, iMax] = max(abs(sol),[],1);
            % Get the sign of each maximum
            [Z(1,:,:),Y(1,:,:)] = meshgrid(1, 1:nTime);
            iF = sub2ind(size(sol), iMax, Y, Z);
            labrep= sign(sol(iF)) .* labrep;


    % POWER: Average of the square of the all the signals
    case 'power'
     
            labrep = mean(sol.^2, 1);

    % PCA : Display first mode of PCA of time series within each scout region
    case 'pca'
        % Signal decomposition
        labrep = zeros(1, nTime, 1);
    
            labrep(1,:,1) = PcaFirstMode(sol(:,:,1));
      
        
    % FAST PCA : Display first mode of PCA of time series within each scout region
    case 'fastpca'
        % Reduce dimensions first
        nMax = 50; % Maximum number of variables to run the PCA on
        if nRow > nMax
            % Norm or not
         
                Fn = abs(sol);

            % Find the nMax most powerful/spiky source time series
            %powF = sum(F.*F,2);
            powF = max(Fn,[],2) ./ (mean(Fn,2) + eps*min(Fn(:)));
            [tmp__, isF] = sort(powF,'descend');
            sol = sol(isF(1:nMax),:,:);
        end
        % Signal decomposition
        s = zeros(1, nTime, nComp);
      
            labrep(1,:,1) = PcaFirstMode(sol(:,:,1));
      
        

    case {'all', 'none'}
        labrep = sol;
end
    catch
        cfg.failed_labels(count)=subj;
        count=count+1;
        continue
    end

end
%labrep = sol;
