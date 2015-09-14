classdef bGuiTop < handle
    %BGUITOP batalef guis: object to rule them all

    properties 
        RibbonsLinked = false;
        Main
    end
    
    methods
        
        % CONSTRUCTOR
        
        % REGISTER GUI
        function registerGui(me,guiName,guiObject)
        end
        % spawn main gui
        function mgInit(me)
            me.Main = bMainGui(me);
        end
        
        % RIBBONS
        
    end
    
end

