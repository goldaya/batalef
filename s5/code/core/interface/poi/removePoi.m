function removePoi( fileIdx, channelIdx, varargin )
%REMOVEPOI Remove Point of Interest

    global control;
    
    timeInterval = getParFromVarargin('BetweenTimes',varargin);
    if timeInterval
        control.app.file(fileIdx).channel(channelIdx).removePoisByTime(timeInterval)
        return;
    end

end

