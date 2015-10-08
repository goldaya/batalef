function [ parValue ] = fgetParam( fileIdx, parName, varargin )
%FGETPARAM get batalef file processing paramater
%   see also: agetParam, ggetParam

    global control;
    parValue = control.app.getFileParam(fileIdx,parName,varargin{:});

end

