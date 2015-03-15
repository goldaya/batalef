function [ seqs ] = suggestSeqs2( sBase,jBase,k, timePointToUse )
%SUGGESTSEQS2 Summary of this function goes here
%   Detailed explanation goes here

    seqs = [];
    
    % get usable mics in localization
    U = fileData(k,'Mics','LocalizationUsage','NoValidation',true);
    
    % check base channel is usable
    if ~U(jBase)        
        return;
    end
    
    % some parameters
    nChannels = length(U);
    dev = getParam('fileCalls:matching:triangleMaxError');
    refPoint = channelCallData(k,jBase,sBase,timePointToUse,'Point');  
    [~,MdP] = fileData(k,'Mics','MaxDiff');
    MdP = MdP*dev;
    a1 = ones(nChannels,1);

    % for each usable mic, get possible calls
    channelCalls = cell(nChannels,1);
    channelCallsPoints = cell(nChannels,1);
    for j = 1:nChannels
        if ~U(j)
            continue;
        elseif j==jBase
            channelCalls{j} = sBase;
            v = zeros(sBase,1);
            v(sBase) = refPoint;
            channelCallsPoints{j} = v;
        else
            dp = round(MdP(jBase,j));
            a = refPoint - dp;
            b = refPoint + dp;            
            [~,V] = determinePossibleCalls(k,j,a,b,timePointToUse,'noFileCalls',true);
            if ~isempty(V)
                v = zeros(max(V),1);
                for i = 1:length(V)
                    v(V(i)) = channelCallData(k,j,V(i),timePointToUse,'Point');
                end
                channelCalls{j} = V;
                channelCallsPoints{j} = v;
            end
        end
    end
    
    % get matrix of mics subarrays + narrow subarrays matrix (must always
    % have the base channel)
    L1 = fileData(k,'Mics','Subarrays','NoValidation',true);
    L2 = transpose(cell2mat(transpose(L1(:,2))));
    subarrays = L2(L2(:,jBase),:);
    
    % for each subarray, for each channel-calls seq: get the channel calls time
    idx = 1;
    for i = 1:size(subarrays,1)
        subarray = subarrays(i,:);
        subarraySeqs = getSubarraySeqs(subarray,channelCalls);
        if isempty(subarraySeqs)
            continue;
        end
        
        for l = 1:size(subarraySeqs,1)
            subarraySeq = subarraySeqs(l,:);
            % build matrix of differences
            v = NaN(1,nChannels);
            for j=1:nChannels
                if subarraySeq(j)==0
                    %v(j)=NaN;
                else
                    v(j)=channelCallsPoints{j}(subarraySeq(j));
                end
            end
               A = a1 * v ;
            B = abs(A - transpose(A));
                
            % compare
            if max(max(B-MdP))<=0
                
                % add to possible seqs
                seqs{idx} = subarraySeq;
                idx = idx+1;
                
            end
        end
    end
    
    % put most dense seqs first
    sz = size(seqs);
    if sz(1) > 1
        seqs = flipud(seqs);
    elseif sz(2) > 1
        seqs = fliplr(seqs);
    end

end

