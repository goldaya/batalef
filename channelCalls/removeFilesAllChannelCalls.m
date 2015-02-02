function [  ] = removeFilesAllChannelCalls( K )
%REMOVEFILESALLCHANNELCALLS Remove all channel calls of all channels in
%specified files

    if isempty(K)
        return;
    end
    
    for i = 1:length(K)
        for j = 1:fileData(K(i),'Channels','Count')
            removeChannelCalls(K(i),j);
        end
    end


end

