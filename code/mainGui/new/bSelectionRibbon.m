classdef bSelectionRibbon < handle
    %BSELECTIONRIBBON Selection ribbon (display and process) for guis
    
    properties (Access = public)
        LinkD2P = false;
    end
    
    properties (Access = private)
        Gui
        Panel
        TextDisplay
        TextProcess
        AllowMultiDisplay
    end
    
    methods
        
        % CONSTRUCTOR
        function me = bSelectionRibbon(gui,allowMultiDisplay)
            me.Gui = gui;
            me.AllowMultiDisplay = allowMultiDisplay;
            me.Panel = uipanel(me.Gui.Figure);
            fpos = uiPosition(me.Gui.Figure,'character');
            ribbonHeight = 4.3;
            set(me.Panel,'units','character','Position',[0,fpos(4)-ribbonHeight,fpos(3),ribbonHeight],'BorderType','line');
            
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
                'Callback',@(hObject,~)me.displayTextChanged(str2int_compact(get(hObject,'String'))));
                
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
                'Callback',@(hObject,~)me.processTextChanged(str2int_compact(get(hObject,'String'))));            
            
        end
        
        % RESIZE
        function reposition(me,position)
            set(me.Panel,'Units','character','Position',position);
        end
        % DISPLAY TEXT CHANGED
        function displayTextChanged(me,vector)
            if vector(length(vector)) > appData('Files','Count')
                msgbox('Files out of range');
                return;
            end
            if me.Gui.RibbonsLinked
                me.Gui.ribbonDisplayTextChanged(vector);
            else
                me.setDisplay(vector);
            end
        end
        function setDisplay(me,vector)
            if length(vector) > 1 && ~me.AllowMultiDisplay
                msgbox('Multiselection for display is not allowed for thid gui');
                return;
            end
            set(me.TextDisplay,'String',int2str_compact(vector));
            me.Gui.setDisplayedFiles(vector);
            if me.LinkD2P
                me.setProcess(vector);
            end
        end
        
        % PROCESS TEXT CHANGED
        function processTextChanged(me,vector)
%             if me.Gui.RibbonLinked
%                 me.Gui.ribbonProcessTextCHanged(vector);
%             else
%                 me.setProcess(vector);
%             end
        end
        function setProcess(me,vector)
            set(me.TextProcess,'String',int2str_compact(vector));
        end
    end
    
end

