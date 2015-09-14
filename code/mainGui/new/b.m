classdef b < handle & a
    %B Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        prop3
    end
    
    methods
        function me = b(prop)
            me.prop3 = prop;
        end
        
        function t = test(me)
            t = me.prop3 * me.comp();
        end
    end
    
end

