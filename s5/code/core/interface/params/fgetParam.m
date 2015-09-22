function [ parValue ] = fgetParam( fileIdx, parName )
%FGETPARAM get batalef file processing paramater
%   see also: agetParam, ggetParam

    global control;
    parValue = control.app.getFileParam(fileIdx,parName);

end

