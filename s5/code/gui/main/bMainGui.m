classdef bMainGui < bGuiDefinition
%BMAINGUI Object to handle batalef's main gui

    properties (Access = private)
        FilesTable
        Menus
    end
    
    properties (SetAccess = private, GetAccess = public)
        ContextMenuObject
        Graphs
    end
    
    properties (Access = public)
        LastAxesObject
        LastGraphObject
    end
    
    properties (Dependent = true)
        ContextMenu
    end
       
    methods
        
        % CONSTRUCTOR
        function me = bMainGui(guiTop)
            me = me@bGuiDefinition(guiTop);
            me.Figure = figure(...
                'Units','normalized',...
                'OuterPosition',[0,0,1,1],...
                'Visible','off',...
                'ToolBar','none',...
                'MenuBar','none',...
                'Name','BATALEF TT1',...
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
            batalefGuiKill(me.Top);
        end
        
        % BUILD GUI
        function buildGui(me)
            
            % context menu
            me.buildContextMenu();
            
            % selection ribbon
            me.SelectionRibbon = bSelectionRibbon(me,true,false);

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
            me.Graphs = bMainGuiGraphGroup(me,ggetParam('mainGui_displayType'),ggetParam('mainGui_displayWindow'));
            me.Graphs.buildDisplay(ggetParam('mainGui_nAxes'),uiPosition(me.Figure,'character'));
            
            % menu bars
            me.buildMenus();            
            
            set(me.Figure,'Units','normalized','OuterPosition',[0,0,1,1]);
            me.resize();
            me.linkGraphs(ggetParam('mainGui_linkAxes'));
            me.showPois(ggetParam('mainGui_showPois'));
        end
        
        % BUILD MENUS
        function buildMenus(me)
            me.Menus.Batalef = uimenu(me.Figure,'Label','Batalef');
            me.Menus.batalef.Exit = uimenu(me.Menus.Batalef,'Label','Exit','Callback',@(~,~)batalefGuiKill(me.Top));
            
            me.Menus.Files = uimenu(me.Figure,'Label','Files');
            me.Menus.files.Add = ...
                uimenu(me.Menus.Files,'Label','Add Files','Callback',@(~,~)me.addFiles());
            me.Menus.files.Remove = ...
                uimenu(me.Menus.Files,'Label','Remove Files','Callback',@(~,~)me.removeFiles());            
            
            % settings
            me.Menus.Settings = uimenu(me.Figure,'Label','Settings');
            me.Menus.settings.Display = ...
                uimenu(me.Menus.Settings,'Label','Display');
            me.Menus.settings.display.LinkGraphs = ...
                uimenu(me.Menus.settings.Display,'Label','Link Graphs','Callback',@(h,~)me.linkGraphs(strcmp(get(h,'Checked'),'off')));
            me.Menus.settings.display.GraphsNumber = ...
                uimenu(me.Menus.settings.Display,'Label','Set number of graphs','Callback',@(~,~)me.askAndSetGraphsNumber());        
            me.Menus.settings.display.Pois = ...
                uimenu(me.Menus.settings.Display,'Label','Points of Interest');
            me.Menus.settings.display.pois.Dont = ...
                uimenu(me.Menus.settings.display.Pois,'Label','Dont show','UserData','dont','Callback',@(~,~)me.showPois('dont'));
            me.Menus.settings.display.pois.Dont = ...
                uimenu(me.Menus.settings.display.Pois,'Label','Show marks','UserData','marks','Callback',@(~,~)me.showPois('marks'));
            me.Menus.settings.display.pois.Dont = ...
                uimenu(me.Menus.settings.display.Pois,'Label','Show marks & texts','UserData','texts','Callback',@(~,~)me.showPois('texts'));            
            
            me.Menus.settings.Parameters = ...
                uimenu(me.Menus.Settings,'Label','Parameters');
            me.Menus.settings.parameters.Application = ...
                uimenu(me.Menus.settings.Parameters,'Label','Application');
            me.Menus.settings.parameters.application.Load = ...
                uimenu(me.Menus.settings.parameters.Application,'Label','Load from file','Callback',@(~,~)me.paramsLoad('app'));
            me.Menus.settings.parameters.application.Save = ...
                uimenu(me.Menus.settings.parameters.Application,'Label','Save to file','Callback',@(~,~)me.paramsSave('app'));
            
            me.Menus.settings.parameters.Gui = ...
                uimenu(me.Menus.settings.Parameters,'Label','GUI');
            me.Menus.settings.parameters.gui.Load = ...
                uimenu(me.Menus.settings.parameters.Gui,'Label','Load from file','Callback',@(~,~)me.paramsLoad('gui'));
            me.Menus.settings.parameters.gui.Save = ...
                uimenu(me.Menus.settings.parameters.Gui,'Label','Save to file','Callback',@(~,~)me.paramsSave('gui'));
            
            me.Menus.settings.parameters.File = ...
                uimenu(me.Menus.settings.Parameters,'Label','File');
            me.Menus.settings.parameters.file.Load = ...
                uimenu(me.Menus.settings.parameters.File,'Label','Load from file','Callback',@(~,~)me.paramsLoad('file'));
            me.Menus.settings.parameters.file.Save = ...
                uimenu(me.Menus.settings.parameters.File,'Label','Save to file','Callback',@(~,~)me.paramsS('file'));
            me.Menus.settings.parameters.file.SingleFile = ...
                uimenu(me.Menus.settings.parameters.File,...
                'Label','Use single parameter file',...
                'Separator','on',...
                'Callback',@(h,~) me.paramsSetSingleFile(h));
            me.Menus.settings.parameters.QuickLoad = ...
                uimenu(me.Menus.settings.Parameters,'Label','Quick Load','Separator','on','Callback',@(~,~)me.paramsQuickLoad());
            me.Menus.settings.parameters.QuickSave = ...
                uimenu(me.Menus.settings.Parameters,'Label','Quick Save','Callback',@(~,~)me.paramsQuickSave());
            me.Menus.settings.parameters.ManageValues = ...
                uimenu(me.Menus.settings.Parameters,'Label','Manage Values','Separator','on','Callback',@(~,~)me.Top.pgInit());            
            
            me.Menus.settings.DefaultMethods = ...
                uimenu(me.Menus.Settings,'Label','Default Methods');            
            me.Menus.settings.defaultMethods.DisplaySpectrogram = ...
                uimenu(me.Menus.settings.DefaultMethods,'Label','Display Spectrogram');
            me.Top.Methods.displaySpectrogram.createMenu(me.Menus.settings.defaultMethods.DisplaySpectrogram);            
        end
        
        % CONTEXT MENU
        function buildContextMenu(me)
            me.ContextMenuObject = bMainGuiContextMenu(me);
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
               
        % ADD / REMOVE FILES
        function addFiles(me)
            addFiles([]);
            me.refreshFilesTable();
        end
        function removeFiles(me)
            me.Application.removeFiles(me.SelectionRibbon.ProcessVector);
            me.refreshFilesTable();
            me.SelectionRibbon.changeDisplay([]);
            me.SelectionRibbon.changeProcess([]);
        end
        
        % REFRESH FILES TABLE
        function refreshFilesTable(me)
            N = appData('Files','Count');
            D = cell(N,6);
            for k = 1:N
                D{k,1} = fileData(k,'Name');
                D{k,2} = fileData(k,'Length');
                D{k,3} = fileData(k,'Fs');
                D{k,4} = fileData(k,'Channels','Count');
                D{k,5} = fileData(k,'Calls','Count');
                D{k,6} = fileData(k,'DataStatus');
            end
            set(me.FilesTable,'Data',D);            
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
                elseif d > 0
                    me.Graphs.addGraph(d);
                elseif -d > N
                    msgbox('error, use positive integer');
                    return;
                elseif d < 0
                    me.Graphs.removeGraph(-d);
                end
                me.Graphs.refreshDisplay();
                gsetParam('mainGui_nAxes',n);
            end
        end    
        
        
        % SHOW POIS
        function showPois(me,type)
            switch type
                case 'dont'
                case 'marks'
                case 'texts'
                otherwise
                    errid  = 'batalef:mainGui:showPois:wrongType';
                    errstr = sprintf('Wrong showPois type: %s',type);
                    err = MException(errid,errstr);
                    throwAsCaller(err);
            end
            gsetParam('mainGui_showPois',type);
            selectMenuItem(me.Menus.settings.display.Pois,type);
            me.Graphs.plot();
        end
        
        
        % SAVE / LOAS PARAMETERS (for file, app, gui)
        function paramsLoad(me,type)
            [fName,fPath] = uigetfile(me.Application.WorkingDirectory);
            relPath = relativepath(strcat(fPath,fName),me.Application.WorkingDirectory);
            switch type
                case 'app'
                    me.Application.Parameters.loadFromFile(relPath);
                case 'gui'
                    me.Top.Parameters.loadFromFile(relPath);
                case 'file'
                    me.Application.loadFileParams(relPath,me.ProcessVector);
                otherwise
                    err = MException('batalef:parameters:objectWrongType',sprintf('Parameters-object type %s is not allowed',type));
                    throwAsCaller(err);
            end            
        end
        function paramsSave(me,type)
            [fName,fPath] = uiputfile(me.Application.WorkingDirectory);
            relPath = relativepath(strcat(fPath,fName),me.Application.WorkingDirectory);
            switch type
                case 'app'
                    me.Application.Parameters.saveToFile(relPath);
                case 'gui'
                    me.Top.Parameters.saveToFile(relPath);
                case 'file'
                    me.Application.saveFileParams(relPath,me.ProcessVector);
                otherwise
                    err = MException('batalef:parameters:objectWrongType',sprintf('Parameters-object type %s is not allowed',type));
                    throwAsCaller(err);
            end            
        end
         function paramsQuickLoad(me)
            me.Application.Parameters.loadFromFile([]);
            me.Top.Parameters.loadFromFile([]);
            me.Application.loadFileParams([]);
        end
        function paramsQuickSave(me)
            me.Application.Parameters.saveToFile([]);
            me.Top.Parameters.saveToFile([]);
            me.Application.saveFileParams([],[]);
        end        
        
        % SINGLE PARAMETRS FILE FOR FILES
        function paramsSetSingleFile(me,h)
            turnOn = strcmp(get(h,'Checked'),'off');
            me.Application.FilesSingleParamsFile = turnOn;
            if turnOn
                set(h,'Checked','on');
            else
                set(h,'Checked','off');
            end
        end
       
        % CONTEXT MENU GET
        function val = get.ContextMenu(me)
            val = me.ContextMenuObject.UIObject;
        end
        
        
    end
    
end

