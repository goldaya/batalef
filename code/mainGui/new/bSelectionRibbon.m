classdef bSelectionRibbon < handle & hgsetget
    %BSELECTIONRIBBON Selection ribbon (display and process) for guis
    
    properties (Access = private)
        Gui
        Panel
        TextDisplay
        TextProcess
        CheckboxLinkGuis
        CheckboxLinkD2P
        
        AllowMultiDisplay
    end
    
    properties (Dependent = true, GetAccess = public, SetAccess = ?bGuiTop)
        DisplayVector
        ProcessVector
        RibbonsLinked
        LinkD2P
    end
    
    methods
        
        % CONSTRUCTOR
        function me = bSelectionRibbon(gui,allowMultiDisplay,useTopParams)
            me.Gui = gui;
            me.AllowMultiDisplay = allowMultiDisplay;
            me.Panel = uipanel(me.Gui.Figure);
            fpos = uiPosition(me.Gui.Figure,'character');
            ribbonHeight = 4.3;
            set(me.Panel,'units','character','Position',[0,fpos(4)-ribbonHeight,fpos(3),ribbonHeight],'BorderType','line');
            
            if useTopParams
                linkGuis = me.Gui.Top.RibbonsLinked;
                if linkGuis
                    linkD2P = me.Gui.Top.RibbonsD2P;
                else
                    linkD2P = ggetParem('ribbons:linkD2P');
                end
            else
                linkGuis = ggetParam('ribbons:linkGuis');
                linkD2P  = ggetParam('ribbons:linkD2P');
            end
            
            % display line
            uicontrol(me.Panel,...
                'Style','text',...
                'Units','character',...
                'Position',[2,2.6,8,1],...
                'String','Display:');
            me.TextDisplay = uicontrol(me.Panel,...
                'Style','edit',...
                'Units','character',...
                'Position',[12,2.4,15,1.4],...
                'String','',...
                'Callback',@(hObject,~)me.changeDisplay(str2int_compact(get(hObject,'String'))));
            uicontrol(me.Panel,...
                'Style','pushbutton',...
                'Units','character',...
                'Position',[29,2.4,5,1.4],...
                'String','<',...
                'TooltipString','Previous file',...
                'Callback',@(hObject,~)me.displayPrev());
            uicontrol(me.Panel,...
                'Style','pushbutton',...
                'Units','character',...
                'Position',[35,2.4,5,1.4],...
                'String','>',...
                'TooltipString','Next file',...
                'Callback',@(hObject,~)me.displayNext());
            uicontrol(me.Panel,...
                'Style','pushbutton',...
                'Units','character',...
                'Position',[41,2.4,12,1.4],...
                'String','Select All',...
                'Callback',@(hObject,~)me.changeDisplay(1:appData('Files','Count')));            
            me.CheckboxLinkGuis = uicontrol(me.Panel,...
                'Style','checkbox',...
                'Units','character',...
                'Position',[58,2.6,30,1],...
                'String','Link GUIs',...
                'Value',linkGuis,...
                'Callback',@(h,~)me.changeLinkGuis(get(h,'Value')));
            
            % process line
            uicontrol(me.Panel,...
                'Style','text',...
                'Units','character',...
                'Position',[2,0.7,8,1],...
                'String','Process:');
            me.TextProcess = uicontrol(me.Panel,...
                'Style','edit',...
                'Units','character',...
                'Position',[12,0.5,15,1.4],...
                'String','',...
                'Callback',@(hObject,~)me.changeProcess(str2int_compact(get(hObject,'String'))));            
            uicontrol(me.Panel,...
                'Style','pushbutton',...
                'Units','character',...
                'Position',[29,0.5,11,1.4],...
                'String','D2P',...
                'TooltipString','Copy display vector to process vector',...
                'Callback',@(hObject,~)me.changeProcess(me.DisplayVector));
            uicontrol(me.Panel,...
                'Style','pushbutton',...
                'Units','character',...
                'Position',[41,0.5,12,1.4],...
                'String','Select All',...
                'Callback',@(hObject,~)me.changeProcess(1:appData('Files','Count')));            
            me.CheckboxLinkD2P = uicontrol(me.Panel,...
                'Style','checkbox',...
                'Units','character',...
                'Position',[58,0.7,30,1],...
                'String','Link Display & Process',...
                'Value',linkD2P,...
                'Callback',@(h,~)me.changeLinkD2P(get(h,'Value')));
            
        end
        
        % RESIZE
        function reposition(me,position)
            set(me.Panel,'Units','character','Position',position);
        end
        
        % CHANGE DISPLAY VECTOR
        function changeDisplay(me,vector)
            if ~isempty(vector) && vector(length(vector)) > appData('Files','Count')
                msgbox('Files out of range');
                return;
            end
            if me.RibbonsLinked
                me.Gui.Top.ribbonsChangeDisplay(vector);
            else
                me.DisplayVector = vector;
            end
        end
        
        % DISPLAY VECTOR (SET/GET)
        function vector = get.DisplayVector(me)
            vector = str2int_compact(get(me.TextDisplay,'String'));
        end
        function set.DisplayVector(me,vector)
            if length(vector) > 1 && ~me.AllowMultiDisplay
                msgbox('Multiselection for display is not allowed for this gui');
                return;
            end
            if length(vector) > 1 && me.RibbonsLinked
                msgbox('Multiselection for display is not allowed when GUIs are linked');
                return;
            end
            set(me.TextDisplay,'String',int2str_compact(vector));
            me.Gui.setDisplayedFiles(vector);
            if me.LinkD2P
                me.ProcessVector = vector;
            end            
        end

        % DISPLAY NEXT / PREV
        function displayPrev(me)
            v = me.DisplayVector;
            if isempty(v)
                v = 0;
            end
            v = v(1) - 1;
            n = appData('Files','Count');
            if v < 1
                msgbox('out of range');
            elseif v > n
                msgbox('out of range');
%                 me.changeDisplay(n);
            else
                me.changeDisplay(v);
            end
        end
        function displayNext(me)
            v = me.DisplayVector;
            if isempty(v)
                v = 0;
            end
            v = v(1) + 1;
            n = appData('Files','Count');
            if v < 1
                msgbox('out of range');
            elseif v > n
                msgbox('out of range');
%                 me.changeDisplay(n);
            else
                me.changeDisplay(v);
            end
        end

        % PROCESS TEXT CHANGED
        function changeProcess(me,vector)
            if ~isempty(vector) && vector(length(vector)) > appData('Files','Count')
                msgbox('Files out of range');
                return;
            end
            if me.RibbonsLinked
                me.Gui.Top.ribbonsChangeProcess(vector);
            else
                me.ProcessVector = vector;
            end
        end
        
        % PROCESS VECTOR (SET/GET)
        function vector = get.ProcessVector(me)
            vector = str2int_compact(get(me.TextProcess,'String'));
        end
        function set.ProcessVector(me,vector)
            set(me.TextProcess,'String',int2str_compact(vector));
        end
        
        % LINK GUIS
        function changeLinkGuis(me,link)
            me.Gui.Top.RibbonsLinked = link;
            if link
                if length(me.DisplayVector) > 1
                    msgbox('Display vector changed to a scalar. Vector display is not allowed on linked GUIs mode');
                    me.DisplayVector = me.DisplayVector(1);
                end
                me.Gui.Top.ribbonsChangeDisplay(me.DisplayVector);
                me.Gui.Top.ribbonsChangeProcess(me.ProcessVector);
                me.Gui.Top.ribbonsChangeD2P(me.LinkD2P);
            end
        end
        % LINK D2P
        function changeLinkD2P(me,link)
            if me.RibbonsLinked
                me.Gui.Top.ribbonsChangeD2P(link);
            else
                me.LinkD2P = link;
            end
        end
        function set.LinkD2P(me,link)
            set(me.CheckboxLinkD2P,'Value',link);
            if link
                me.ProcessVector = me.DisplayVector;
            end
        end
        function linked = get.LinkD2P(me)
            linked = get(me.CheckboxLinkD2P,'Value');
        end
        
        % RIBBONS ARE LINKED ?
        function val = get.RibbonsLinked(me)
%             val = me.Gui.Top.RibbonsLinked;
            val = get(me.CheckboxLinkGuis,'Value');
        end
        function set.RibbonsLinked(me,link)
            set(me.CheckboxLinkGuis,'Value',link);
        end
    end
end
