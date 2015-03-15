function [ T, P ] = getChannelCallsTimes( k,j,timePosition )
%GETCHANNELCALLSTIMES Summary of this function goes here
%   k = file index
%   j = channel index
%   timePosition = 'start', 'peak' or 'end'.

    C = channelData(k,j,'Calls','Matrix');
    Fs = fileData(k,'Fs');
    
    switch timePosition
        case 'Detection'
            i = 1;
        case 'Start'
            i = 6;
        case 'Peak'
            i = 3;
        case 'End'
            i = 9;
    end
    
    P = C(:,i);
    T = P./Fs;
        
end

