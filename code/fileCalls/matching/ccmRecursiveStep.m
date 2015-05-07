function [ Vmax, Rmax ] = ccmRecursiveStep( V, U, k, dev )
%CCMRECURSIVESTEP -INTERNAL- find channel calls matching


    Rmax = 0;
    Vmax = V;
    
    nU = length(U);
    if nU == 1
    else
        Utag = U(2:nU);
    end
    
    
    W = ccmGetPossibleCalls(k,V,U(1),dev);
    for i = 1:length(W)
        Vstep = V;
        Vstep(U(1)) = W(i);
        if nU == 1
            Rstep = 0;
        else
            [Vstep,Rstep] = ccmRecursiveStep(Vstep,Utag,k,dev);
        end
        
        % add rank when appropriate
        if W(i) == 0
        else
            Rstep = Rstep + 1;
        end
        % should add clause on mic-array depth
        
        % get bset
        if Rstep > Rmax
            Vmax = Vstep;
            Rmax = Rstep;
            if Rstep == length(U)
                return;
            end
        end
            
    end

end