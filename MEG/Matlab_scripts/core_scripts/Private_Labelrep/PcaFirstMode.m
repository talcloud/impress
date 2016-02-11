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