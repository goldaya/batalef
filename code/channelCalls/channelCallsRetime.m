function [ subzero ] = channelCallsRetime( k, j, d, testrun )
%CHANNELCALLSRETIME Change all time-data of channel calls for specific
%channel. Any call with time under 0 will be deleted
%   channelCallsRetime(k, j, delta, testrun)

    M1 = channelData(k,j,'Calls','Matrix','features');
    if isempty(M1)
        subzero = 0;
        return;
    end
    M2 = channelData(k,j,'Calls','Matrix','forLocalization');
    M3 = channelData(k,j,'Calls','Matrix','forBeam');
    
    M = [M1(:,13), M1(:,1), M1(:,5), M1(:,9), M2(:,1), M2(:,5), M2(:,9), M3(:,1), M3(:,5), M3(:,9)];
    a = min(M,[],2);
    a = a + d;    
    
    if isempty(find(a<=0,1))
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
    if d < 0
        channelCall.removeCalls(k,j,[0,-d]);
    end
    
    % retime
    N = channelData(k,j,'Calls','Count');
    for s = 1:N
        call = channelCall(k,j,s,'features',false);
        call.DetectionTime = call.DetectionTime + d;
        if ~(call.StartTime == 0)
            call.StartTime = call.StartTime + d;
            call.PeakTime  = call.PeakTime + d ;
            call.EndTime   = call.EndTime + d  ;
        end
        call.save();
        
        
    
        call = channelCall(k,j,s,'forLocalization',false);
        if call.StartTime > 0
            call.StartTime = call.StartTime + d;
            call.PeakTime  = call.PeakTime + d ;
            call.EndTime   = call.EndTime + d  ;
            call.save();
        end
        
        call = channelCall(k,j,s,'forBeam',false);
        if call.StartTime > 0
            call.StartTime = call.StartTime + d;
            call.PeakTime  = call.PeakTime + d ;
            call.EndTime   = call.EndTime + d  ;
            call.save();    
        end
    end
end