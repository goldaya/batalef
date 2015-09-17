classdef bGuiTop < handle
    %BGUITOP batalef guis: object to rule them all

    properties (Access = private)
        Guis
%         RibbonsLinkedInner = ggetParam('ribbons:linkGuis');
        RibbonsD2PInner = ggetParam('ribbons:linkD2P');
    end
    
    properties (Dependent = true, Access = ?bSelectionRibbon)
        RibbonsLinked
        RibbonsD2P
    end
    methods
        
        % CONSTRUCTOR
        
        
        % spawn main gui
        function mgInit(me)
            me.Guis.Main = bMainGui(me);
        end
        
        % RIBBONS
        function linked = get.RibbonsLinked(me)
%             linked = me.RibbonsLinkedInner;
            linked = me.Guis.Main.SelectionRibbon.RibbonsLinked;
        end
        function set.RibbonsLinked(me,link)
%             me.RibbonsLinkedInner = link;
            G = fields(me.Guis);
            cellfun(@(guiName) set(me.Guis.(guiName).SelectionRibbon,'RibbonsLinked',link),G);
        end
        function linked = get.RibbonsD2P(me)
%             linked = me.RibbonsD2PInner;
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

