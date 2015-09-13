classdef bMainGui < handle
%BMAINGUI Object to handle batalef's main gui
    
    properties (Access = public)
        Figure;
    end
    properties (Access = private)
        Top
        FilesTable
        Graphs
        Menus
        SelectionRibbon
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
                'SizeChangedFcn',@(~,~)me.resize(),...
                'CloseRequestFcn',@(~,~)me.kill());
            me.buildGui();
        end
        
        % KILL
        function kill(me)
            delete(me.Figure);
            clear('me.Graphs');
        end
        
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
            me.Graphs = bMainGuiGraphGroup(me.Figure,1,0.3);
            me.Graphs.buildDisplay(3,uiPosition(me.Figure,'character'));
            
            % menu bars
            me.buildMenus();

            set(me.Figure,'Units','normalized','OuterPosition',[0,0,1,1]);
            me.resize();
        end
        
        % BUILD MENUS
        function buildMenus(me)
            me.Menus.batalef = uimenu(me.Figure,'Label','Batalef');
            uimenu(me.Menus.batalef,'Label','Exit','Callback',@(~,~)batalefGuiKill(me));
            
            me.Menus.files = uimenu(me.Figure,'Label','Files');
            uimenu(me.Menus.files,'Label','Add File','Callback',@(~,~)me.addFiles());
            
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
        
    end
    
end

