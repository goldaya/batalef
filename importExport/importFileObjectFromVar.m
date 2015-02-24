function [  ] = importFileObjectFromVar( varargin )
%IMPORTFILEOBJECT Loads file-object from variable into the filesObject
%repository
%   varName = name of variable holding the file-object.

    if ~isempty(varargin) && ischar(varargin{1})
        varName = varargin{1};
    else
       Ans = inputdlg('Workbase variable which holds the file-object:');
       if isempty(Ans)
           return;
       end
       varName = Ans{1};
    end
        
    try
        fobj = evalin('base',varName);
    catch err
        if strcmp(err.identifier, 'MATLAB:UndefinedFunction')
            msgbox('No such variable in base workspace');
            return;
        else
            throw(err);
        end
    end
    if isstruct(fobj)
        addFileObject( fobj );
    elseif iscell(fobj)
        for i=1:length(fobj)
            if isstruct(fobj{i})
                addFileObject( fobj{i} );
            end
        end
    end
                
end