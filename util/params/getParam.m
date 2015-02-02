function [ pValue ] = getParam( pName )
%GETPARAM Get parameter value by name
%   Detailed explanation goes here

    global control;
    
    if ~isfield(control,'params')
        pValue = [];
        return;
    end
    
    idx = strmatch(pName, control.params.names, 'exact');
    
    % could be only one pramter with this name
    if length(idx) > 1
        err = MException('WrongParameter:Duplicate','Too many parameters with same name: %s', pName);
        throw(err);
    elseif isempty(idx)
        err = MException('WrongParameter:NoParameter', 'No parameter with this name: %s',pName);
        throw(err)
    end
    
    % return value
    fValue = control.params.values(idx);
    switch control.params.types{idx}
        case 'integer'
            pValue = int32(fValue);
        case 'float'
            pValue = fValue;
    end
    
end

