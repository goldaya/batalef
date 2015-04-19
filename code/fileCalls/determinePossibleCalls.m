function [ logicVector, indexVector ] = determinePossibleCalls( k,j,a,b,timePosition,varargin )
%DETERMINPOSSIBLECALLS Summary of this function goes here
%   Detailed explanation goes here

    % extra parameters
    noFileCalls = getParFromVarargin('noFileCalls',varargin);
    
    Fs = fileData(k,'Fs');
    C = channelData(k,j,'Calls','ForLocalization');
    switch timePosition
        case 'Start'
            points = round(cell2mat(C(:,1)).*Fs);
        case 'Peak'
            points = round(cell2mat(C(:,5)).*Fs);
        case 'End'
            points = round(cell2mat(C(:,9)).*Fs);
    end        
    
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

