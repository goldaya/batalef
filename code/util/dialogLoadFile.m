function [ D ] = dialogLoadFile(  )
%DIALOGLOADFILE Load data from file using dialog

    [filename, path] = uigetfile({'*.mat','Matlab File (.mat)';...
                                        '*.*', 'All files'});
    if ~ischar(filename) || ~ischar(path)
        D = [];
    else
        D = importdata( strcat( path, filename ) );
    end

end

