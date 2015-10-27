classdef bGuiDefinition < handle
    %BGUIDEFINITION Partial class for guis definition
    
    properties (Access = public)
        Figure;
        Top
        SelectionRibbon
        Name
        Build = false;
    end
    
    properties (Dependent = true)
        RibbonsLinked    
        Visible
        Parameters
        Application        
        DisplayVector
        ProcessVector
    end
    
    methods
        
        % CONSTRUCTOR
        function me = bGuiDefinition(guiTop,name)
            me.Top = guiTop;
            me.Name = name;
        end
        
        % RIBBONS LINKED PROPERTY (GET/SET)
        function val = get.RibbonsLinked(me)
            val = me.Top.RibbonsLinked;
        end      
        
        % VISIBLE PROPERTY (SET/GET)
        function set.Visible(me,val) % val = 'on' / 'off'
            set(me.Figure,'Visible',val);
        end
        function val = get.Visible(me)
            val = get(me.Figure,'Visible');
        end

        % PARAMETERS GET
        function val =  get.Parameters(me)
            val = me.Top.Parameters;
        end
        

        % APPLICATION
        function val = get.Application(me)
            val = me.Top.Application;
        end        
        
        % DISPLAY VECTOR
        function val = get.DisplayVector(me)
            val = me.SelectionRibbon.DisplayVector;
        end
        
        % PROCESS VECTOR
        function val = get.ProcessVector(me)
            val = me.SelectionRibbon.ProcessVector;
        end
        
        % REFRESH
        function refresh(~)
        end
            
        
    end
    
end

