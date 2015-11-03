classdef bGuiTop < handle
    %BGUITOP batalef guis: object to rule them all

    properties (SetAccess = private, GetAccess = public)
        Application
        Parameters %$$$
        Methods %$$$
        Guis %$$$
        RibbonsD2PInner
    end
    
    properties (Dependent = true, Access = ?bSelectionRibbon)
        RibbonsLinked
        RibbonsD2P
        DisplayVector
        ProcessVector
    end
    methods
        
        % CONSTRUCTOR
        function me = bGuiTop(app,paramsFile)
            me.Application = app;
            me.Parameters = bParameters(app,'gui');
            me.Parameters.loadFromFile(paramsFile);
            me.RibbonsD2PInner = me.Parameters.get('ribbons_linkD2P');
            me.Methods.displaySpectrogram = bMethodSpectrogram('default','displaySpectrogram',me.Application,me,false);
        end
        
        % DESTRUCTOR
        function delete(me)
            [~,N] = fields2cell(me.Guis);
            cellfun(@(n) me.removeGui(n),N);
            M = fields2cell(me.Methods);
            cellfun(@(m) delete(m),M);
        end      
        
        % SPAWN MAIN GUI
        function mgInit(me)
            name = 'Main';
            me.Guis.(name) = bMainGui(me,name);
        end

        % CALL GUI
        function g = callGui(me,name)
            if me.guiAlive(name)
                g = me.Guis.(name);
                figure(me.Guis.(name).Figure);
            else
                switch name
                    case 'Parameters'
                        g = bParamsGui(me,name);
                    case 'CallAnalysis'
                        g = bCallGui(me,name);
                    case 'MicAdmin'
                        g = bMicAdminGui(me,name);
                    case 'MicLocator'
                        g = [];
                    case 'FileCallsGui'
                        g = bFileCallsGui(me,name);                        
                    otherwise
                        bcerr('Error',sprintf('No such gui: %s',name));
                        return;
                end
                me.Guis.(name) = g;
            end
        end
        
        % SPAWN PARAMETERS VALUES MANAGEMENT GUI
        function pgInit(me)
            name = 'Parameters';
            if me.guiAlive(name)
                figure(me.Guis.(name).Figure);
            else
                me.Guis.(name) = bParamsGui(me,name);
            end
        end

        % SPAWN CALL ANALYSIS GUI
        function gui = cgInit(me)
            if me.guiAlive('CallAnalysis')
                figure(me.Guis.CallAnalysis.Figure);
            else
                me.Guis.CallAnalysis = bCallGui(me);
            end
            gui = me.Guis.CallAnalysis;
        end
        
        % REMOVE GUI
        function removeGui(me,guiName)
%             delete(me.Guis.(guiName).Figure);
            delete(me.Guis.(guiName));
            me.Guis = rmfield(me.Guis,guiName);
        end
        
        % CHECK GUI IS ALIVE
        function val = guiAlive(me,name)
            if isfield(me.Guis,name)
                if ishandle(me.Guis.(name).Figure)
                    val = true;
                    return;
                end
            end
            val = false;
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
        
        % LINKED DISPLAY / VECTOR VECTORS
        function v = get.DisplayVector(me)
            v = me.Guis.Main.DisplayVector;
        end
        function v = get.ProcessVector(me)
            v = me.Guis.Main.ProcessVector;
        end
            
        
    end
    
end

