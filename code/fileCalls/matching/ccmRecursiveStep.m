function [ Vmax, Rmax ] = ccmRecursiveStep( V, U )
%CCMRECURSIVESTEP -INTERNAL- find channel calls matching
% V - the vector of channel calls
% U - vector of remaining channels to check
% R - maximal rank

    Rmax = 0;
    
    nU = length(U);
    if nU == 1
    else
        Utag = U(2:nU);
    end
    
    %W = vector of possible calls in channel U(1) possible for V
    for i = 1:length(W)
        Vw = V;
        Vw(U(1)) = W(i);
        R = ccmRecursiveStep(Vw,Utag);
        if R = nV
            V = Vw;
            return;
        elseif R > Rmax
            
    end


end

