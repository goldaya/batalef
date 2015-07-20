classdef bFile < handle
    %BFILE Batalef - File Object
    
    properties
        Title
        RawData
        Calls
        Parameters
        MicData
        Application
        
    end
    
    properties (Dependent = true)
        
    end
    
    methods
        % CONSTRUCTOR
        function me = bFile(applicationObject,title)
            me.Application = applicationObject;
            me.Title = title;
        end
    end
    
end