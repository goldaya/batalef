classdef bFileCallsGui < bGuiDefinition & hgsetget
    %BFILECALLSGUI File call matching & localization gui
    
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

    properties
        FileIdx
        File
        Matching
        Localization
    end
    
    properties (Hidden)
        CallIdxPanel
          TextCallIdx
          ButtonSelectAll
          ButtonX
          
        ButtonsPanel
          ComboBaseChannel
          ComboBaseCall
          TextAllowedError
          ButtonFindMatches
          ComboSeqs
          ButtonAccept
          ButtonAcceptAll
          ToggleAxes
          
        CallsTable
        
        AxesPixels
        AxesFigure
          AxesObject
          
        MenuMatchingMethods
        MenuLocalizationMethods
        
        InteractiveUis
    end
    
    properties (Constant,Hidden)
        TableLineHeight = 1.4;
        MinHeight = 10*bFileCallsGui.TableLineHeight+4+4.3+0.5;
        MinWidth  = 120;
    end
    
    properties (Dependent)
        BaseChannel
        BaseCall
    end
    
    
    methods

        % CONSTRUCTOR
        function me = bFileCallsGui(guiTop,name)
            me = me@bGuiDefinition(guiTop,name);
            me.Build = true;
            me.Matching = me.Application.Methods.fileCallsMatching;
            me.Localization = me.Application.Methods.fileCallLocalization;
            
            % figure
            fpos = [0,0,me.MinWidth,me.MinHeight];
            me.Figure = figure(...
                'WindowStyle','normal',...
                'Units','character',...
                'Position',fpos,...
                'Visible','off',...
                'ToolBar','none',...
                'MenuBar','none',...
                'Name','BATALEF - File Calls Matching & Localization',...
                'NumberTitle','off',...
                'CloseRequestFcn',@(~,~)me.Top.removeGui(me.Name));
            if verLessThan('matlab', bGuiDefinition.ResizeVersion)
                set(me.Figure,'ResizeFcn',@(~,~)me.resize());
            else
                set(me.Figure,'SizeChangedFcn',@(~,~)me.resize()); 
            end
            
            me.SelectionRibbon = bSelectionRibbon(me,false,true);
            me.buildCallIdxPanel();
            me.buildButtonsPanel();
            me.buildTable();
            me.buildMenus();
            
            % finish build
            me.Build = false;
            scrSize = uiPosition(0,'pixel');
            fpos = uiPosition(me.Figure,'pixel');
            pos = [(scrSize(3)-fpos(3))/2-fpos(4),(scrSize(4)-fpos(4))/2,fpos(3),fpos(4)];
            if pos(1) < 0 
                pos(1) = 0;
            end
            me.AxesPixels = pos(4);
            set(me.Figure,'Units','pixel','Position',pos);
            set(me.Figure,'Units','character');
            set(me.Figure,'Visible','on');
            me.showPathAxes(true);
            me.setDisplayedFiles(me.DisplayVector)
        end
        
        % DESTRUCTOR
        function delete(me)
            me.Matching.removeMenu(me.MenuMatchingMethods);
            me.Localization.removeMenu(me.MenuLocalizationMethods);            
            me.showPathAxes(false);
            delete(me.Figure);
        end
        
        
        % CALL IDX SELECTOR
        function buildCallIdxPanel(me)
            pos = uiPosition(me.SelectionRibbon.Panel,'characters');
            ppos = [pos(3)-30,0,30,pos(4)];
            me.CallIdxPanel = uipanel(me.SelectionRibbon.Panel,'Units','character','Position',ppos,'BorderType','none');
            
            uicontrol(me.CallIdxPanel,...
                'Style','text',...
                'Units','character',...
                'Position',[2,2.5,16,1.2],...
                'String','Call Idx:',...
                'HorizontalAlignment','left');
            me.TextCallIdx = uicontrol(me.CallIdxPanel,...
                'Style','edit',...
                'Units','character',...
                'Position',[18,2.4,10,1.4],...
                'String','');            
            
            me.ButtonSelectAll = uicontrol(me.CallIdxPanel,...
                'Style','pushbutton',...
                'Units','character',...
                'Position',[2,0.5,16,1.4],...
                'HorizontalAlignment','center',...
                'String','Select All',...
                'Callback',@(~,~)set(me.TextCallIdx,'String',int2str_compact(me.Application.file(me.DisplayVector(1)).CallsCount)));
            
            me.ButtonX = uicontrol(me.CallIdxPanel,...
                'Style','pushbutton',...
                 'Units','character',...
                'Position',[22,0.5,6,1.4],...
                'String','X',...
                'HorizontalAlignment','center',...
                'Callback',@(hObject,~)me.deleteCalls());
            
            me.InteractiveUis = {me.TextCallIdx,me.ButtonSelectAll,me.ButtonX};

        end
        
        % BUTTONS PANEL
        function buildButtonsPanel(me)
            fpos = uiPosition(me.Figure,'character');
            ppos = [0,fpos(4)-4.3-4,fpos(3),4];
            
            me.ButtonsPanel = uipanel(me.Figure,...
                'Units','character',...
                'Position',ppos,...
                'BorderType','none');
            
            bp = me.ButtonsPanel;
            
            uicontrol(bp,...
                'Style','text',...
                'Units','character',...
                'Position',[2,2.4,16,1.2],...
                'HorizontalAlignment','left',...
                'String','Base Channel');
            me.ComboBaseChannel = uicontrol(bp,...
                'Style','popupmenu',...
                'Units','character',...
                'Position',[20,2.3,10,1.4],...
                'String','f00',...
                'Value',1,...
                'Callback',@(~,~)me.refreshBaseCallsList());
            
            uicontrol(bp,...
                'Style','text',...
                'Units','character',...
                'Position',[35,2.4,16,1.2],...
                'HorizontalAlignment','left',...
                'String','Base Call');
            me.ComboBaseCall = uicontrol(bp,...
                'Style','popupmenu',...
                'Units','character',...
                'Position',[53,2.3,10,1.4],...
                'String','f00',...
                'Value',1);
            
            uicontrol(bp,...
                'Style','text',...
                'Units','character',...
                'Position',[68,2.4,20,1.2],...
                'HorizontalAlignment','left',...
                'String','Allowed Error (%)');
            me.TextAllowedError = uicontrol(bp,...
                'Style','edit',...
                'Units','character',...
                'Position',[90,2.3,7,1.4],...
                'String',agetParam('fileCalls_matchingError','AsString'));
            
            me.ButtonFindMatches = uicontrol(bp,...
                'Style','pushbutton',...
                'Units','character',...
                'Position',[101,2.3,17,1.4],...
                'String','Find Matches',...
                'Callback',@(~,~)me.match());
            
            uicontrol(bp,...
                'Style','text',...
                'Units','character',...
                'Position',[2,0.4,16,1.2],...
                'String','Possible Seq.');
            me.ComboSeqs = uicontrol(bp,...
                'Style','popupmenu',...
                'Units','character',...
                'Position',[20,0.3,43,1.4],...
                'String','N/A',...
                'Value',1);

            me.ButtonAccept = uicontrol(bp,...
                'Style','pushbutton',...
                'Units','character',...
                'Position',[68,0.3,12,1.4],...
                'String','Accept',...
                'Callback',@(~,~)me.accept());
            me.ButtonAcceptAll = uicontrol(bp,...
                'Style','pushbutton',...
                'Units','character',...
                'Position',[82,0.3,15,1.4],...
                'String','Accept All',...
                'Callback',@(~,~)me.acceptAll());
            
            me.ToggleAxes = uicontrol(bp,...
                'Style','toggle',...
                'Units','character',...
                'Position',[101,0.3,17,1.4],...
                'String','Loc. Graph',...
                'Value',1,...
                'Callback',@(h,~)me.showPathAxes(get(h,'Value')));
            
            
            me.InteractiveUis = [me.InteractiveUis,...
                {me.ComboBaseChannel,...
                me.ComboBaseCall,...
                me.TextAllowedError,...
                me.ButtonFindMatches,...
                me.ComboSeqs,...
                me.ButtonAccept,...
                me.ButtonAcceptAll}];
        end
        
        % BUILD TABLE (this is just the frame, see me.setTableColums() for
        % complete build)
        function buildTable(me)
            tpos = [2,0.5,me.MinWidth-4,10*me.TableLineHeight];
            me.CallsTable = uitable(me.Figure,...
                'Units','character',...
                'Position',tpos);
            me.InteractiveUis = [me.InteractiveUis,{me.CallsTable}];
        end
        
        % MENUS
        function buildMenus(me)
            me.MenuMatchingMethods = uimenu(me.Figure,'Label','Matching');
            me.Matching.createMenu(me.MenuMatchingMethods,me)
            
            m1 = uimenu(me.Figure,'Label','Localization');
            me.MenuLocalizationMethods = uimenu(m1,'Label','Methods');
            me.Localization.createMenu(me.MenuLocalizationMethods,me)
            
            
        end
        
        % RESIZE
        function resize(me)
            fpos = uiPosition(me.Figure,'character');
            if fpos(3) < me.MinWidth || fpos(4) < me.MinHeight
                warning('off','backtrace');
                warning('batalef:localizationGui:guiTooSmall','File Calls Match & Localizations: The GUI size is too small');
                warning('on','backtrace');
                return;
            end            
            
            % ribbon
            rpos = uiPosition(me.SelectionRibbon.Panel,'character');
            rpos(2) = fpos(4) - rpos(4);
            rpos(3) = fpos(3);
            set(me.SelectionRibbon.Panel,'Units','character','Position',rpos);
            
            % keep buttons panel on top of the table and centerlize
            bpos = uiPosition(me.ButtonsPanel,'character');
            pos = [0,fpos(4)-rpos(4)-bpos(4),fpos(3),bpos(4)];
            set(me.ButtonsPanel,'Units','character','Position',pos);
            
            % table
            pos = [2,0.5,fpos(3)-4,fpos(4)-bpos(4)-0.5-rpos(4)];
            set(me.CallsTable,'Units','character','Position',pos);            
            
        end
        
        
        %%%%%%%%%%%%%%%%%%%
        %%%             %%%
        %%%   DISPLAY   %%%
        %%%             %%%
        %%%%%%%%%%%%%%%%%%%
        
        % REFRESH
        function refresh(me)
        end
        
        % DISPLAY SELECTED FILES
        function setDisplayedFiles(me,V)
            if isempty(V)
                cellfun(@(h)set(h,'Enable','on'),me.InteractiveUis);
                D = [];
                set(me.CallsTable,'Data',D);
%                 set(me.ComboBaseChannel,'String',cellfun(@(i)num2str(i),(num2cell((1:50)')),'UniformOutput',false));
                set(me.ComboBaseChannel,'Value',1);
                set(me.ComboBaseChannel,'String','N/A');                
%                 set(me.ComboBaseCall,'String',cellfun(@(i)num2str(i),(num2cell((1:100)')),'UniformOutput',false));
                set(me.ComboBaseCall,'Value',1);
                set(me.ComboBaseCall,'String','N/A');                                
                set(me.ComboSeqs,'Value',1);
                set(me.ComboSeqs,'String','N/A');                                                
            else
                cellfun(@(h)set(h,'Enable','on'),me.InteractiveUis);
                me.FileIdx = V(1);
                me.File = me.Application.file(me.FileIdx);
                set(me.ComboBaseChannel,'String',cellfun(@(i)num2str(i),(num2cell((1:50)')),'UniformOutput',false));
                set(me.ComboBaseChannel,'Value',1);
                set(me.ComboBaseChannel,'String',cellfun(@(i)num2str(i),(num2cell((1:me.File.ChannelsCount)')),'UniformOutput',false));
                me.refreshBaseCallsList();
                me.setTableColumns();
            end
        end
        
        % REFRESH BASE CALLS LIST
        function refreshBaseCallsList(me)
            baseChannel = me.BaseChannel;
            if isempty(baseChannel)
                str = 'N/A';
            else
                v = me.File.getChannelFileCalls(baseChannel);
                if isempty(v)
                    str = 'N/A';
                else
                    str = arrayfun(@(i){num2str(i)},find(isnan(v)));
                end
            end
            set(me.ComboBaseCall,'Value',1);
            set(me.ComboBaseCall,'String',str);
        end
        
        % PLOT FLIGHT PATH
        function plotPath(me)
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%                      %%%
        %%%   PULLS AND LEVERS   %%%
        %%%                      %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%  

        % DELETE CALLS
        function deleteCalls(me)
        end
        
        % MATCH
        function match(me)
            set(me.ComboSeqs,'Value',1);
            
            S = me.Matching.execute(me.File,me.BaseChannel,me.BaseCall);
            if isempty(S)
                str = 'N/A';
            else
                str = cellfun(@(s)seq2string(s),S,'UniformOutput',false);
            end
            
            set(me.ComboSeqs,'String',str);
            
        end
        
        % ACCEPT
        function accept(me)
        end
        
        % ACCEPT ALL
        function acceptAll(me)
        end
        
        % SET TABLE COLUMNS
        function setTableColumns(me)
            if isempty(me.File)
                return;
            end
            
            n = me.File.ChannelsCount;
            uitabColNames = [{'Time','Location'},arrayfun(@(i){num2str(i)},1:n)];
            uitabColWidths = arrayfun(@(i){50},1:n+2);
            uitabColWidths{1} = 100;
            uitabColWidths{2} = 100;
            uitabColFormats = arrayfun(@(i){'numeric'},1:n);
            set(me.CallsTable,...
                    'Units','pixels',...
                    'columnname',uitabColNames,...
                    'columnformat',uitabColFormats,...
                    'ColumnWidth',uitabColWidths,...
                    'ColumnEditable',false(1,n+2));
            
        end
                
        % SHOW / HIDE LOCALIZATION AXES
        function showPathAxes(me,show)
            if show && ( isempty(me.AxesFigure) || ~ishandle(me.AxesFigure) )
                fpos = uiPosition(me.Figure,'pixel');
                me.AxesFigure = figure('WindowStyle','normal',...
                    'Units','pixels',...
                    'Position',[fpos(1)+fpos(3),fpos(2),fpos(4),fpos(4)],...
                    'Name','BATALEF - Flight Path',...
                    'MenuBar','none',...
                    'ToolBar','figure',...
                    'NumberTitle','off',...
                    'CloseRequestFcn',@(~,~)me.showPathAxes(false));
                me.plotPath();
                set(me.ToggleAxes,'Value',1);
            elseif show
                figure(me.AxesFigure);
                me.plotPath();
                set(me.ToggleAxes,'Value',1);
            elseif ~isempty(me.AxesFigure)
                if ishandle(me.AxesFigure)
                    delete(me.AxesFigure);
                end
                clear me.AxesFigure;
                set(me.ToggleAxes,'Value',0);
            end
        end
            
        % GET BASE CHANNEL
        function val = get.BaseChannel(me)
            str = get(me.ComboBaseChannel,'String');
            if strcmp(str,'N/A')
                val = [];
            else
                v = get(me.ComboBaseChannel,'Value');
                val = str2double(str{v});
            end
        end
        
        % GET BASE CHANNEL
        function val = get.BaseCall(me)
            str = get(me.ComboBaseCall,'String');
            if strcmp(str,'N/A')
                val = [];
            else
                v = get(me.ComboBaseCall,'Value');
                val = str2double(str{v});
            end
        end
        
    end
    
end

