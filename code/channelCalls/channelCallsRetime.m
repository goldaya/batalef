function [ subzero ] = channelCallsRetime( k, j, d, testrun )
%CHANNELCALLSRETIME Change all time-data of channel calls for specific
%channel. Any call with time under 0 will be deleted
%   channelCallsRetime(k, j, delta, testrun)

    if ~exists('testrun','var')
        testrun = false;
    end
    
    M1 = channelData(k,j,'Calls','Matrix','features');
    M2 = channelData(k,j,'Calls','Matrix','forLocalization');
    M3 = channelData(k,j,'Calls','Matrix','forBeam');
    
    M = [M1(:,13), M1(:,1), M1(:,5), M1(:,9), M2(:,1), M2(:,5), M2(:,9), M3(:,1), M3(:,5), M3(:,9)];
    a = min(M,[],2);
    a = a - d;    
    
    if isempty(a<=0)
        subzero = false;
    else
        subzero = true;
    end
        
        
    % TEST Run
    if testrun
        return;
    end
    
    % DO Phase
    % remove early calls
    channelCall.removeCalls(k,j,[0,d]);
    
    % retime
    
end