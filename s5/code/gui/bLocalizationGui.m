classdef bLocalizationGui < bGuiDefinition & hgsetget
    %BLOCALIZATIONGUI File call matching & localization gui
    
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
        
        CallsTable
        AxesLocalization
        
        InteractiveUis
    end
    
    properties (Constant,Hidden)
        AxesLocalizationMinHeight = 60;
        TableLineHeight = 1.4;
        MinHeight = 10*bLocalizationGui.TableLineHeight+2.5+bLocalizationGui.AxesLocalizationMinHeight+4.3
        MinWidth  = 120;
    end
    
    
    methods

        % CONSTRUCTOR
        function me = bLocalizationGui(guiTop,name)
            me = me@bGuiDefinition(guiTop,name);
            me.Build = true;
            
            % figure
            scrSize = uiPosition(0,'character');
            fpos = [(scrSize(3)-me.MinWidth)/2,(scrSize(4)-me.MinHeight)/2,me.MinWidth,me.MinHeight];
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
            me.buildAxes();

            
            % finish build
            me.Build = false;
            set(me.Figure,'Visible','on');
            me.setDisplayedFiles(me.DisplayVector)
        end
        
        % CALL IDX SELECTOR
        function buildCallIdxPanel(me)
            pos = uiPosition(me.SelectionRibbon.Panel,'characters');
            ppos = [pos(3)-40,0,40,pos(4)];
            me.CallIdxPanel = uipanel(me.SelectionRibbon.Panel,'Units','character','Position',ppos,'BorderType','none');
            
            uicontrol(me.CallIdxPanel,...
                'Style','text',...
                'Units','character',...
                'Position',[2,2.5,16,1.2],...
                'String','Call Idx:',...
                'HorizontalAlignment','left',...
                'VerticalAlignment','center');
            me.TextCallIdx = uicontrol(me.CallIdxPanel,...
                'Style','edit',...
                'Units','character',...
                'Position',[18,2.4,12,1.4],...
                'String','');            
            
            me.ButtonSelectAll = uicontrol(me.Panel,...
                'Style','pushbutton',...
                'Units','character',...
                'Position',[2,0.5,16,1.4],...
                'HorizontalAlignment','center',...
                'String','Select All',...
                'Callback',@(~,~)set(me.TextCallIdx,'String',int2str_compact(me.Application.file(me.DisplayVector(1)).CallsCount)));
            
            me.ButtonX = uicontrol(me.Panel,...
                'Style','pushbutton',...
                 'Units','character',...
                'Position',[12,0.5,12,1.4],...
                'String','X',...
                'HorizontalAlignment','center',...
                'Callback',@(hObject,~)me.deleteCalls());
            
            me.InteractiveUis = {me.TextCallIdx,me.ButtonSelectAll,me.ButtonX};

        end
        
        % BUTTONS PANEL
        function buildButtonsPanel(me)
            fpos = uiPosition(me.Figure,'character');
            ppos = [0,fpos(4)-4.3-2,fpos(3),2];
            
            me.ButtonsPanel = uipanel(me.Figure,...
                'Units','character',...
                'Position',ppos,...
                'BorderType','none');
            
            bp = me.ButtonsPanel;
            
            uicontrol(bp,...
                'Style','text',...
                'Units','character',...
                'Position',[2,2.4,16,1.2],...
                'String','Base Channel');
            me.ComboBaseChannel = uicontrol(bp,...
                'Style','popupmenu',...
                'Units','character',...
                'Position',[20,2.3,10,1.4],...
                'String','',...
                'Callback',@(~,~)me.refreshBaseCallsList());
            
            uicontrol(bp,...
                'Style','text',...
                'Units','character',...
                'Position',[35,2.4,16,1.2],...
                'String','Base Call');
            me.ComboBaseCall = uicontrol(bp,...
                'Style','popupmenu',...
                'Units','character',...
                'Position',[53,2.3,10,1.4],...
                'String','');
            
            uicontrol(bp,...
                'Style','text',...
                'Units','character',...
                'Position',[68,2.4,16,1.2],...
                'String','Allowed Error');
            me.TextAllowedError = uicontrol(bp,...
                'Style','edit',...
                'Units','character',...
                'Position',[86,2.3,10,1.4],...
                'String','');
            
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
                'Position',[20,0.3,10,1.4],...
                'String','');

            me.ButtonAccept = uicontrol(bp,...
                'Style','pushbutton',...
                'Units','character',...
                'Position',[35,2.3,12,1.4],...
                'String','Accept',...
                'Callback',@(~,~)me.accept());
            me.ButtonAcceptAll = uicontrol(bp,...
                'Style','pushbutton',...
                'Units','character',...
                'Position',[51,2.3,12,1.4],...
                'String','Accept All',...
                'Callback',@(~,~)me.acceptAll());            
            
            
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
            tpos = [2,me.AxesLocalizationMinHeight,me.MinWidth-4,10*me.TableLineHeight];
            me.CallsTable = uitable(me.Figure,...
                'Units','character',...
                'Position',tpos);
            me.InteractiveUis = [me.InteractiveUis,{me.CallsTable}];
        end
        
        % LOCALIZATION AXES
        function buildLocalizationAxes(me)
            apos = [5,3,me.MinWidth-10,me.AxesLocalizationMinHeight-6];
            me.AxesLocalization = axes('Parent',me.Figure,...
                'Units','character',...
                'Position',apos);
        end
        
        % SET CALLS TABLE COLUMNS
        function setTableColumns(me)
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
            
            % resize call idx panel
            rpos = uiPosition(me.SelectionRibbon.Panel,'character');
            rpos(2) = fpos(4) - rpos(4);
            rpos(3) = fpos(3);
            set(me.SelectionRibbon.Panel,'Units','character','Position',rpos);
            pos = uiPosition(me.CallIdxPanel,'character');
            pos(1) = fpos(3) - pos(3);
            set(me.CallIdxPanel,'Units','character','Position',pos); 
            
            % keep buttons panel on top of the table and centerlize
            bpos = uiPosition(me.ButtonsPanel,'character');
            pos = [(fpos(3)-bpos(3))/2,fpos(4)-rpos(4)-bpos(4),bpos(3),bpos(4)];
            set(me.ButtonsPanel,'Units','character','Position',pos);
            
            % in what left, keep 
            
        end
        
        
        %%%%%%%%%%%%%%%%%%%
        %%%             %%%
        %%%   DISPLAY   %%%
        %%%             %%%
        %%%%%%%%%%%%%%%%%%%
        
        % REFRESH
        function refresh(me)
        end
        
        % REFRESH BASE CALLS LIST
        function refreshBaseCallsList(me)
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
        end
        
        % ACCEPT
        function accept(me)
        end
        
        % ACCEPT ALL
        function acceptAll(me)
        end
            
        
    end
    
end

