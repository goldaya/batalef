classdef bGuiTop < handle
    %BGUITOP batalef guis: object to rule them all


    properties (Access = private)
        Guis %$$$
        RibbonsD2PInner
    end
    
    properties (SetAccess = private, GetAccess = public)
        Application
        Parameters %$$$
        Methods %$$$
    end
    
    properties (Dependent = true, Access = ?bSelectionRibbon)
        RibbonsLinked
        RibbonsD2P
    end
    methods
        
        % CONSTRUCTOR
        function me = bGuiTop(app,paramsFile)
            me.Application = app;
            me.Parameters = bParameters(me,'gui');
            me.Parameters.loadFromFile(paramsFile);
            me.RibbonsD2PInner = me.Parameters.get('ribbons_linkD2P');
            me.Methods.displaySpectrogram = bMethodSpectrogram('default','displaySpectrogram',me.Application,me);
        end
        
        % DESTRUCTOR
        function delete(me)
            [G,N] = fields2cell(me.Guis);
            cellfun(@(g,n) me.removeGui(g,n),G,N);
            M = fields2cell(me.Methods);
            cellfun(@(m) delete(m),M);
        end      
        
        % SPAWN MAIN GUI
        function mgInit(me)
            me.Guis.Main = bMainGui(me);
        end
        
        % REMOVE GUI
        function removeGui(me,gui,name)
            delete(gui.Figure);
            delete(gui);
            me.Guis = rmfield(me.Guis,name);
        end
        
        % RIBBONS
        function linked = get.RibbonsLinked(me)
            linked = me.Guis.Main.SelectionRibbon.RibbonsLinked;
        end
        function set.RibbonsLinked(me,link)
            G = fields(me.Guis);
            cellfun(@(guiName) set(me.Guis.(guiName).SelectionRibbon,'RibbonsLinked',link),G);
        end
        function linked = get.RibbonsD2P(me)
            linked = me.Guis.Main.SelectionRibbon.LinkD2P;
        end
        function set.RibbonsD2P(me,link)
            if me.RibbonsLinked
                G = fields(me.Guis);
                cellfun(@(guiName) set(me.Guis.(guiName),'LinkD2P',link),G);                        
            end
        end
        function ribbonsChangeDisplay(me,vector)
            G = fields(me.Guis);
            cellfun(@(guiName) set(me.Guis.(guiName).SelectionRibbon,'DisplayVector',vector),G);            
        end        
        function ribbonsChangeProcess(me,vector)
            G = fields(me.Guis);
            cellfun(@(guiName) set(me.Guis.(guiName).SelectionRibbon,'ProcessVector',vector),G);            
        end
        function ribbonsChangeD2P(me,link)
            G = fields(me.Guis);
            cellfun(@(guiName) set(me.Guis.(guiName).SelectionRibbon,'LinkD2P',link),G);
        end
            
        
    end
    
end

