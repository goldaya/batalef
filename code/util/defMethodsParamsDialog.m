function [ parstruct, userAbort ] = defMethodsParamsDialog( parcell, title, noDialog )
%DEFMETHODSPARAMSDIALOG Translate parameters cell array into a dialog and
%output the values as structure

    if ~exist( 'noDialog', 'var' )
        noDialog = false;
    end
    
    userAbort = false;
    
    if ~isempty(parcell)
        Q = cell(size(parcell));
        D = cell(size(parcell));
        for i = 1:length(parcell)
            Q{i} = parcell{i}{2};
            try
                D{i} = num2str(getParam(parcell{i}{3}));
            catch err
                if strcmp(err.identifier, 'WrongParameter:NoParameter')
                    d = str2double(parcell{i}{3});
                    if isnan(d)
                        D{i} = parcell{i}{3};
                    else
                        D{i} = d;
                    end
                else
                    throw(err);
                end
            end

        end
        
        if noDialog
            A = D;
        else
            A = inputdlg(Q,title,[1,50],D);
        end
        
        if isempty(A)
            userAbort = true;
            return;
        end
        for i = 1: length(parcell)
            a = str2double(A{i});
            if isnan(a)
                parstruct.(parcell{i}{1}) = A{i};
            else
                parstruct.(parcell{i}{1}) = a;
            end
        end
    
        % keep parameters if bpf managed
        for i = 1:length(parcell)
            try
                getParam(parcell{i}{3});
                a = str2double(A{i});
                if ~isnan(a)
                    setParam(parcell{i}{3}, a);
                end
            catch err
                if ~strcmp(err.identifier, 'WrongParameter:NoParameter')
                    throw(err)
                end
            end
        end        
    else
        parstruct = [];
    end
    


end