function [ subzero ] = fileCallsRetime( k, d, testrun )
%FILECALLSRETIME Change all time-data of file calls for specific
%file. Any call with time under 0 will be deleted

    % get times of file calls
    times = fileData(k,'Calls','Times');
    forDeletion = 1:fileData(k,'Calls','Count');
    forDeletion = forDeletion(times+d<=0);
    
    if isempty(forDeletion)
        subzero = false;
    else
        subzero = true;
    end
        
    if testrun
        return;
    end
    
    
    % delete subzero calls
    deleteFileCall( k, forDeletion )
    
    % retime remaining calls
    for a = 1:fileData(k,'Calls','Count') 
        call = fileCall(k,a);
        call.Time = call.Time + d;
        call.save();
    end
    

end

