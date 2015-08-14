classdef bFile < handle
    %BFILE Batalef - File Object
    
    properties
        Title
        RawData
        Parameters
        MicData
        Application
        Calls % file level calls
    end
    
    properties (Dependent = true)
        Fs
        ChannelsCount
    end
    
    methods
        % CONSTRUCTOR
        function me = bFile(applicationObject,title,audioFile,parametersFile)
            me.Application = applicationObject;
            me.Title = title;
            
            % create parameters object
            me.Parameters = bParameters(me,'file');
            me.Parameters.loadFromFile(parametersFile);
            
            % create raw data object
            me.RawData = bRawData('external',[],[],[],audioFile,me);
        end
    end
    
end
