function [cD cA] = getDWT(X,N,Name)


%No DWT available for Morlet - therefore perform CWT:
if(strcmp(Name,'morl'))
    
    c = cwt(X,1:N,'morl');
    
    cD = c;
    cA = c;
else
    %Preform wavelet decomposition
    
    [c,l] = wavedec(X,N,Name);
    
    %Reorder the details based on the structure of the wavelet
    %decomposition (see help in wavedec.m)
    len = length(X);
    cD = zeros(N,len);
    for k = 1:N
        d = detcoef(c,l,k);
        d = d(:)';
        d = d(ones(1,2^k),:);
        cD(k,:) = wkeep1(d(:)',len);
    end
    cD =  cD(:);
    
    %Space cD according to spacing of floating point numbers:
    I = find(abs(cD)<sqrt(eps));
    cD(I) = zeros(size(I));
    cD = reshape(cD,N,len);
    % cD = wcodemat(cfd,nbcol,'row');
    
    
    %Reorder the approximations based on the structure of the wavelet
    %decomposition (see help in wavedec.m)
    len = length(X);
    cA = zeros(N,len);
    for k = 1:N
        a = appcoef(c,l,Name,k);
        a = a(:)';
        a = a(ones(1,2^k),:);
        cA(k,:) = wkeep1(a(:)',len);
    end
    cA =  cA(:);
    I = find(abs(cA)<sqrt(eps));
    cA(I) = zeros(size(I));
    cA = reshape(cA,N,len);
end