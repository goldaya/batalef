function channelCallsAnalyzeFile(appObject,fileIdx,channels,types,params)
%CHANNELCALLSANALYZEFILE Analyze specific file & save
    fileObject = appObject.file(fileIdx);
    nJ = fileObject.ChannelsCount;
    
    if isempty(channels)
        J = 1:nJ;
    else
        J = channels(channels<=nJ);
    end
    
    arrayfun(@(j)channelCallsAnalyzeChannel(fileIdx,fileObject,j,types,params),J);
end