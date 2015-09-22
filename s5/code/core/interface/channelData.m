function [ varargout ] = channelData( fileIdx, channelIdx, varargin )
%CHANNELDATA get channel data
    
    global control;
    [varargout{1:nargout}] = control.app.getChannelData(fileIdx,channelIdx,varargin{:});

end

