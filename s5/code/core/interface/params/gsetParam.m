function gsetParam( pName, pValue )
%GSETPARAM Set batalef gui parameter
%   See also: ggetParam, asetParam, fsetParam.
    
    global control;
    control.gui.Parameters.set(pName,pValue);
    
end

