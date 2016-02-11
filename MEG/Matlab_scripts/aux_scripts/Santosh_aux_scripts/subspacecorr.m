
%% separating the magnetometer and the gradiometer in the forward operator

forward_operator=fwd.sol.data;
q=1;
s=1;
for r=1:306,
    
    grad=mod(r,3);
    if grad==0,
    magnetometer(q,:)=operator(r,:);
    q=q+1;
    else
    gradiometer(s,:)=operator(r,:);
    s=s+1;
    end
end
%% QR minimization gradiometer


[Q1,R1] = qr(gradiometer);

%% QR minimization of projection vectors

[P1,N1]=qr(info.projs(1,1).data.data);
[P2,N2]=qr(info.projs(1,2).data.data);
[P3,N3]=qr(info.projs(1,3).data.data);
[P4,N4]=qr(info.projs(1,4).data.data);
[P5,N5]=qr(info.projs(1,5).data.data);
[P6,N6]=qr(info.projs(1,6).data.data);
[P7,N7]=qr(info.projs(1,7).data.data);
