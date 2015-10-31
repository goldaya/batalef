classdef bMicAdminGui < bGuiDefinition & hgsetget
    %BMICADMINGUI batalef Mic Admin GUI handler

    % properties coming from gui definition:
    %{
    properties
        Figure
        Name
    end
    
    properties (Hidden)
        Top
        SelectionRibbon
        Build = false;
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
        DesiredLocalizationArrayDepth
        CurrentLocalizationArrayDepth
    end
    
    properties (Hidden) % Build
        AdminPanel
          AdminTable
          TextArrayDepthDesired
          TextArrayDepthCurrent
          
        DirectionalityPanel
        
    end
    
    properties (Constant,Hidden)
        ABC = 1.2; % table line
        MinHeight = 13*bMicAdminGui.ABC+3.2+17+4.3 % (12 mics + 1 header) * line height + padding + directionality panel + ribbon, 
        MinWidth  = 150;
    end
    

    %%%%%%%%%%%%%%%%%%%%%%%%
    %%%                  %%%
    %%%  PUBLIC METHODS  %%%
    %%%                  %%%
    %%%%%%%%%%%%%%%%%%%%%%%%    
    methods
        % CONSTRUCTOR
        function me = bMicAdminGui(guiTop,name)
            me = me@bGuiDefinition(guiTop,name);
            me.Build = true;
            
            % figure
            scrSize = uiPosition(0,'character');
            me.Figure = figure(...
                'WindowStyle','normal',...
                'Units','character',...
                'Position',[(scrSize(3)-me.MinWidth)/2,(scrSize(4)-me.MinHeight)/2,me.MinWidth,me.MinHeight],...
                'Visible','off',...
                'ToolBar','none',...
                'MenuBar','none',...
                'Name','BATALEF - Mic Admin',...
                'NumberTitle','off',...
                'CloseRequestFcn',@(~,~)me.Top.removeGui(me.Name));
            if verLessThan('matlab', bGuiDefinition.ResizeVersion)
                set(me.Figure,'ResizeFcn',@(~,~)me.resize());
            else
                set(me.Figure,'SizeChangedFcn',@(~,~)me.resize()); 
            end
            
            me.SelectionRibbon = bSelectionRibbon(me,false,true);
            me.buildAdminPanel();
            me.buildDirectionalityPanel();
            me.buildMenus();
            
            % finish build
            me.Build = false;
            set(me.Figure,'Visible','on');
            
        end
        
        % GET LOCALIZATION ARRAY DEPTHS
        function V = getLocalizationArrayDepth(me)
            
        end
        
       
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%
    %%%                   %%%
    %%%  PRIVATE METHODS  %%%
    %%%                   %%%
    %%%%%%%%%%%%%%%%%%%%%%%%%
    methods(Access = private)
        
        %%%%%%%%%%%
        %  BUILD  %
        %%%%%%%%%%%
        
        % ADMIN PANEL
        function buildAdminPanel(me)
            me.AdminPanel = uipanel(me.Figure,...
                'Units','character',...
                'Position',[0,17+1,150,13*me.ABC+2.2],...
                'BorderType','none');
            
            uitabColNames = {'Matching','Local.','Beam','X','Y','Z','Gain'};
            uitabColWidths = {100,100,100,100,100,100,100};
            uitabColFormats = {'logical','logical','logical','numeric','numeric','numeric','numeric'};                
            me.AdminTable = uitable(me.AdminPanel,...
                    'Units','character',...
                    'columnname',uitabColNames,...
                    'columnformat',uitabColFormats,...
                    'ColumnWidth',uitabColWidths,...
                    'Position',[2,2,146,13*me.ABC]);
            
            uicontrol(me.AdminPanel,'Style','text','Units','character','Position',[2,0.5,40,1],'String','Desired Localization Array Depth','HorizontalAlignment','Left');
            me.TextArrayDepthDesired = uicontrol(me.AdminPanel,'Style','edit','Units','character','Position',[44,0.3,15,1.4],'HorizontalAlignment','center','Callback',@(h,~)me.setDesLocArrDep(str2num(get(h,'String'))),'String','1 1 1');%#ok<ST2NM>
            
            uicontrol(me.AdminPanel,'Style','text','Units','character','Position',[69,0.5,40,1],'String','Current Localization Array Depth','HorizontalAlignment','Left');
            me.TextArrayDepthCurrent = uicontrol(me.AdminPanel,'Style','edit','Units','character','Position',[111,0.3,15,1.4],'HorizontalAlignment','center','Enable','inactive');
            
            uicontrol(me.AdminPanel,'Style','pushbutton','Units','character','Position',[136,0.3,10,1.4],'String','Check','Callback',@(~,~)me.checkLocalizationArrayDepth());
            
        end
        
        % LOCALIZATION PANEL
        function buildDirectionalityPanel(me)
        end
        
        % MENUS
        function buildMenus(me)
        end
        
        % RESIZE
        function resize(me)
        end
        
        %%%
        
        % CHECK LOCALIZATION ARRAY DEPTH
        function checkLocalizationArrayDepth(me)
            me.getLocalizationArrayDepth();
            set(me.TextArrayDepthCurrent,'String',num2str(me.CurrentLocalizationArrayDepth));
            if max(me.CurrentLocalizationArrayDepth < me.DesiredLocalizationArrayDepth) > 0
                set(me.TextArrayDepthCurrent,'ForegroundColor',[1,0,0]);
            else
                set(me.TextArrayDepthCurrent,'ForegroundColor',[0,0,0]);
            end
        end
    end
end

