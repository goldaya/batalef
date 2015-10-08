function [ parValue ] = agetParam( pID,varargin )
%AGETPARAM get batalef application paramater
%   see also: ggetParam, fgetParam

    global control;
    parValue = control.app.Parameters.get(pID,varargin{:});

end

