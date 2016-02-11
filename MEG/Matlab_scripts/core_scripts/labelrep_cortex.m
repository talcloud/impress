function [cortex] = labelrep_cortex(data,fname_inv,nave,dSPM,pickNormal)


if ~exist('pickNormal','var')
    
    pickNormal=0;
    
end


FIFF=fiff_define_constants;




lambda2 = 1/9;






inv = mne_read_inverse_operator(fname_inv);



inv = mne_prepare_inverse_operator(inv,nave,lambda2,dSPM);




nepochs = size(data,3);
ntime = size(data,2);

cortex=zeros(inv.nsource,ntime,nepochs,'single');




    
for j = 1:nepochs

        trans = diag(sparse(inv.reginv))*inv.eigen_fields.data*inv.whitener*inv.proj*double(data(:,:,j));
        if (isfield(inv,'eigen_leads_weighted'))
            if(inv.eigen_leads_weighted)


                sol   = inv.eigen_leads.data*trans;
            else


                sol   = diag(sparse(sqrt(inv.source_cov.data)))*inv.eigen_leads.data*trans;
            end
        else


            sol   = diag(sparse(sqrt(inv.source_cov.data)))*inv.eigen_leads.data*trans;
        end

        if inv.source_ori == FIFF.FIFFV_MNE_FREE_ORI
            
            if pickNormal
                sol=sol(3:3:end,:);
            else

            sol1 = zeros(size(sol,1)/3,size(sol,2));
            for k = 1:size(sol,2)
                sol1(:,k) = sqrt(mne_combine_xyz(sol(:,k)));
            end
            sol = sol1;
            end
        end
        if(dSPM)
            %fprintf(1,'Doing dSPM...');
            sol = inv.noisenorm*sol;
        end

        cortex(:,:,j) =single(sol);
end

