function [  ] = ensureRawData( k )
%ENSURERAWDATA If there is no raw data matrix, load it from file

    if fileData( k, 'IsLoaded' )            
        return;
    else
        refreshRawData(k, true)
    end

end

