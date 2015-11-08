function channelCallsAnalyzeChannel(fileIdx,fileObject,channelIdx,types,params)
%CHANNELCALLSANALYZECHANNEL Analyze specific channel & save
    channelObject = fileObject.channel(channelIdx);
    FTS = channelObject.Application.Methods.callAnalysisFilter.execute(channelObject.getTS([]),channelObject.Fs);
    ENV = channelObject.Application.Methods.callAnalysisEnvelope.execute(FTS,channelObject.Fs);
    S = 1:channelObject.CallsCount;
    arrayfun(@(s)channelCallsAnalyzeCall(channelObject,s,types,FTS,ENV,params),S);
%     disp(strcat(num2str(fileIdx),':',num2str(channelIdx)));
end

