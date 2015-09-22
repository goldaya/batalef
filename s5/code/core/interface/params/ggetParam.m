function [ parValue ] = ggetParam( parName )
%GGETPARAM get batalef gui paramater
%   see also: gsetParam, agetParam, fgetParam

    global control;
    try
        parValue = control.gui.Parameters.get(parName);
    catch err
        if strcmp(err.identifier,'MATLAB:nonStrucReference')
            errstr = 'Tried to read gui parameter, but batalef is running without gui';
            errid  = 'batalef:parameters:noGui';
            pErr    = MException(errid,errstr);
            pErr.addCause(err);
            throwAsCaller(pErr);
        else
            err.rethrow();
        end
    end

end

