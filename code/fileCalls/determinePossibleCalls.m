function [ logicVector, indexVector ] = determinePossibleCalls( k,j,a,b,timePosition,varargin )
%DETERMINPOSSIBLECALLS Summary of this function goes here
%   Detailed explanation goes here

    % extra parameters
    noFileCalls = getParFromVarargin('noFileCalls',varargin);
    
    
    [~,points] = getChannelCallsTimes(k,j,timePosition);
    A = points > a;
    B = points < b;
    logicVector = A.*B;
    if noFileCalls
        for s = 1:length(A)
            if logicVector(s) 
                if channelCallData(k,j,s,'FileCall')~=0
                    logicVector(s) = 0 ;
                end
            end
        end
    end
    I = 1:length(A);
    indexVector = I(logicVector > 0);
    
end

