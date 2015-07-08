function fileCallChangeChannelCallIndex( k, j, s)
%FILECALLCHANGECHANNELCALLINDEX Delete or change the index of a channel 
%call in the file call data.
%   When new_s is 0, the channel call entry is considered empty
%   If changed a file call, 

   
    for a = 1:fileData(k,'Calls','Count')
        call = fileCall(k,a);
        call.changeChannelCallsAfterRemoval(j,s)
    end

end