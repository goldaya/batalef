classdef bGuiTop < handle
    %BGUITOP batalef guis: object to rule them all

    properties 
        RibbonsLinked = false;
        Main
    end
    
    methods
        
        % CONSTRUCTOR
        
        % spawn main gui
        function mgInit(me)
            me.Main = bMainGui(me);
        end
    end
    
end

