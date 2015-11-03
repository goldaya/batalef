classdef bMainGui < bGuiDefinition
%BMAINGUI Object to handle batalef's main gui

    % properties coming from gui definition:
    %{
    properties
        Figure
        Name
    end
    
    properties (Hidden)
        Top
        SelectionRibbon
        Build
    end
    
    properties (Dependent)
        RibbonsLinked    
        Visible
        Parameters
        Application        
        DisplayVector
        ProcessVector
    end
    %}
    
    properties (Access = private)
        FilesTable
        Menus
    end
    
    properties (SetAccess = private, GetAccess = public)
        ContextMenuObject
        Graphs
        DetectionSettings        
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
        function me = bMainGui(guiTop,name)
            me = me@bGuiDefinition(guiTop,name);
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
            me.showChannelCalls(ggetParam('mainGui_showChannelCalls'));
        end
        
        % BUILD MENUS
        function buildMenus(me)
            % batalef
            me.Menus.Batalef = uimenu(me.Figure,'Label','Batalef');
            me.Menus.batalef.Export = uimenu(me.Menus.Batalef,'Label','Export Data','Callback',@(~,~)me.exportData());
            me.Menus.batalef.Import = uimenu(me.Menus.Batalef,'Label','Import Data','Callback',@(~,~)me.importData());
            me.Menus.batalef.Exit = uimenu(me.Menus.Batalef,'Label','Exit','Callback',@(~,~)batalefGuiKill(me.Top),'Separator','on');
            
            % files
            me.Menus.Files = uimenu(me.Figure,'Label','Files');
            me.Menus.files.Add = ...
                uimenu(me.Menus.Files,'Label','Add Files','Callback',@(~,~)me.addFiles());
            me.Menus.files.Remove = ...
                uimenu(me.Menus.Files,'Label','Remove Files','Callback',@(~,~)me.removeFiles());
            me.Menus.files.Overwrite = ...
                uimenu(me.Menus.Files,'Separator','on','Label','Overwrite Files','Callback',@(~,~)me.overwriteFiles());
            me.Menus.files.CreateFile = ...
                uimenu(me.Menus.Files,'Label','Create File','Callback',@(~,~)me.createFile());
            me.Menus.files.LoadExplicit = ...
                uimenu(me.Menus.Files,'Label','Load Raw Data Explicitly','Separator','on','Callback',@(~,~)me.loadExplicit());
            me.Menus.files.Unload = ...
                uimenu(me.Menus.Files,'Label','Unload Raw Data','Callback',@(~,~)me.unloadRawData());            
            
            % pre-processing
            me.Menus.PreProcessing = uimenu(me.Figure,'Label','Pre Processing');
            me.Menus.preProcessing.Filter = ...
                uimenu(me.Menus.PreProcessing,'Label','Filter');
            me.Application.Methods.preProcFilter.createMenu(me.Menus.preProcessing.Filter,me);
            me.Menus.preProcessing.Wildcard = ...
                uimenu(me.Menus.PreProcessing,'Label','Wildcard Function','Callback',@(~,~)me.wildcardFunction());
            me.Menus.preProcessing.Playground = ...
                uimenu(me.Menus.PreProcessing,'Label','Playground','Callback',@(~,~)me.playground());
            me.Menus.preProcessing.Refresh = ...
                uimenu(me.Menus.PreProcessing,'Label','Refresh Raw Data','Separator','on','Callback',@(~,~)me.refreshRawData());

            % channel level processing
            me.Menus.ChannelCalls = uimenu(me.Figure,'Label','Channel Calls');
            me.Menus.channelCalls.Detection = ...
                uimenu(me.Menus.ChannelCalls,'Label','Detection');
            me.Menus.channelCalls.detection.Detect = ...
                uimenu(me.Menus.channelCalls.Detection,'Label','Detect');
            me.Application.Methods.channelCallsDetection.createMenu(me.Menus.channelCalls.detection.Detect,me);
            me.Menus.channelCalls.detection.Envelope = ...
                uimenu(me.Menus.channelCalls.Detection,'Label','Envelope');
            me.Application.Methods.detectionEnvelope.createMenu(me.Menus.channelCalls.detection.Envelope,me);
            me.Menus.channelCalls.detection.Filter = ...
                uimenu(me.Menus.channelCalls.Detection,'Label','Filter');
            me.Application.Methods.detectionFilter.createMenu(me.Menus.channelCalls.detection.Filter,me);

            me.Menus.channelCalls.Clear = ...
                uimenu(me.Menus.ChannelCalls,'Label','Clear','Callback',@(~,~)me.clearChannelCalls());
            
            me.Menus.channelCalls.detection.SegmentNone = ...
                uimenu(me.Menus.channelCalls.Detection,...
                'Label','No Segmentation','Callback',@(~,~)me.setSegmentation('none'),'Separator','on');
            me.Menus.channelCalls.detection.SegmentPiecewise = ...
                uimenu(me.Menus.channelCalls.Detection,...
                'Label','Piecewise','Callback',@(~,~)me.setSegmentation('piecewise'));
            me.Menus.channelCalls.detection.SegmentManual = ...
                uimenu(me.Menus.channelCalls.Detection,...
                'Label','Manual Interval','Callback',@(~,~)me.setSegmentation('manual'));
            me.setSegmentation('none');
            
            me.Menus.channelCalls.CallGui = ...
                uimenu(me.Menus.ChannelCalls,'Label','Call Analysis GUI','Callback',@(~,~)me.callCallGui([]));
            
            me.Menus.channelCalls.GetTable = ...
                uimenu(me.Menus.ChannelCalls,'Label','Get calls table','Callback',@(~,~)me.getChannelCallsTable());
            
            
            % file level processing
            me.Menus.File = uimenu(me.Figure,'Label','File Level Proc.');
            me.Menus.file.MicAdmin = uimenu(me.Menus.File,'Label','Mic Admin','Callback',@(~,~)me.Top.callGui('MicAdmin'));
            me.Menus.file.Matching = uimenu(me.Menus.File,'Label','Matching & Localization','Callback',@(~,~)me.Top.callGui('Localization'));
            me.Menus.file.Beam = uimenu(me.Menus.File,'Label','Beam Analysis','Callback',@(~,~)me.Top.callGui('Beam'));
            
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
                uimenu(me.Menus.settings.display.Pois,'Label','Dont show','UserData',{'dont',me},'Callback',@(~,~)me.showPois('dont'));
            me.Menus.settings.display.pois.Marks = ...
                uimenu(me.Menus.settings.display.Pois,'Label','Show marks','UserData',{'marks',me},'Callback',@(~,~)me.showPois('marks'));
            me.Menus.settings.display.pois.Texts = ...
                uimenu(me.Menus.settings.display.Pois,'Label','Show marks & texts','UserData',{'texts',me},'Callback',@(~,~)me.showPois('texts'));            

            me.Menus.settings.display.ChannelCalls = ...
                uimenu(me.Menus.settings.Display,'Label','Channel Calls');
            me.Menus.settings.display.channelCalls.Dont = ...
                uimenu(me.Menus.settings.display.ChannelCalls,'Label','Dont show','UserData',{'dont',me},'Callback',@(~,~)me.showChannelCalls('dont'));
            me.Menus.settings.display.channelCalls.Marks = ...
                uimenu(me.Menus.settings.display.ChannelCalls,'Label','Show marks','UserData',{'marks',me},'Callback',@(~,~)me.showChannelCalls('marks'));
            me.Menus.settings.display.channelCalls.Numbered = ...
                uimenu(me.Menus.settings.display.ChannelCalls,'Label','Show numbered marks','UserData',{'numbered',me},'Callback',@(~,~)me.showChannelCalls('numbered'));            
            
            me.Menus.settings.display.DisplaySpectrogram = ...
                uimenu(me.Menus.settings.Display,'Label','Display Spectrogram');
            me.Top.Methods.displaySpectrogram.createMenu(me.Menus.settings.display.DisplaySpectrogram,me);
            
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
                uimenu(me.Menus.settings.Parameters,'Label','Manage Values','Separator','on','Callback',@(~,~)me.Top.callGui('Parameters'));            
            
            switch agetParam('rawData_position');
                case 'internal'
                    intCheck = 'on';
                    extCheck = 'off';
                case 'external'
                    intCheck = 'off';
                    extCheck = 'on';                    
            end
            me.Menus.settings.DefRawDataPosition = ...
                uimenu(me.Menus.Settings,'Label','Default Raw Data Position');
            me.Menus.settings.defRawDataPosition.Internal = ...
                uimenu(me.Menus.settings.DefRawDataPosition,'Label','Internal','Callback',@(h,~)me.setDefRawDataPosition('internal',h),'Checked',intCheck);
            me.Menus.settings.defRawDataPosition.External = ...
                uimenu(me.Menus.settings.DefRawDataPosition,'Label','External','Callback',@(h,~)me.setDefRawDataPosition('external',h),'Checked',extCheck);
            
        end
        
        % CONTEXT MENU
        function buildContextMenu(me)
            me.ContextMenuObject = bMainGuiContextMenu(me);
        end
        
        
        % RESIZE
        function resize(me)
            
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
        
       
        %%%%%%%%%%%%%%%%%
        %%% GUI STUFF %%%
        %%%%%%%%%%%%%%%%%

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
            me.Graphs.replotPoi();
        end
        
        % SHOW CHANNEL CALLS
        function showChannelCalls(me,type)
            switch type
                case 'dont'
                case 'marks'
                case 'numbered'
                otherwise
                    errid  = 'batalef:mainGui:showChannelCalls:wrongType';
                    errstr = sprintf('Wrong showChannelCalls type: %s',type);
                    err = MException(errid,errstr);
                    throwAsCaller(err);
            end
            gsetParam('mainGui_showChannelCalls',type);
            selectMenuItem(me.Menus.settings.display.ChannelCalls,type);
            me.Graphs.replotChannelCalls();
        end        
        
        % CONTEXT MENU GET
        function val = get.ContextMenu(me)
            val = me.ContextMenuObject.UIObject;
        end
        
        % REFRESH (OBLIGATORY FOR ALL GUIs)
        function refresh(me)
            me.Graphs.plot();
        end                
        
        %%%%%%%%%%%%%%
        % PARAMETERS %
        %%%%%%%%%%%%%%
        
        % SAVE / LOAD PARAMETERS (for file, app, gui)
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

        
        %%%%%%%%%%%%%%%%%%
        % FILES HANDLING %
        %%%%%%%%%%%%%%%%%%
               
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
        
        % CREATE NEW FILE
        function createFile(me)
            V = me.ProcessVector;
            if isempty(V)
                msgbox('No files selected');
                return;
            end
            Q{1} = sprintf('You are creating a new audio file from files: %s\n\nChannels to use (leave "All" if all channels are wanted',int2str_compact(V));
            D{1} = 'All';
            T    = 'Create Audio File';
            A = inputdlg(Q,T,[1,100],D);
            if ~isempty(A)
                [name,path] = uiputfile('*.wav');
                filepath = strcat(path,name);
                if strcmp(A{1},'All')
                    C = [];
                else
                    C = str2int_compact(A{1});
                end
                try
                    createMixFile(V,C,filepath);
                    A = questdlg(sprintf('Mix file created successfully\nDo you want to load the new file into batalef now?'),'Mix files','Yes','No','Yes');
                    if strcmp(A,'Yes')
                        addFiles(path,name);
                        me.refreshFilesTable();
                    end
                catch err
                    filterError(err,'batalef:files:mixFile:create');
                    msgbox(err.message);
                end
            end
        end
        
        % OVERWRITE FILES
        function overwriteFiles(me)
            V = me.ProcessVector;
            if isempty(V)
                msgbox('No files selected');
                return;
            end
            overwriteFiles(V);
        end
        
        % EXPORT DATA
        function exportData(me)
            Q = {'Discard channel call analysis datasets','Include audio explicitly'};
            D = true(2,1);
            T = 'Export Data';
            A = cbdlg(Q,T,D);
            if isempty(A)
                return;
            end
                
            [fname,fpath] = uiputfile('*.mat');
            if isnumeric(fname)
                return;
            else
                X = me.Application.filesToStruct(me.ProcessVector,A(2),A(1));
                save(strcat(fpath,fname),'X','-v7.3');
                msgbox('Exported');
            end
        end
        
        % IMPORT DATA
        function importData(me)
            [fname,fpath] = uigetfile('*.mat','MultiSelect','on');
            if ~fname
                return;
            else
                hello = load(strcat(fpath,fname));
                me.Application.addFilesFromStructre(hello.X)
            end
            me.refreshFilesTable();
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% RAW DATA MANIPULATION %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % SET DEFAULT RAW DATA POSITION
        function setDefRawDataPosition(me,pos,h)
            asetParam('rawData_position',pos);
            set(me.Menus.settings.defRawDataPosition.Internal,'Checked','off');
            set(me.Menus.settings.defRawDataPosition.External,'Checked','off');
            set(h,'Checked','on');
        end
        
        % LOAD EXPLICIT
        function loadExplicit(me)
            V = me.ProcessVector;
            if isempty(V)
                msgbox('No files selected');
                return;
            else
                A = questdlg('Any changes made to the raw data (in pre-prcess phase) will be lost. Continue?','Load Raw Data Explicitly','Yes','No','Yes');
                if strcmp(A,'Yes')
                    loadRawDataExplicit(V,'internal');
                end
            end
            me.refreshFilesTable();
            me.refresh();
        end
        
        % UNLOAD RAW DATA
        function unloadRawData(me)
            V = me.ProcessVector;
            if isempty(V)
                msgbox('No files selected');
                return;
            else
                A = questdlg('Any changes made to the raw data (in pre-prcess phase) will be lost. Continue?','Unload Raw Data','Yes','No','Yes');
                if strcmp(A,'Yes')
                    loadRawDataExplicit(V,'external');
                end
            end
            me.refreshFilesTable();
            me.refresh();
        end
            
        % WILDCARD
        function wildcardFunction(me)
            V = me.ProcessVector;
            if isempty(V)
                msgbox('No files selected');
                return;
            else
                A = inputdlg('Function name','Apply Wildcard Function on TS',[1,80]);
                if ~isempty(A)
                    applyWildcardFunction(V,A{1});
                end
            end
            me.refreshFilesTable();
            me.refresh();
        end
        
        % TS PLAYGROUND
        function playground(me)
            V = me.ProcessVector;
            if isempty(V)
                msgbox('No file selected');
                return;
            elseif length(V) > 1
                msgbox('Cannot process more than one file');
                return;
            else
                RawDataObject = me.Application.file(V).RawData;
                clear V;
                TS = RawDataObject.getTS([],[]);
                Fs = RawDataObject.Fs;
                msgbox('You entered playground mode. Type "dbcont" in console to finish. Please do not change / delete the "RawDataObject" and "me" variables. You can change the "TS" variable (Time Signal, samples X channels) and "Fs" (sampling rate).');
                keyboard;
                RawDataObject.alter(TS,{'Playground',NaN},Fs);
            end
            me.refreshFilesTable();
            me.refresh();
        end
        
        % REFRESH RAW DATA
        function refreshRawData(me)
           V = me.ProcessVector;
            if isempty(V)
                msgbox('No files selected');
                return;
            else
                A = questdlg('Any changes made to the raw data (in pre-prcess phase) will be lost. Continue?','Refresh Raw Data','Yes','No','Yes');
                if strcmp(A,'Yes')
                    loadRawDataExplicit(V,agetParam('rawData_position'));
                end
            end
            me.refreshFilesTable();
            me.refresh();
        end
        
        %%%%%%%%%%%%%%%%%%%%%
        %%% CHANNEL CALLS %%%
        %%%%%%%%%%%%%%%%%%%%%
        
        % SEGMENTATION
        function setSegmentation(me,type)
            aNO = 'off';
            aPW = 'off';
            aMN = 'off';
            
            segment.type   = type;
            segment.params = [];

            switch type
                case 'none'
                    aNO = 'on';

                case 'piecewise'
                    aPW = 'on';
                    Q{1} = 'Window Length (msec)';
                    D{1} = agetParam('channelCalls_detection_piecewiseWindow','AsString');
                    Q{2} = 'Overlap (msec)';
                    D{2} = agetParam('channelCalls_detection_piecewiseOverlap','AsString');
                    T    = 'Piecewise Calls Detection Settings';
                    A = inputdlg(Q,T,[1 70],D);
                    if isempty(A)
                        return;
                    else
                        segment.params.window  = str2double(A{1});
                        segment.params.overlap = str2double(A{2});
                    end
                case 'manual'
                    aMN = 'on';
                    Q{1} = 'From time (sec)';
                    Q{2} = 'To time (sec)';
                    A = inputdlg(Q,'Manual detection segment');
                    if isempty(A)
                        return;
                    else
                        segment.params.interval = [str2double(A{1}),str2double(A{2})];
                    end
            end
            me.DetectionSettings.segmentation = segment;
            set(me.Menus.channelCalls.detection.SegmentNone,'Checked',aNO);
            set(me.Menus.channelCalls.detection.SegmentPiecewise,'Checked',aPW);
            set(me.Menus.channelCalls.detection.SegmentManual,'Checked',aMN);            
        end
        
        % CLEAR
        function clearChannelCalls(me)
            V = me.ProcessVector;
            if isempty(V)
                msgbox('No files selected');
                return;
            else
                Files = me.Application.Files(V);
                cellfun(@(f)f.initChannelCallsData(),Files,'UniformOutput',false);
                me.refreshFilesTable();
                me.refresh();
            end
        end
        
        % CALL CALL ANALYSIS GUI
        function callCallGui(me,V)
            g = me.Top.callGui('CallAnalysis');
            if ~isempty(V)
                g.gotoCall(V);
            end
        end

        % GET TABLE
        function getChannelCallsTable(me)
            Q = {'With points of interest? [Yes/No]','Variable to assign'};
            D = {'Yes','callsTable'};
            A = inputdlg(Q,'Output Channel Calls Table',[1,70],D);
            if isempty(A)
                withPoi = true;
            else
                if strcmp(A{1},'Yes')
                    withPoi = true;
                else
                    withPoi = false;
                end
            end

            T = getChannelCallsTable(me.Application,me.ProcessVector,withPoi,'features');
            disp(T)
            fprintf('\n  All times are in seconds.\n  All frequencies are in Hz.\n  All power values are in dB.\n  Ridge matrix is [time,freq,power].\n\n');            
            
            if ~isempty(A)
                assignin('base',A{2},T);
            end
        end

        
    end
    
end

