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
        DesiredLocalizationArrayDepth = agetParam('micAdmin_locArrayDepth')
        CurrentLocalizationArrayDepth
    end
    
    properties (Hidden)
        MicsObject
    end
    
    properties (Hidden) % Build
        AdminPanel
          AdminTable
          TextArrayDepthDesired
          TextArrayDepthCurrent
          
        DirectPanel
          DirectTable
          CbManageDirect
          TextDirectZeroVector
          AxesDirect
          DirectUis
        
        Menus
        InteractiveUis = {};
        
    end
    
    properties (Constant,Hidden)
        TableLineHeight = 1.4;
        DirectPanelHeight = 22;
        MinHeight = 13*bMicAdminGui.TableLineHeight+3.2+bMicAdminGui.DirectPanelHeight+4.3 % (12 mics + 1 header) * line height + padding + directionality panel + ribbon, 
        MinWidth  = 150;
    end
    

    methods

        % CONSTRUCTOR
        function me = bMicAdminGui(guiTop,name)
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
            set(me.Figure,'Position',fpos);
            me.setDisplayedFiles(me.DisplayVector)
            
        end
        
        % DESTRUCTOR
        function delete(me)
            delete(me.Figure);
        end
        
        %%%%%%%%%%%
        %  BUILD  %
        %%%%%%%%%%%
        
        % ADMIN PANEL
        function buildAdminPanel(me)
            me.AdminPanel = uipanel(me.Figure,...
                'Units','character',...
                'Position',[0,me.DirectPanelHeight+0.2,150,13*me.TableLineHeight+2.2],...
                'BorderType','none');
            
            uitabColNames = {'Matching','Local.','Beam','X','Y','Z','Gain'};
            uitabColWidths = {100,100,100,100,100,100,100};
            uitabColFormats = {'logical','logical','logical','numeric','numeric','numeric','numeric'};                
            me.AdminTable = uitable(me.AdminPanel,...
                    'Units','character',...
                    'columnname',uitabColNames,...
                    'columnformat',uitabColFormats,...
                    'ColumnWidth',uitabColWidths,...
                    'ColumnEditable',true(1,7),...
                    'Position',[2,2,146,13*me.TableLineHeight]);
            
            uicontrol(me.AdminPanel,'Style','text','Units','character','Position',[2,0.5,39,1],'String','Desired Localization Array Depth','HorizontalAlignment','Left');
            me.TextArrayDepthDesired = uicontrol(me.AdminPanel,'Style','edit','Units','character','Position',[41,0.3,25,1.4],'HorizontalAlignment','center','Callback',@(h,~)me.setDesLocArrDep(str2num(get(h,'String'))),'String',agetParam('micAdmin_locArrayDepth','AsString'));%#ok<ST2NM>
            
            uicontrol(me.AdminPanel,'Style','text','Units','character','Position',[69,0.5,39,1],'String','Current Localization Array Depth','HorizontalAlignment','Left');
            me.TextArrayDepthCurrent = uicontrol(me.AdminPanel,'Style','edit','Units','character','Position',[110,0.3,25,1.4],'HorizontalAlignment','center','Enable','inactive');
            
            pb = uicontrol(me.AdminPanel,'Style','pushbutton','Units','character','Position',[136,0.3,12,1.4],'String','Check','Callback',@(~,~)me.checkLocalizationArrayDepth());
            
            me.InteractiveUis = [me.InteractiveUis,{me.AdminTable,me.TextArrayDepthDesired,pb}];
        end
        
        % DIRECTIONALITY PANEL
        function buildDirectionalityPanel(me)
            me.DirectPanel = uipanel(me.Figure,...
                'Units','character',...
                'Position',[0,0.2,150,me.DirectPanelHeight],...
                'BorderType','none');
            
            me.CbManageDirect = uicontrol(me.DirectPanel,...
                'Style','checkbox',...
                'Units','character',...
                'Position',[2,me.DirectPanelHeight-2+0.4,70,1.2],...
                'String','Manage Directionality',...
                'Callback',@(h,~)me.directManageChange(get(h,'Value')),...
                'Value',false);
            
            uicontrol(me.DirectPanel,...
                'Style','text',...
                'Units','character',...
                'Position',[69,me.DirectPanelHeight-2+0.4,39,1.2],...
                'String','Zero Vector (x y z)',...
                'HorizontalAlignment','Left');
            me.TextDirectZeroVector = uicontrol(me.DirectPanel,...
                'Style','edit',...
                'Units','character',...
                'Position',[110,me.DirectPanelHeight-2+0.3,25,1.4]);
            
            uitabColNames = {'Freq (KHz)','Direction (deg)','Gain (dB)'};
            uitabColWidths = {100,100,100};
            uitabColFormats = {'numeric','numeric','numeric'};                
            me.DirectTable = uitable(me.DirectPanel,...
                    'Units','character',...
                    'Position',[2,0,70,me.DirectPanelHeight-2],...
                    'columnname',uitabColNames,...
                    'columnformat',uitabColFormats,...
                    'ColumnWidth',uitabColWidths,...
                    'ColumnEditable',true(1,3),...
                    'CellEditCallback',@(~,~)me.directTableCellEdit(),...
                    'Data',zeros(1,3));   
            me.AxesDirect = axes('Parent',me.DirectPanel,...
                'Units','character',...
                'Position',[78,0,70,20]);
            
            me.DirectUis = {me.TextDirectZeroVector,me.DirectTable};
            me.InteractiveUis = [me.InteractiveUis,{me.TextDirectZeroVector,me.DirectTable,me.CbManageDirect}];

        end
        
        % MENUS
        function buildMenus(me)
            m0 = uimenu(me.Figure,'Label','Mic Data');
            uimenu(m0,'Label','Save','Callback',@(~,~)me.save(false));
            uimenu(m0,'Label','Import','Callback',@(~,~)me.import(),'Separator','on');
            uimenu(m0,'Label','Export','Callback',@(~,~)me.export());
            m1 = uimenu(me.Figure,'Label','Positions');
            uimenu(m1,'Label','Load from file','Callback',@(~,~)me.loadFromFile('positions'));
            uimenu(m1,'Label','Load from var ','Callback',@(~,~)me.loadFromVar('positions'));
            uimenu(m1,'Label','Mic Locator','Callback',@(~,~)me.Top.callGui('MicLocator'),'Separator','on');
            m2 = uimenu(me.Figure,'Label','Gains');
            uimenu(m2,'Label','Load from file','Callback',@(~,~)me.loadFromFile('gains'));
            uimenu(m2,'Label','Load from var ','Callback',@(~,~)me.loadFromVar('gains'));            
            m3 = uimenu(me.Figure,'Label','Directionality');
            uimenu(m3,'Label','Load from file','Callback',@(~,~)me.loadFromFile('direct'));
            uimenu(m3,'Label','Load from var ','Callback',@(~,~)me.loadFromVar('direct'));            
            
            me.Menus = {m0,m1,m2,m3};
            me.InteractiveUis = [me.InteractiveUis,me.Menus];
        end
        
        % RESIZE
        function resize(me) %#ok<MANU> % (me). no resize for this gui currently
        end        
        
        %%%%%%%%%%%
        % DISPLAY %
        %%%%%%%%%%%
                
        % SET THE DISPLAYED FILES
        function setDisplayedFiles(me,filesVector)
            if isempty(filesVector)
                me.MicsObject = [];
                cellfun(@(m)set(m,'Enable','off'),me.InteractiveUis);
            else
                me.MicsObject = me.Application.file(filesVector).MicData;
                cellfun(@(m)set(m,'Enable','on'),me.InteractiveUis);
            end
            me.refresh();
        end
        
        % REFRESH
        function refresh(me)
            if isempty(me.MicsObject)
                A = [];
                dT = [0,0,0];
                dM = false;
                dZ = [0,0,0];
            else
                A = [...
                    num2cell(me.MicsObject.UseInMatching),...
                    num2cell(me.MicsObject.UseInLocalization),...
                    num2cell(me.MicsObject.UseInBeam),...
                    num2cell(me.MicsObject.Positions),...
                    num2cell(me.MicsObject.GainVector)];
                dT = me.MicsObject.Directionality.Matrix;
                dM = me.MicsObject.Directionality.Manage;
                dZ = me.MicsObject.Directionality.Zero;
                
            end
            set(me.AdminTable,'Data',A);
            me.changeDirect(dT);
            me.directManageChange(dM);
            set(me.TextDirectZeroVector,'String',num2str(dZ));
        end  
        
        % PLOT DIRECTIVITY GRAPH
        function directPlot(me,Dmat)

            axobj = me.AxesDirect;
            cla(axobj)    
            if isempty(Dmat)
                return;
            end

            % create different graph for each frequency
            C = cell(1,2);
            for i = 1:size(Dmat,1)
                % cellIdx is the freq index for specific 
                cellIdx = find(strcmp(num2str(Dmat(i,1)), C{1}));
                if isempty(cellIdx)
                    cellIdx = length(C{1}) + 1;
                    C{1}{cellIdx} = num2str(Dmat(i,1));
                    C{2}{cellIdx} = cell(1,2);
                    C{2}{cellIdx} = zeros(1,2);
                    n = 0;
                else
                    n = size(C{2}{cellIdx},1);
                end

                % the angle-gain vector for specific freq
                C{2}{cellIdx}(n+1,1)=Dmat(i,2); % angle
                C{2}{cellIdx}(n+1,2)=Dmat(i,3); % gain
            end

            col = graphColors();

            N = length(C{1});
            lString = cell(N,1);
            for i = 1:N
                color = col.getNext();
                A = sortrows(C{2}{i},1);
                x = deg2rad(A(:,1));
                y = A(:,2) + 70;
                polar(axobj,x,y,color);
                hold(axobj,'on');
                lString{i} = strcat([C{1}{i},' KHz']);
            end
            hold(axobj,'off');
            set(axobj,'View',[270,90]);
            legend(lString,'Location','NorthEast');

        end        
        
       
        %%%%%%%%%%%%%%%%%
        % DATA HANDLING %
        %%%%%%%%%%%%%%%%%
        
        % SAVE
        function save(me,withQuit)
            
            if withQuit
                title = 'Save & Close';
            else
                title = 'Save';
            end
            if ~me.checkLocalizationArrayDepth()
                q = 'Localization array is too flat. Continue ?';
                if ~strcmp(questdlg(q,title,'Yes','No','No'),'Yes')
                    return; % abort
                end
            end
            
            A = get(me.AdminTable,'Data');
            D = get(me.DirectTable,'Data');
            position = cell2mat(A(:,4:6));
            gain     = cell2mat(A(:,7));
            dManage  = get(me.CbManageDirect,'Value');
            if dManage
                dTable = D(any(D,2),:);
            else
                dTable = [];
            end
            dZero    = str2num(get(me.TextDirectZeroVector,'String'));%#ok<ST2NM>
            uMatch   = cell2mat(A(:,1));
            uLocal   = cell2mat(A(:,2));
            uBeam    = cell2mat(A(:,3));
            
            ok = setMicData(me.Application,me.ProcessVector,size(position,1),position,gain,uMatch,uLocal,uBeam,dManage,dTable,dZero);
            n = length(ok);
            m = length(ok(ok==true));
            if n ==m
                msgbox(sprintf('Saved %i out of %i.',m,n));
            else
                msgbox(sprintf('Saved %i out of %i. Check channel counts or directionality data.',m,n));
            end
            
            if withQuit
                me.Top.removeGui(me.Name);
            end
                           
        end
        
        % IMPORT
        function import(me)
            [fname,fpath] = uigetfile();
            if isnumeric(fname)
                return; % abort
            end            
            X = importdata(strcat(fpath,fname));
            me.MicsObject = bMics.buildObject(X);
            me.refresh();
            msgbox('Imported');
        end
        
        % EXPORT
        function export(me)
            [fname,fpath] = uiputfile();
            if isnumeric(fname)
                return; % abort
            end
            X = me.MicsObject.toStruct(); %#ok<NASGU>
            save(strcat(fpath,fname),'X');
            msgbox('Exported');
        end
        
        % CHANGE POSITIONS
        function changePositions(me,P)
            if size(P,2) ~= 3
                msgbox('Input is not a 3D matrix');
                return;
            elseif size(P,1) ~= me.MicsObject.N
                msgbox(sprintf('Input does not have %i rows',me.MicsObject.N));
                return;
            else
                C = num2cell(P);
            end
           
            D = get(me.AdminTable,'Data');
            D(:,4:6) = C;
            set(me.AdminTable,'Data',D);
        
        end
        
        % CHANGE POSITIONS
        function changeGains(me,G)
            if size(G,2) ~= 1
                msgbox('Input is not a 1D vector');
                return;
            elseif size(G,1) ~= me.MicsObject.N
                msgbox(sprintf('Input does not have %i rows',me.MicsObject.N));
                return;
            else
                C = num2cell(G);
            end
           
            D = get(me.AdminTable,'Data');
            D(:,7) = C;
            set(me.AdminTable,'Data',D);
        
        end        
        
        % CHANGE DIRECTIONALITY
        function changeDirect(me,D)
            if size(D,2) ~= 3
                msgbox('Input is not a 3D vector');
                return;
            else
                set(me.DirectTable,'Data',D);
                me.directTableCellEdit();
            end
        end        
        
        % DESIRED LOC ARRAY DEPTH
        function setDesLocArrDep(me,V)
            me.DesiredLocalizationArrayDepth = V;
            asetParam('micAdmin_locArrayDepth',V);
        end
    

        %%%%%%%%%%%%%%%%%%%
        % LOC ARRAY DEPTH %
        %%%%%%%%%%%%%%%%%%%
    
        % GET LOCALIZATION ARRAY DEPTHS
        function V = getLocalizationArrayDepth(me)
            A = get(me.AdminTable,'Data');
            P = cell2mat(A(:,4:6));
            U = cell2mat(A(:,1));
            P = P(U,:);
            V = max(P) - min(P);
            me.CurrentLocalizationArrayDepth = V;
        end
        
        % CHECK LOCALIZATION ARRAY DEPTH
        function ok = checkLocalizationArrayDepth(me)
            me.getLocalizationArrayDepth();
            set(me.TextArrayDepthCurrent,'String',num2str(me.CurrentLocalizationArrayDepth));
            if max(me.CurrentLocalizationArrayDepth < me.DesiredLocalizationArrayDepth) > 0
                set(me.TextArrayDepthCurrent,'ForegroundColor',[1,0,0]);
                ok = false;
            else
                set(me.TextArrayDepthCurrent,'ForegroundColor',[0,0,0]);
                ok = true;
            end
        end
        

        %%%%%%%%%%%%%%%%%%
        % PULLS & LEVERS %
        %%%%%%%%%%%%%%%%%%
        
        % LOAD FROM FILE
        function loadFromFile(me,type)
            [fname,fpath] = uigetfile();
            if isnumeric(fname) && fname == 0
                return; % abort
            else
                M = importdata(strcat(fpath,fname));
                switch type
                    case 'positions'
                        me.changePositions(M);
                    case 'gains'
                        me.changeGains(M);
                    case 'direct'
                        me.changeDirect(M);
                    otherwise
                end
            end
        end
        
        % LOAD FROM VAR
        function loadFromVar(me,type)
            A = inputdlg('Variable Name');
            if isempty(A)
                return; % abort
            else
                
                try
                    M = evalin('base',A{1});
                    switch type
                        case 'positions'
                            me.changePositions(M);
                        case 'gains'
                            me.changeGains(M);
                        case 'direct'
                            me.changeDirect(M);
                        otherwise
                    end
                catch err
                    if strcmp(err.identifier, 'MATLAB:UndefinedFunction')
                        msgbox('No such variable in base workspace');
                        return;
                    else
                        throwAsCaller(err);
                    end
                end                
            end
        end
        
        % DIRECT TABLE CELL EDIT
        function directTableCellEdit(me)
            % remove empty rows
            D = get(me.DirectTable,'Data');
            D = D(any(D,2),:);

            % plot when matrix is consistent
            if min(min(abs(D(:,1)))) > 0
                me.directPlot(D);
            end

            % append empty row
            c = zeros(1,3);
            s = size(D,1);
            if s == 0
                D = c;
            else
                D(s+1,:) = c;   
            end
            set(me.DirectTable,'Data',D);        
        end
        
        % CHANGE DIRECTIONALITY CB
        function directManageChange(me,manage)
            if manage
                cellfun(@(h)set(h,'Enable','on'),me.DirectUis);
            else
                cellfun(@(h)set(h,'Enable','off'),me.DirectUis);
            end
            set(me.CbManageDirect,'Value',manage);
        end
        

    end
end

