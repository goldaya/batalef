function setParam( pName, pValue )
%SETPARAM Set parameter
%   Detailed explanation goes here

    global control;
    
    % allow only numeric scalars
    if ischar(pValue)
        pValue = str2double(pValue);
    end
    if isnan(pValue) || ~isscalar(pValue)
        err = MException('WrongParameter:NotScalar','Value is not numeric scalar');
        throw(err)
    end
        
    
    %idx = strmatch(pName, control.params.names, 'exact');
    idx = find(strcmp(pName, control.params.names));
    if isempty(idx)
        idx = length(control.params.names)+1;
        control.params.names{idx} = pName;
        control.params.types{idx} = 'float';
    elseif length(idx) > 1
        % error. too many params with same name
        err = MException('WrongParameter:Duplicate','Too many parameters with same name: %s', pName);
        throw(err);
    end
    
    control.params.values(idx) = pValue;

end

