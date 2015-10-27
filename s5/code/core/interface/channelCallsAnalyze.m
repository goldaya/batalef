function channelCallsAnalyze( appObject, files, channels, types, params )
%CHANNELCALLSANALYZE Analyze & save channel calls for all calls in given 
%files and channels, and for all types specified

    arrayfun(@(f)channelCallsAnalyzeFile(appObject,f,channels,types,params),files);

end