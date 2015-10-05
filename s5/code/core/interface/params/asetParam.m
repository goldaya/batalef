function asetParam( pName, pValue )
%ASETPARAM Set batalef application parameter
%   See also: gsetParam, fsetParam.

    global control;
    control.app.Parameters.set(pName,pValue);

end

