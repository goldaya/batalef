classdef bMainGui < handle
%BMAINGUI Object to handle batalef's main gui
    
    properties (Access = public)
        Figure;
    end
    
    properties (Access = ?bSelectionRibbon)
        Top
    end
    
    properties (Access = ?bGuiTop)
        SelectionRibbon
    end
    
    properties (Access = private)
        FilesTable
        Graphs
        Menus
    end
    
    properties (Dependent = true)
        Visible
        RibbonsLinked
    end
    
    methods
        
        % CONSTRUCTOR
        function me = bMainGui(guiTop)
            me.Top = guiTop;
            me.Figure = figure(...
                'Units','normalized',...
                'OuterPosition',[0,0,1,1],...
                'Visible','off',...
                'ToolBar','none',...
                'MenuBar','none',...
                'Name','BATALEF',...
                'NumberTitle','off',...
                'SizeChangedFcn',@(~,~)me.resize(),...
                'CloseRequestFcn',@(~,~)me.kill());
                
            me.buildGui();
            
            % mouse motion
            set(me.Figure,'Units','pixels');
            set(me.Figure,'WindowButtonMotionFcn',...
                @(~,~)me.Graphs.mouseMotion(get(me.Figure,'CurrentPoint')));
        end
        
        % KILL
        function kill(me)
            delete(me.Figure);
            clear('me.Graphs');
        end
        
        % BUILD GUI
        function buildGui(me)
            % selection ribbon
            me.SelectionRibbon = bSelectionRibbon(me,true);

            % files table
            uitabColNames = {'Path + Name','Length','Fs','# Channels','# Calls','Raw Data Status'};
            uitabColWidths = {300,60,60,200,60,200};
            uitabColFormats = {'char','numeric','numeric','numeric','numeric','char'};                
            me.FilesTable = uitable(me.Figure,...
                    'Units','character',...
                    'columnname',uitabColNames,...
                    'columnformat',uitabColFormats,...
                    'ColumnWidth',uitabColWidths,...
                    'Position',[0,0,100,5]);
            me.refreshFilesTable();
            
            % graphs
            me.Graphs = bMainGuiGraphGroup(me.Figure,ggetParam('mainGUI:displayType'),ggetParam('mainGUI:displayWindow'));
            me.Graphs.buildDisplay(ggetParam('mainGUI:nAxes'),uiPosition(me.Figure,'character'));
            
            % menu bars
            me.buildMenus();

            set(me.Figure,'Units','normalized','OuterPosition',[0,0,1,1]);
            me.resize();
            me.linkGraphs(ggetParam('mainGUI:linkAxes'));
        end
        
        % BUILD MENUS
        function buildMenus(me)
            me.Menus.Batalef = uimenu(me.Figure,'Label','Batalef');
            me.Menus.batalef.Exit = uimenu(me.Menus.Batalef,'Label','Exit','Callback',@(~,~)batalefGuiKill(me));
            
            me.Menus.Files = uimenu(me.Figure,'Label','Files');
            me.Menus.files.Add = uimenu(me.Menus.Files,'Label','Add File','Callback',@(~,~)me.addFiles());
            
            me.Menus.Settings = uimenu(me.Figure,'Label','Settings');
            me.Menus.settings.Display = ...
                uimenu(me.Menus.Settings,'Label','Display');
            me.Menus.settings.display.LinkGraphs = ...
                uimenu(me.Menus.settings.Display,'Label','Link Graphs','Callback',@(h,~)me.linkGraphs(strcmp(get(h,'Checked'),'off')));
            me.Menus.settings.display.GraphsNumber = ...
                uimenu(me.Menus.settings.Display,'Label','Set number of graphs','Callback',@(~,~)me.askAndSetGraphsNumber());
        end
        
        
        % RESIZE
        function resize(me)
            me.Visible = 'on';
            
            tabHeight    = 8;
            ribbonHeight = 4.3;
            fpos = uiPosition(me.Figure,'character');
            rpos = [0,fpos(4)-ribbonHeight,fpos(3),ribbonHeight];
            me.SelectionRibbon.reposition(rpos);
            tpos = [2,fpos(4)-tabHeight-1-ribbonHeight,fpos(3)-4,tabHeight];
            set(me.FilesTable,'Units','character','Position',tpos);
            gpos = fpos - [0,0,0,tabHeight+2+ribbonHeight];
            me.Graphs.resize(gpos);
            
            me.Visible = 'on';
            
        end
        
        % LINK GRAPHS
        function linkGraphs(me,link)
            if link
                state = 'on';
            else
                state = 'off';
            end
            set(me.Menus.settings.display.LinkGraphs,'Checked',state);
            me.Graphs.linkAxes(link);
        end
        
        % VISIBLE PROPERTY (SET/GET)
        function set.Visible(me,val) % val = 'on' / 'off'
            set(me.Figure,'Visible',val);
        end
        function val = get.Visible(me)
            val = get(me.Figure,'Visible');
        end
        
        % ADD FILES
        function addFiles(me)
            addFiles();
            me.refreshFilesTable();
        end
        
        % REFRESH FILES TABLE
        function refreshFilesTable(me)
            N = appData('Files','Count');
            D = cell(N,6);
            for k = 1:N
                D{k,1} = fileData(k,'Name');
                D{k,2} = fileData(k,'Length');
                D{k,3} = fileData(k,'Fs');
                D{k,4} = fileData(k,'nChannels');
                D{k,5} = fileData(k,'Calls','Count');
                D{k,6} = fileData(k,'DataStatus');
            end
            set(me.FilesTable,'Data',D);            
        end
        
        % RIBBONS LINKED PROPERTY (GET/SET)
        function val = get.RibbonsLinked(me)
            val = me.Top.RibbonsLinked;
        end
        
        % RIBBON DISPLAY CHANGED (UPWARD PROPOGATION)
        function ribbonDisplayTextChanged(me,filesVector)
        end
        
        % SET THE DISPLAYED FILES
        function setDisplayedFiles(me,filesVector)
            me.Graphs.FilesVector = filesVector;
        end
        
        % ASK AND SET NUMBER OF GRAPHS
        function askAndSetGraphsNumber(me)
            N = me.Graphs.Count;
            A = inputdlg('Set number of graphs','',[1 30],{num2str(N)});
            if ~isempty(A)
                n = str2double(A{1});
                d = n - N;
                if d == 0
                    return;
                elseif mod(d,1) > 0
                    msgbox('error, use integer value');
                    return;
                elseif d > 1
                    me.Graphs.addGraph(d);
                elseif -d > N
                    msgbox('error, use positive integer');
                    return;
                elseif d < 1
                    me.Graphs.removeGraph(-d);
                end
                me.Graphs.refreshDisplay();
            end
        end
        
    end
    
end

