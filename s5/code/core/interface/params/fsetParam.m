function fsetParam( fileIdx, pName, pValue )
%FSETPARAM Set batalef file parameter
%   See also: asetParam, gsetParam.

    global control;
    control.app.setFileParameter(fileIdx,pName,pValue);
    
end

