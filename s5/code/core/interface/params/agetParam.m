function [ parValue ] = agetParam( pID )
%AGETPARAM get batalef application paramater
%   see also: ggetParam, fgetParam

    global control;
    parValue = control.app.Parameters.get(pID);

end

