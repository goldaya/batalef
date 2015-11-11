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
          ButtonMatch
          TextAllowedError
          ComboTimePoint
          ButtonMatchAll
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
        CallsVector
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
%             me.Matching.removeMenu(me.MenuMatchingMethods);
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
                'Callback',@(~,~)set(me.TextCallIdx,'String',int2str_compact(1:me.Application.file(me.DisplayVector(1)).CallsCount)));
            
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
                'Position',[20,2.3,13,1.4],...
                'String','f00',...
                'Value',1,...
                'Callback',@(~,~)me.refreshBaseCallsList());
            
            uicontrol(bp,...
                'Style','text',...
                'Units','character',...
                'Position',[2,0.4,16,1.2],...
                'HorizontalAlignment','left',...
                'String','Base Call');
            me.ComboBaseCall = uicontrol(bp,...
                'Style','popupmenu',...
                'Units','character',...
                'Position',[20,0.3,13,1.4],...
                'String','f00',...
                'Value',1);
            
            uicontrol(bp,...
                'Style','text',...
                'Units','character',...
                'Position',[38,2.4,20,1.2],...
                'HorizontalAlignment','left',...
                'String','Allowed Error (%)');
            me.TextAllowedError = uicontrol(bp,...
                'Style','edit',...
                'Units','character',...
                'Position',[60,2.3,13,1.4],...
                'String',agetParam('methods_fileCallsMatching_basic_error','AsString'),...
                'Callback',@(h,~)asetParam('methods_fileCallsMatching_basic_error',str2double(get(h,'String'))));
            
            uicontrol(bp,...
                'Style','text',...
                'Units','character',...
                'Position',[38,0.4,20,1.2],...
                'HorizontalAlignment','left',...
                'String','Time Point');
            me.ComboTimePoint = uicontrol(bp,...
                'Style','popupmenu',...
                'Units','character',...
                'Position',[60,0.3,13,1.4],...
                'String',{'Start','Peak','End'},...
                'Value',find(strcmp({'Start','Peak','End'},agetParam('methods_fileCallsMatching_basic_time')),1),...
                'Callback',@(h,~)asetParam('methods_fileCallsMatching_basic_time',comboSelected(h)));
            
            me.ButtonMatch = uicontrol(bp,...
                'Style','pushbutton',...
                'Units','character',...
                'Position',[75,2.3,15,1.4],...
                'String','Match',...
                'Callback',@(~,~)me.match(false));
            me.ButtonMatchAll = uicontrol(bp,...
                'Style','pushbutton',...
                'Units','character',...
                'Position',[75,0.3,15,1.4],...
                'String','Match All',...
                'Callback',@(~,~)me.match(true));
            
            me.ToggleAxes = uicontrol(bp,...
                'Style','toggle',...
                'Units','character',...
                'Position',[95,0.3,23,1.4],...
                'String','Show Loc. Graph',...
                'Value',1,...
                'Callback',@(h,~)me.showPathAxes(get(h,'Value')));
            
            
            me.InteractiveUis = [me.InteractiveUis,...
                {me.ComboBaseChannel,...
                me.ComboBaseCall,...
                me.TextAllowedError,...
                me.ComboTimePoint,...
                me.ButtonMatch,...
                me.ButtonMatchAll}];
        end
        
        % BUILD TABLE (this is just the frame, see me.setTableColums() for
        % complete build)
        function buildTable(me)
            tpos = [2,0.5,me.MinWidth-4,10*me.TableLineHeight];
            me.CallsTable = uitable(me.Figure,...
                'Units','character',...
                'Position',tpos,...
                'CellEditCallback',@(h,evt) me.onTableEdit(h,evt));
            me.InteractiveUis = [me.InteractiveUis,{me.CallsTable}];
            
        end
        
        % MENUS
        function buildMenus(me)
            %{
            me.MenuMatchingMethods = uimenu(me.Figure,'Label','Matching');
            me.Matching.createMenu(me.MenuMatchingMethods,me)
            %}
            
            m1 = uimenu(me.Figure,'Label','Localization');
            me.MenuLocalizationMethods = uimenu(m1,'Label','Methods');
            me.Localization.createMenu(me.MenuLocalizationMethods,me)
            m2 = uimenu(m1,'Label','Relocate from known path');
            uimenu(m2,'Label','From file','Callback',@(~,~)me.relocateFromPath('file'));
            uimenu(m2,'Label','From var','Callback',@(~,~)me.relocateFromPath('var'));
            
            
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
                set(me.ComboBaseChannel,'Value',1);
                set(me.ComboBaseChannel,'String','N/A');                
                set(me.ComboBaseCall,'Value',1);
                set(me.ComboBaseCall,'String','N/A');
                if ~isempty(me.AxesObject) && ishandle(me.AxesObject)
                    cla(me.AxesObject);
                end

            else
                cellfun(@(h)set(h,'Enable','on'),me.InteractiveUis);
                me.FileIdx = V(1);
                me.File = me.Application.file(me.FileIdx);
%                 set(me.ComboBaseChannel,'String',cellfun(@(i)num2str(i),(num2cell((1:50)')),'UniformOutput',false));
                set(me.ComboBaseChannel,'Value',1);
                set(me.ComboBaseChannel,'String',cellfun(@(i)num2str(i),(num2cell((1:me.File.ChannelsCount)')),'UniformOutput',false));
                me.refreshBaseValues(1,0);
                me.setTableColumns();
                me.refreshTableData();
                me.plotPath();
            end
            
        end
        
        % REFRESH BASE CALLS LIST
        function refreshBaseCallsList(me)
            baseChannel = me.BaseChannel;
            if isempty(baseChannel)
                str = 'N/A';
            elseif ~me.File.MicData.UseInLocalization(baseChannel)
                str = 'N/A';
            else
                v = me.File.getChannelFileCalls(baseChannel);
                if isempty(find(isnan(v),1))
                    str = 'N/A';
                else
                    str = arrayfun(@(i){num2str(i)},find(isnan(v)));
                end
            end
            set(me.ComboBaseCall,'Value',1);
            set(me.ComboBaseCall,'String',str);
        end
        
        % REFRESH BASE SELECTED VALUES (AUTOMATION)
        function refreshBaseValues(me,currBaseChannel,currBaseCall)
            [j,s] = getNextBase(me.File,currBaseChannel,currBaseCall);
            if j == 0
                % did not find any new base, just refresh current channel's
                % list. If there are no earlier channel calls, the display
                % will be 'N/A'...
                me.refreshBaseCallsList();
            else
                set(me.ComboBaseChannel,'Value',j);
                me.refreshBaseCallsList();
                S = get(me.ComboBaseCall,'String');
                v = find(strcmp(S,num2str(s)),1);
                set(me.ComboBaseCall,'Value',v);
            end
        end
        
        % REFRESH CALLS TABLE DISPLAY
        function refreshTableData(me)
            D = me.File.getCallsTable{:,:};
            set(me.CallsTable,'Data',D);
        end
        
        % PLOT FLIGHT PATH
        function plotPath(me)
            if isempty(me.Figure) || ~ishandle(me.Figure) || isempty(me.AxesObject) || ~ishandle(me.AxesObject)
                return;
            end
            
            % init with mic positions
            cla(me.AxesObject);
            if isempty(me.File)
                return;
            else
                axes(me.AxesObject);
            end
            P = me.File.MicData.Positions;
            scatter3(me.AxesObject,P(:,1),P(:,2),P(:,3),'r*'); 
            hold(me.AxesObject,'on');
            texts = arrayfun(@(j){num2str(j)},1:size(P,1),'UniformOutput',false);
            text(P(:,1),P(:,2),P(:,3),texts);
            hold(me.AxesObject,'off');            
            
            % add calls data and path
            Tab = me.File.getCallsTable(false);
            if ~isempty(Tab{:,:})
                % calls locations
                T = Tab{:,1};
                X = Tab{:,2};
                Y = Tab{:,3};
                Z = Tab{:,4};
                
                hold(me.AxesObject,'on');
                scatter3(me.AxesObject,X,Y,Z,'o');
                if size(T,1) == 1
                    texts = '1';
                else
                    texts = arrayfun(@(i){num2str(i)},1:size(T,1),'UniformOutput',false);
                end
                text(X,Y,Z,texts);

                % flight path
                if length(T) >= 2
                    Tspline = linspace(min(T), max(T), ggetParam('flightPath_spline_N'));
                    sX = spline(T,X, Tspline);
                    sY = spline(T,Y, Tspline);
                    sZ = spline(T,Z, Tspline);    
                    plot3(me.AxesObject, sX,sY,sZ);
                end
                hold( me.AxesObject, 'off' );     
        
            end
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%                      %%%
        %%%   PULLS AND LEVERS   %%%
        %%%                      %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%  

        % GET CALLS VECTOR
        function v = get.CallsVector(me)
            v = str2int_compact(get(me.TextCallIdx,'string'));
        end
        
        % DELETE CALLS
        function deleteCalls(me)
            me.File.removeCall(me.CallsVector);
            me.refreshTableData();
            me.plotPath();
            if isempty(me.BaseCall)
                baseCall = 0;
            else
                baseCall = me.BaseCall - 1;
            end
            me.refreshBaseValues(me.BaseChannel,baseCall);
            set(me.TextCallIdx,'String','');
        end
        
        % MATCH
        function match(me,all)
            
            if isempty(me.BaseChannel) || isempty(me.BaseCall)
                msgbox('Wrong base values');
            else
                if all
                    ok = matchAndAddFileCalls(me.Application,me.ProcessVector); 
                else
                    ok = matchAndAddFileCall(me.Application,me.FileIdx,me.BaseChannel,me.BaseCall); 
                end
                if ok
                    % refresh table
                    me.refreshTableData();
                    % refresh plot
                    me.plotPath();
                    % get next base
                    me.refreshBaseValues(me.BaseChannel,me.BaseCall);
                else
                    msgbox('Did not find match');
                    return;
                end
            end            
        end
        
        % SET TABLE COLUMNS
        function setTableColumns(me)
            if isempty(me.File)
                return;
            end
            
            n = me.File.ChannelsCount;
            uitabColNames      = [{'Time','X','Y','Z'},arrayfun(@(i){num2str(i)},1:n)];
            uitabColWidths     = arrayfun(@(i){35},1:n+4);
            uitabColWidths{1}  = 100;
            uitabColWidths{2}  = 70;
            uitabColWidths{3}  = 70;
            uitabColWidths{4}  = 70;
            uitabColFormats    = arrayfun(@(i){'numeric'},1:n);
            uitabColEditable   = true(1,n+4);
            uitabColEditable(1) = false;
            set(me.CallsTable,...
                    'Units','pixels',...
                    'columnname',uitabColNames,...
                    'columnformat',uitabColFormats,...
                    'ColumnWidth',uitabColWidths,...
                    'ColumnEditable',uitabColEditable);
            
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
                me.AxesObject = axes('Parent',me.AxesFigure);
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
        
        % ON TABLE EDIT
        function onTableEdit(me,~,evt)
            if evt.Indices(2) > 1
                if evt.Indices(2) > 4
                    j = evt.Indices(2) - 4;
                    % validate
                    if ~isnumeric(evt.NewData)
                        msgbox('Input should be the channel call index, or 0 to leave unassigned');
                        return;
                    elseif me.File.channel(j).CallsCount < evt.NewData
                        msgbox('Call index is bigger than the channel''s calls count');
                        return;
                    end
                    V = me.File.getChannelFileCalls(j);
                    if evt.NewData > 0 && ~isnan(V(evt.NewData))
                        msgbox(sprintf('Specified call is already assigned to file call #%i',V(evt.NewData)));
                        return;
                    end

                    % relocate & time (re-time needs more dev)
                    D = me.File.getCallsTable{:,:};
                    seq = D(evt.Indices(1),5:me.File.ChannelsCount+4);
                    seq(j) = evt.NewData;
                    x = localizeFileCall(me.File,seq);
                    %{
                    %T = zeros(me.File.ChannelsCount,1);
                    l = 1+(get(me.ComboTimePoint,'Value')-1)*4;
                    t = 0;
                    for i = 1:me.File.ChannelsCount
                        if seq(i) > 0
                            %T(i) = me.File.channel(i).CallsData.forLocalization(seq(i),l);
                            t = me.File.channel(i).CallsData.forLocalization(seq(i),l);
                            break;
                        end
                    end
                    %}
                    

                    % keep new data
                    callData = me.File.getCall(evt.Indices(1));
                    callData.location = x;
    %                 callData.time = t; more dev needed for time change:
    %                 re-sort file calls
                    callData.sequence = seq;
                    me.File.setCall(evt.Indices(1),callData);


                    me.refreshTableData();
                end
                me.plotPath();
            end
        end
        
        % RELOCATE FROM KNOWN PATH
        function relocateFromPath(me,intype)
            switch intype
                case 'file'
                    [fname,fpath] = uigetfile();
                    if isnumeric(fname)
                        return; % user abort
                    else
                        D = importdata(strcat(fpath,fname));
                    end
                case 'var'
                    A = inputdlg('Variable name');
                    if isempty(A)
                        return; %user abort
                    else
                        D = evalin('base',A{1});
                    end
                otherwise
                    errid = 'batalef:fileCallsGui:relocate:wrongInputType';
                    errstr = sprintf('Input type cannot be %s. Must be "file" or "var"',intype);
                    throwAsCaller(MException(errid,errstr));
            end
            relocateFileCalls(me.Application,me.ProcessVector,D);
            me.refreshTableData();
            me.plotPath();
        end
        
    end
    
end

