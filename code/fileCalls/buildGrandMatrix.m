function [ GM, I, l ] = buildGrandMatrix( k, jb, sb, paramToUse, deviance )
%BUILDGRANDMATRIX Summary of this function goes here
%   Detailed explanation goes here

    % get all the little matrices and keep numbers
    refPoint = channelCallData(k,jb,sb,paramToUse,'Point');
        
    [~,MdP] = fileData(k,'Mics','MaxDiff');
    
    nChannels = fileData(k,'Channels','Count','NoValidation',true);
    I = cell(nChannels);
    P = cell(nChannels);
    L = cell(nChannels,nChannels);
    l = 0;
    for j = 1:nChannels
        if j==jb
            I{jb} = sb;
            l = l + 1;
        else
        
        % get the calls possible with regard to base call
        [~,points] = getChannelCallsTimes(k,j,timePosition);
        Ip = 1:length(points);
        dP = abs(points - refPoint);
        % possible calls indexes
        V1 = Ip(MdP(j,jb)*deviance-dP>0);
        % possible calls ref points
        P{j} = points(V1);
        I{j} = V1;
        l = l + length(V1);
        
        end
        
        
        if j == 1
            continue;
        end
        for j1 = 1:j-1
            m = MdP(j,j1);
            Ltemp = determineLogicalMatrix(P{j},P{j1},m);
            L{j,j1} = Ltemp;
        end
    end

    for j1 = 1:nChannels
        V = [];
        for j2 = 1:nChannels
            if j1 == j2
                n = length(I{j1});
                A = ones(n,n);
            elseif j1 <= j2
                A = L{j1,j2};
            else
                A = transpose(L{j2,j2});
            end
            V = [V,A];
        end
        GM = [GM;V];
    end
                
    
end

