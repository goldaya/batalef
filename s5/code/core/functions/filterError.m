function filterError( err, str )
%FILTERERROR Check if the error identifier starts with the given string. If
%not, throw the error, if yes, do nothing

    n = length(str);
    if ~strncmp(err.identifier,str,n)
        rethrow(err);
    end

end

