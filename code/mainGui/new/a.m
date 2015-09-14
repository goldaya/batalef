classdef a < handle
    %A Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        prop1 = 0;
        prop2 = 0;
    end
    
    methods
        function res = comp(me)
            res = me.prop1 * me.prop2;
        end
    end
    
end

