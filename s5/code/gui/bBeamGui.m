classdef bBeamGui < bGuiDefinition & hgsetget
    %BBEAMGUI handling the beam gui
    
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
        File
        FileIdx
        BeamMethods
    end
    
    properties (Hidden) % BUILD
        CallIdxPanel
          ComboCallIdx
          ButtonPrev
          ButtonNext
        
        PowersTable
        
        ButtonsPanel
          TextZero
          TextAz
          TextEl
          TextRes
          ButtonRaw
          ButtonBeam
          ButtonAll
        
        AxesPanel
          AxesRaw
          AxesBeam
        
        BeamMethodsMenu 
          
        InteractiveUis
    end
    
    properties (Dependent)
        CallIdx
    end

    properties (Hidden,Constant)
        % all sizes are in chars
        TableLines = 14;
        TableLineHeight = 1.4;
        AxesHeight = 30;
        MinHeight = 4.3 + 1.2 + bBeamGui.TableLines*bBeamGui.TableLineHeight+2+bBeamGui.AxesHeight;
        MinWidth = 180;
    end
    
    methods
        
        % CONSTRUCTOR
        function me = bBeamGui(guiTop,name)
            me = me@bGuiDefinition(guiTop,name);
            me.Build = true;
            me.BeamMethods = me.Application.Methods.fileCallBeam;
            
            % figure
            fpos = [0,0,me.MinWidth,me.MinHeight];
            me.Figure = figure(...
                'WindowStyle','normal',...
                'Units','character',...
                'Position',fpos,...
                'Visible','off',...
                'ToolBar','none',...
                'MenuBar','none',...
                'Name','BATALEF - Beam Analysis',...
                'NumberTitle','off',...
                'CloseRequestFcn',@(~,~)me.Top.removeGui(me.Name));
            if verLessThan('matlab', bGuiDefinition.ResizeVersion)
                set(me.Figure,'ResizeFcn',@(~,~)me.resize());
            else
                set(me.Figure,'SizeChangedFcn',@(~,~)me.resize()); 
            end

            % build
            me.SelectionRibbon = bSelectionRibbon(me,false,true);
            me.buildCallSelector();
            me.buildTable();
            me.buildButtonsPanel();
            me.buildAxes();
            me.restoreParams();
            
            % end of build
            me.Build = false;
            set(me.Figure,'Visible','on');
            me.setDisplayedFiles(me.DisplayVector);
            
        end
        
        % DESTRUCTOR
        function delete(me)
%             me.Application.Methods.callAnalysisFilter.removeMenu(me.MenuFilter);
            delete(me.Figure);
        end        
        
        % BUILD CALLS SELECTOR
        function buildCallSelector(me)
            pos = uiPosition(me.SelectionRibbon.Panel,'characters');
            ppos = [pos(3)-34,0,34,pos(4)];
            me.CallIdxPanel = uipanel(me.SelectionRibbon.Panel,'Units','character','Position',ppos,'BorderType','none');
            p = me.CallIdxPanel;
            uicontrol(p,'Style','text','String','Call:','Units','character','Position',[2,2.4,8,1.2],'HorizontalAlignment','left');
            me.ComboCallIdx = uicontrol(p,'Style','popupmenu','Units','character','Position',[10,2.3,8,1.4],'Callback',@(h,~)me.changeCall(get(h,'Value')),'String','N/A','Value',1);
            me.ButtonPrev = uicontrol(p,'Style','pushbutton','Units','character','Position',[20,2.3,5,1.4],'String','<','Callback',@(~,~)me.changeCall(me.CallIdx - 1),'TooltipString','Previous Call');
            me.ButtonNext = uicontrol(p,'Style','pushbutton','Units','character','Position',[27,2.3,5,1.4],'String','>','Callback',@(~,~)me.changeCall(me.CallIdx + 1),'TooltipString','Next Call');
            
            me.InteractiveUis = {me.ButtonPrev,me.ButtonNext};
        end
        
        % BUILD POWERS TABLE
        function buildTable(me)
            spos = [2,me.MinHeight-4.3-1.2,me.MinWidth-4,1.2];
            str = 'All values in tha table are 10dB unless stated otherwise. The amplifications fields are (M)ic-amplif, (A)ir-absorb and (D)irect-amplif:'
            uicontrol(me.Figure,'Style','text','Units','character','Position',spos,'HorizontalAlignment','left','String',str);
            tpos = [2,me.AxesHeight+2,me.MinWidth-4,me.TableLines*me.TableLineHeight];
            me.PowersTable = uitable(me.Figure,'Units','character','Position',tpos);
            
            % set columns - widths are in pixels
            i = 0;

            % use in beam computation
            i=i+1;
            colNames{i}    = 'Use';
            colWidths{i}   = 50;
            colFormats{i}  = 'logical';
            colEditable(i) = true;
            
            % channel call
            i=i+1;
            colNames{i}    = 'Channel Call';
            colWidths{i}   = 120;
            colFormats{i}  = 'numeric';
            colEditable(i) = false;
            
            % measured power
            i=i+1;
            colNames{i}    = 'Measured Power';
            colWidths{i}   = 120;
            colFormats{i}  = 'numeric';
            colEditable(i) = false;
            
            % mic amplif
            i=i+1;
            colNames{i}    = 'Mic Amplif.';
            colWidths{i}   = 120;
            colFormats{i}  = 'numeric';
            colEditable(i) = false;            
            
            % distance
            i=i+1;
            colNames{i}    = 'Bat-Mic Dist. (m)';
            colWidths{i}   = 120;
            colFormats{i}  = 'numeric';
            colEditable(i) = false;            

            % freq
            i=i+1;
            colNames{i}    = 'Fund. Freq. (KHz)';
            colWidths{i}   = 120;
            colFormats{i}  = 'numeric';
            colEditable(i) = false;            

            % air absorption amplif
            i=i+1;
            colNames{i}    = 'Air Absorp.';
            colWidths{i}   = 120;
            colFormats{i}  = 'numeric';
            colEditable(i) = false;            

            % Directionality Angle
            i=i+1;
            colNames{i}    = 'Direct. Angle (deg)';
            colWidths{i}   = 150;
            colFormats{i}  = 'numeric';
            colEditable(i) = false;            

            % direct amplif
            i=i+1;
            colNames{i}    = 'Direct. Amplif.';
            colWidths{i}   = 120;
            colFormats{i}  = 'numeric';
            colEditable(i) = false;            

            % mic + air
            i=i+1;
            colNames{i}    = 'M+A';
            colWidths{i}   = 70;
            colFormats{i}  = 'numeric';
            colEditable(i) = false;            

            % mic + direct
            i=i+1;
            colNames{i}    = 'M+D';
            colWidths{i}   = 70;
            colFormats{i}  = 'numeric';
            colEditable(i) = false;            

            % air + direct
            i=i+1;
            colNames{i}    = 'A+D';
            colWidths{i}   = 70;
            colFormats{i}  = 'numeric';
            colEditable(i) = false;            

            % all
            i=i+1;
            colNames{i}    = 'M+A+D';
            colWidths{i}   = 70;
            colFormats{i}  = 'numeric';
            colEditable(i) = false;            

            % power at mic
            i=i+1;
            colNames{i}    = 'Computed Power at bat';
            colWidths{i}   = 170;
            colFormats{i}  = 'numeric';
            colEditable(i) = false;            

            % power to use
            i=i+1;
            colNames{i}    = 'Power To Use';
            colWidths{i}   = 120;
            colFormats{i}  = 'numeric';
            colEditable(i) = true;            

            set(me.PowersTable,...
                    'columnname',colNames,...
                    'columnformat',colFormats,...
                    'ColumnWidth',colWidths,...
                    'ColumnEditable',colEditable);            
        end
        
        % BUTTONS PANEL
        function buildButtonsPanel(me)
            ppos = [0,me.AxesHeight,me.MinWidth,2];
            p = uipanel(me.Figure,'Units','character','Position',ppos,'BorderType','none');
            me.ButtonsPanel = p;
            uicontrol(p,'Style','text','Units','character','Position',[2,0.4,13,1.2],'String','Zero Vector','HorizontalAlignment','left');
            me.TextZero = uicontrol(p,'Style','Edit','Units','character','Position',[15,0.3,10,1.4]);
            
            uicontrol(p,'Style','text','Units','character','Position',[27,0.4,15,1.2],'String','Az. Range (deg)','HorizontalAlignment','left');
            me.TextAz = uicontrol(p,'Style','Edit','Units','character','Position',[42,0.3,10,1.4]);
            
            uicontrol(p,'Style','text','Units','character','Position',[55,0.4,15,1.2],'String','El. Range (deg)','HorizontalAlignment','left');
            me.TextEl = uicontrol(p,'Style','Edit','Units','character','Position',[70,0.3,10,1.4]);
            
            uicontrol(p,'Style','text','Units','character','Position',[83,0.4,17,1.2],'String','Resolution (deg)','HorizontalAlignment','left');
            me.TextRes = uicontrol(p,'Style','Edit','Units','character','Position',[100,0.3,8,1.4]);            
            
            me.ButtonRaw  = uicontrol(p,'Style','pushbutton','Units','character','Position',[111,0.3,20,1.4],'String','Redraw Raw','Callback',@(h,~)me.plotRaw());
            me.ButtonBeam = uicontrol(p,'Style','pushbutton','Units','character','Position',[133,0.3,20,1.4],'String','Compute Beam','Callback',@(h,~)me.compBeam(false));
            me.ButtonAll  = uicontrol(p,'Style','pushbutton','Units','character','Position',[155,0.3,23,1.4],'String','Beam For All Calls','Callback',@(h,~)me.compBeam(true));
            
            me.InteractiveUis = [me.InteractiveUis,{me.TextZero,me.TextAz,me.TextEl,me.TextRes,me.ButtonRaw,me.ButtonBeam,me.ButtonAll}];
        end
        
        % AXES PANEL
        function buildAxes(me)
            apos = [4,3,me.MinWidth/2-8,me.AxesHeight-5];
            bpos = apos + [me.MinWidth/2+4,0,0,0];
            me.AxesRaw  = axes('Parent',me.Figure,'Units','character','Position',apos);
            me.AxesBeam = axes('Parent',me.Figure,'Units','character','Position',bpos);
        end
        
        % MENUS
        function buildMenus(me)
            m1 = uimenu(me.Figure,'Label','Beam Computation');
            me.BeamMethodsMenu = uimenu(m1,'Label','Methods');
            me.BeamMethods.createMenu(me.BeamMethodsMenu,me);
        end            
        
        % RESIZE
        function resize(me)
        end
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%                    %%%
        %%%   PULLS & LEVERS   %%%
        %%%                    %%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        
        % COLLECT DATA FOR BEAM & RAW
        function [batx,mics,powers,zero,azRange,elRange,res] = collectData(me)
            batx = me.File.call(me.CallIdx).location;
            C = get(me.PowersTable,'Data');
            U = cell2mat(C(:,1));
            D = cell2mat(C(:,2:size(C,2)));
            M = me.File.MicData.Positions;
            mics = M(U,:);
            powers = D(U,size(D,2));
            zero = str2num(get(me.TextZero,'String'));%#ok<ST2NM>
            azRange = str2num(get(me.TextAz,'String'));%#ok<ST2NM>
            elRange = str2num(get(me.TextEl,'String'));%#ok<ST2NM>
            res = str2num(get(me.TextRes,'String'));%#ok<ST2NM>
        end

        % KEEP PARAMETERS IN THE PARAMETERS OBJECT
        function keepParams(me)
            asetParam('beam_zero_vector',str2num(get(me.TextZero,'String')));%#ok<ST2NM>
            asetParam('beam_azRange'    ,str2num(get(me.TextAz,'String')));%#ok<ST2NM>
            asetParam('beam_elRange'    ,str2num(get(me.TextEl,'String')));%#ok<ST2NM>
            asetParam('beam_resolution' ,str2num(get(me.TextRes,'String')));%#ok<ST2NM>
        end
        
        % RESTORE VALUES FROM PARAMETERS OBJECT
        function restoreParams(me)
            set(me.TextZero,'String',agetParam('beam_zero_vector','AsString'));
            set(me.TextAz  ,'String',agetParam('beam_azRange','AsString'));
            set(me.TextEl  ,'String',agetParam('beam_elRange','AsString'));
            set(me.TextRes ,'String',agetParam('beam_resolution','AsString'));            
        end
        
        % COMPUTE BEAM
        function compBeam(me,allCalls)
            if allCalls
                C = [];
            else
                C = me.CallIdx;
            end
            F = me.ProcessVector;
            [batx,mics,powers,zero,azRange,elRange,res] = me.collectData();
            surfParams.azRange = azRange;
            surfParams.elRange = elRange;
            surfParams.res     = res;
            surfParams.zero    = zero;
            computeBeam(me.Application,F,C,surfParams);
            me.plotBeam();
        end
        
        %%%%%%%%%%%%%%%%%%%
        %%%             %%%
        %%%   DATASET   %%%
        %%%             %%%
        %%%%%%%%%%%%%%%%%%%
        
        % SET FILES TO DISPLAY
        function setDisplayedFiles(me,V)
            if isempty(V)
                cellfun(@(h)set(h,'Enable','off'),me.InteractiveUis);
                D = [];
                set(me.PowersTable,'Data',D);
                set(me.ComboCallIdx,'Value',1);
                set(me.ComboCallIdx,'String','N/A');
                if ~isempty(me.AxesRaw) && ishandle(me.AxesRaw)
                    cla(me.AxesRaw);
                end
                if ~isempty(me.AxesBeam) && ishandle(me.AxesBeam)
                    cla(me.AxesBeam);
                end
                
            else
                cellfun(@(h)set(h,'Enable','on'),me.InteractiveUis);
                me.FileIdx = V(1);
                me.File = me.Application.file(me.FileIdx);
                set(me.ComboCallIdx,'Value',1);
                set(me.ComboCallIdx,'String',arrayfun(@(i)num2str(i),1:me.File.CallsCount,'UniformOutput',false));
                me.refreshTable();
                me.plotRaw();
                me.plotBeam();
            end            
        end
        
        % CHANGE FILE CALL
        function changeCall(me,callIdx)
            if isempty(me.File)
                % do nothing
            elseif callIdx < 1
                % do nothing
            elseif callIdx > me.File.CallsCount
                msgbox('Last call reached','modal');
                % do nothing
            else
                set(me.ComboCallIdx,'Value',callIdx);
                me.refreshTable();
                me.plotRaw();
                me.plotBeam();
            end
        end
        
        % GET CALL IDX
        function val = get.CallIdx(me)
            if isempty(me.File) || me.FileIdx == 0
                val = 0;
            else
                val = get(me.ComboCallIdx,'Value');
            end
        end
        
        % FILL TABLE
        function refreshTable(me)
            if isempty(me.File)
                D = [];
            else
                T = me.File.getCallPowers(me.CallIdx);
                U = me.File.MicData.UseInBeam;
                U(T{:,1}==0) = false;
                D = [num2cell(U),num2cell(T{:,:})];
%                 D = round(D,2);
            end
            set(me.PowersTable,'Data',D);
        end
            
        %%%%%%%%%%%%%%%%%%%
        %%%             %%%
        %%%   DISPLAY   %%%
        %%%             %%%
        %%%%%%%%%%%%%%%%%%%
        
        % PLOT RAW
        function plotRaw(me)
            cla(me.AxesRaw);
            if ~isempty(me.File)
                [batx,mics,powers,zero,azRange,elRange,res] = me.collectData();
                % get mics relative coordinates - the bat is "looking" at
                % the zero vector
                nmics = size(mics,1);
                rzero = zero - batx;
                rmics = mics - ones(nmics,1)*batx;
                zsph = mcart2sph(rzero,'degree');
                msph = mcart2sph(rmics,'degree');
                rmsph = msph - ones(nmics,1)*zsph;
                
                % create image
                M = NaN(diff(elRange)/res,diff(azRange)/res);
                for i = 1:nmics
                    a = round((rmsph(i,1)-azRange(1))/res);
                    if a < 0 || a > size(M,2)
                        a = NaN;
                    elseif a == 0
                        a = 1;
                    end
                    b = round((rmsph(i,2)-elRange(1))/res);
                    if b < 0 || b > size(M,2)
                        b = NaN;
                    elseif b == 0
                        b = 1;
                    end                    
                    if ~isnan(a) && ~isnan(b)
                        M(b,a) = powers(i);
                    end
                end
                
                % display image
                axes(me.AxesRaw);
                imagesc(M);
            end
        end
        
        % PLOT BEAM
        function plotBeam(me)
            cla(me.AxesBeam);
            if ~isempty(me.File)
                cdata = me.File.call(me.CallIdx);
                if ~isempty(cdata.beam)
                    if ~isempty(cdata.beam.surface.image)
                        axes(me.AxesBeam);
                        imagesc(cdata.beam.surface.image);
                    else
                        % create surface from d,w,i
                    end
                end
            end
        end
        
    end
    
end

