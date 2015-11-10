classdef bget
    %BGET a class to retrieve batalef objects
   
    methods (Static)
        
        function g = app()
            %APP get batalef app object
            global control;
            g = control.app;
        end        
        
        function g = gui(guiName)
            %GUI get batalef gui object
            global control;
            g = control.gui.Guis.(guiName);
        end
        
        function g = file(k)
            %FILE get batalef file object
            global control;
            g = control.app.file(k);
        end      
        
        function g = method(mobjName)
            %METHOD get batalef app object
            global control;
            if exist('mobjName','var') && ~isempty(mobjName)
                if ischar(mobjName)
                    g = control.app.Methods.(mobjName);
                elseif isnumeric(mobjName)
                    s = struct2cell(control.app.Methods);
                    g = s{mobjName};
                else
                    g = control.app.Methods;
                end
            else
                g = control.app.Methods;
            end
        end      
        
    end
    
end