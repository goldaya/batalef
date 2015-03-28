function [ fca ] = exportFileObject( K, withRawData )
%EXPORTFILEOBJECT Summary of this function goes here
%   Detailed explanation goes here

    global filesObject;
    if isempty(K) 
        return;
    end
    
    fca = cell(length(K),1);
    for i = 1:length(K)
        
        if ~validateFileIndex(K(i),true)
            continue;
        end
        
        fca{i} = filesObject(K(i));
        if withRawData
            if isempty(fca{i}.rawData.data)
                fca{i}.rawData.data = audioread(fileData(K(i),'Fullpath'));
            end
        else
            fca{i}.rawData.data = [];
        end
        
    end
    
    [name,path]=uiputfile('*.mat','Save file object');
    if ~ischar(name)
        return; % aborted
    end
    % check variable exists in base workspace
    try
        evalin('base',name);
        a = questdlg('A variable with this name already exists and will be overwritten. Do you wish to proceed?','Export File Objects','Yes','No','Yes');
        if strcmp(a,'No')
            return;
        end
    catch err % no such variable exists
        switch err.identifier
            case 'MATLAB:undefinedVarOrClass'
            case 'MATLAB:UndefinedFunction'
            case 'MATLAB:m_missing_variable_or_function'
                msgbox('error in file name');
                return;
            case 'MATLAB:nonStrucReference'
                msgbox('File name has too many "."');
                return;                
            otherwise
                throw(err)
        end
    end
    
    % get variable name
    dotes = strfind(name,'.');
    if max(size(dotes)) > 1
        msgbox('File name has too many "."');
        return;
    elseif isempty(dotes)
        var = name;
    elseif dotes == 1
        msgbox('file name should not starts with "."');
        return;
    else
        var = name(1:dotes-1);
    end
    
    % assign to variable in base workspace
    assignin('base',var,fca);
    
    % save to file    
    save(strcat(path,name),'fca');
    
    %{
    V = inputdlg('Assign data to variable:');
    if ~isempty(V)
        var = V{1};
        assignin('base', var, fca);
        disp(' ');
        disp(strcat(['  ',var,' is now cell array with file objects']))
    end
    %}
end

