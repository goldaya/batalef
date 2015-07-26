classdef bFile < handle
    %BFILE Batalef - File Object
    
    properties
        Title
        RawData
        Calls
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
        function me = bFile(applicationObject,title,rawDataObject,parametersObject)
            me.Application = applicationObject;
            me.Title = title;
            me.RawData = rawDataObject;
            me.Parameters = parametersObject;
        end
    end
    
end
