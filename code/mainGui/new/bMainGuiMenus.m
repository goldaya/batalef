classdef bMainGuiMenus < handle
    %BMAINGUIMENUS Main gui menus handling (build + functionality)
    
    properties (Access = ?bMainGui)
        Gui
        Figure
        Menus
    end
    
    methods
        function me = bMainGuiMenus(gui,figure)
            me.Gui = gui;
            me.Figure = figure;
            

        end
        
        
    end
    
end

