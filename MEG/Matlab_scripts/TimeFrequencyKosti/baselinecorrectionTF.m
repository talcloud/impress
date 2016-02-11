function TF=baselinecorrectionTF(TF,ind1,ind2,eeglabstyle)

TF_mean=squeeze(mean((TF(:,:,:,ind1:ind2)),4));
TF_mean=(repmat(TF_mean,[ 1 1 1 size(TF,4)]));

TF_std=squeeze(std((TF(:,:,:,ind1:ind2)),0,4));
TF_std=(repmat(TF_std,[ 1 1 1 size(TF,4)]));

if eeglabstyle
    TF=10.*log10(TF./TF_mean);
    
else
    TF=(TF-TF_mean)./TF_std;
end






