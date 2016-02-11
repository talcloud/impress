function Fs = bst_scout_value(F, fcn, isNorm, nComp)
% BST_SCOUT_VALUE: Combine Ns time series using the given function. Used to get scouts/clusters values.
%
% INPUTS:
%     - F      : [Nsources * Ncomponents, Ntime], double matrix
%     - fcn    : function to use to combine the Ns time series
%     - isNorm : If 1, and if there is more than one component per vertex: return only one value per vertex (PCA)
%     - nComp  : Number of components per vertex in matrix F
% @=============================================================================
% This software is part of the Brainstorm software:
% http://neuroimage.usc.edu/brainstorm
% 
% Copyright (c)2000-2011 Brainstorm by the University of Southern California
% This software is distributed under the terms of the GNU General Public License
% as published by the Free Software Foundation. Further details on the GPL
% license can be found at http://www.gnu.org/copyleft/gpl.html.
% 
% FOR RESEARCH PURPOSES ONLY. THE SOFTWARE IS PROVIDED "AS IS," AND THE
% UNIVERSITY OF SOUTHERN CALIFORNIA AND ITS COLLABORATORS DO NOT MAKE ANY
% WARRANTY, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
% MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, NOR DO THEY ASSUME ANY
% LIABILITY OR RESPONSIBILITY FOR THE USE OF THIS SOFTWARE.
%
% For more information type "brainstorm license" at command prompt.
% =============================================================================@
%
% Authors: Sylvain Baillet, Francois Tadel, 2010-2011

% ===== PARSE INPUTS =====
if (nargin < 3) || isempty(isNorm)
    isNorm = 1;
end
if (nargin < 4) || isempty(nComp)
    nComp = 1;
end

% ===== MULTIPLE COMPONENTS =====
% Reshape F matrix in 3D: [nRow, nTime, nComp]
switch (nComp)
    case 2
        F = cat(3, F(1:2:end,:), F(2:2:end,:));
    case 3
        F = cat(3, F(1:3:end,:), F(2:3:end,:), F(3:3:end,:));
end
nRow  = size(F,1);
nTime = size(F,2);

% ===== COMBINE ALL VERTICES =====
switch (lower(fcn))       
    % MEAN : Average of the patch activity at each time instant
    case 'mean'
        Fs = mean(F,1);
        
    % MEAN_NORM : Average of the norms of all the vertices each time instant 
    % If only one components: computes mean(abs(F)) => Compatibility with older versions
    case 'mean_norm'
        if (nComp == 1)
            % Average absolute values
            Fs = mean(abs(F),1);
        else
            % Average norms
            Fs = mean(sqrt(sum(F.^2, 3)), 1);
        end
        
    % MAX : Strongest at each time instant (in absolue values)
    case 'max'
        % If one component: max(abs)
        if (nComp == 1)
            % Get maximum absolute values
            [Fs, iMax] = max(abs(F),[],1);
            % Get the sign of each maximum
            [Z(1,:,:),Y(1,:,:)] = meshgrid(1:nComp, 1:nTime);
            iF = sub2ind(size(F), iMax, Y, Z);
            Fs = sign(F(iF)) .* Fs;
        else
            % Get the maximum of the norm across orientations, at each time
            [tmp__, iMax] = max(sum(F.^2, 3), [], 1);
            % Build indices of the values to read
            iMaxF = sub2ind(size(F), [iMax,iMax,iMax], ...
                                     [1:nTime,1:nTime,1:nTime], ...
                                     [1*ones(1,nTime), 2*ones(1,nTime), 3*ones(1,nTime)]);
            Fs = reshape(F(iMaxF), 1, nTime, 3);
        end

    % POWER: Average of the square of the all the signals
    case 'power'
        if (nComp == 1)
            Fs = mean(F.^2, 1);
        else
            Fs = mean(sum(F.^2, 3), 1);
        end

    % PCA : Display first mode of PCA of time series within each scout region
    case 'pca'
        % Signal decomposition
        Fs = zeros(1, nTime, nComp);
        for i = 1:nComp
            Fs(1,:,i) = PcaFirstMode(F(:,:,i));
        end
        
    % FAST PCA : Display first mode of PCA of time series within each scout region
    case 'fastpca'
        % Reduce dimensions first
        nMax = 50; % Maximum number of variables to run the PCA on
        if nRow > nMax
            % Norm or not
            if (nComp == 1)
                Fn = abs(F);
            else
                Fn = sqrt(sum(F.^2, 3));
            end
            % Find the nMax most powerful/spiky source time series
            %powF = sum(F.*F,2);
            powF = max(Fn,[],2) ./ (mean(Fn,2) + eps*min(Fn(:)));
            [tmp__, isF] = sort(powF,'descend');
            F = F(isF(1:nMax),:,:);
        end
        % Signal decomposition
        Fs = zeros(1, nTime, nComp);
        for i = 1:nComp
            Fs(1,:,i) = PcaFirstMode(F(:,:,i));
        end
        
    % STAT : Average values as if they were statistical results => ignore all the zero-values
    case 'stat'
        % Get the number of samples per time point
        w = sum(F~=0, 1);
        w(w == 0) = 1;
        % Divide each time point by the number of valid samples
        Fs = bst_bsxfun(@rdivide, sum(F,1), w);
        
    % ALL : Return all the time series (do not combine them)
    case {'all', 'none'}
        Fs = F;
end

% ===== COMBINE ALL ORIENTATIONS (PCA) =====
% If there are more than one component in output
if (size(Fs,3) > 1)
    % Compute the PCA of all the components
    if isNorm
        % Fs = sqrt(sum(Fs.^2, 3));
        F = Fs;
        Fs = zeros(size(Fs,1), size(Fs,2));
        % For each vertex: Signal decomposition
        for i = 1:size(Fs,1)
            Fs(i,:) = PcaFirstMode(squeeze(F(i,:,:))');
        end
    % Else: remap the components in a 2D matrix
    else
        F = Fs;
        Fs = zeros(nRow * nComp, nTime);
        switch (size(Fs,3))
            case 2
                Fs(1:2:end) = F(:,:,1);
                Fs(2:2:end) = F(:,:,2);
            case 3
                Fs(1:3:end) = F(:,:,1);
                Fs(2:3:end) = F(:,:,2);
                Fs(3:3:end) = F(:,:,3);
        end
    end
end
end


%% ===== PCA: FIRT MODE =====
% function F = PcaFirstMode(F)
% %     % Remove average over time for each row
% %     Fmean = mean(F,2);
% %     F = bst_bsxfun(@minus, F, Fmean);
%     % Signal decomposition
%     % [U,S,V] = svds(F, 1, 'L');   % NOT USING SVDS BECAUSE RESULT IS RANDOM
%     [U,S,V] = svd(F, 'econ');    
%     % Keep the first mode, keep the original sign
%     F = sign(sum(U(:,1))) * S(1,1) * V(:,1)';
% end

function F = PcaFirstMode(F)
     % Remove average over time for each row
     Fmean = mean(F,2);
     F = bst_bsxfun(@minus, F, Fmean);
    % Signal decomposition
    [U,S,V] = svds(F, 1, 'L');  
    %[U,S,V] = svd(F, 'econ');   
    % Keep the first mode, keep the original sign
    %F = sign(sum(U(:,1))) * S(1,1) * V(:,1)';

    %Find where the first component projects the most over original dimensions
    [tmp__, nmax] = max(abs(U(:,1))); 
    % What's the sign of absolute max amplitude along this dimension?
    [tmp__, i_omaxx] = max(abs(F(nmax,:)));
    sign_omaxx = sign(F(nmax,i_omaxx));
    % Sign of maximum in first component time series
    [Vmaxx, i_Vmaxx] = max(abs(V(:,1)));
    sign_Vmaxx = sign(V(i_Vmaxx,1));
    % Reconcile signs
    F = sign_Vmaxx * sign_omaxx * S * V(:,1)';
    F = F + Fmean(nmax);
end


