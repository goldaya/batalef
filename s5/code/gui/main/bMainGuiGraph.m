classdef bMainGuiGraph < handle & hgsetget
%BMAINGUIGRAPH class for handling main gui grpah. an instance is child of a
%bMainGuiGraphGroup object

    
    properties (Access = public)
        FileIdx = 0;
        ChannelIdx = 0;
    end
    
    properties (Access = ?bMainGuiGraphGroup)
        BasePanel
        AxesTS
        AxesSpec
        Idx
        DisplayType
        DisplayWindow
        Ylim
    end
    
    properties (Access = private)

        Group
        Title

        ParentUI
        Slider = NaN;
        
        ValuesPanel
        TextPointTime
        TextPointValue
        TextPointFreq
        TextPointPower
        
        ButtonsPanel
        TextTitle
        DisplayTypeButtonGroup
        PushButtonTS
        PushButtonSpec
        PushButtonBoth
        TextTime
        TextDisplayWindow
        CheckboxMADL
        TextYlim
        ComboSpecRange
        
        AxesPanel
        AxesTSFigurePosition
        AxesSpecFigurePosition
        TSMark
        SpecMark
        SpecImage
        
    end
    
    properties (Dependent = true)
        DisplayStartTime
        Dataset
        Visible
        MADL
        GuiTop
        Application
        SpecRange
        Gui
    end
    
    properties (Constant = true)
        tsDisplayType   = 1;
        specDisplayType = 2;
        bothDisplayType = 3;
    end
    
    
    methods
        
        % CONSTRUCTOR
        function me = bMainGuiGraph(groupObject,parentUI,displayType,displayWindow)
            me.Group         = groupObject;
            me.ParentUI      = parentUI;
            me.DisplayType   = displayType;
            me.DisplayWindow = displayWindow;
        end
        
        % KILL - DESTRUCTOR
        function kill(me)
            if ishandle(me.BasePanel)
                delete(me.BasePanel);
            end
        end
        
        % INITIAL PANELS CONSTRUCTION
        function buildPanels(me,width, height)
            if height < 3
                throw(MException('batalef:gui:impossibleSize',''));
            end
            me.BasePanel = uipanel(...
                'Units',     'character',...
                'Position',  [0,0,width,height],...
                'UserData',  me,...
                'SizeChangedFcn', @(hObject,eventdata)me.resize(get(hObject,'Position')),...
                'Parent',    me.ParentUI...
                );
            
            me.Slider = uicontrol(...
                'Parent',    me.BasePanel,...
                'Style',     'slider',...
                'Units',     'character',...
                'Position',  [0,0,width,1],...
                'Callback',  @(hObject,evt)me.startTimeChanged(get(hObject,'Value')),...
                'UserData',  me...            
                );

            me.buildButtonsPanel(width,height);
            me.buildValuesPanel(height);
            me.buildAxesPanel(width,height)
            me.clear()

        end
        
        % BUILD VALUES PANEL
        function buildValuesPanel(me, height)
            me.ValuesPanel = uipanel(...
                'Parent',    me.BasePanel,...
                'Units',     'character',....
                'Position',  [0,height - 16,21,12.5],...
                'BorderType', 'none',...
                'UserData',  me...
                );                        

            % Time
            uicontrol(...
                'Parent',    me.ValuesPanel,...
                'Style',     'text',...
                'Units',     'character',...
                'Position',  [1,11,18,1],...
                'String',    'Time (sec)'...
                );
            
            me.TextPointTime = uicontrol(...
                'Parent',    me.ValuesPanel,...
                'Style',     'edit',...
                'String',    '',...
                'Units',     'character',...
                'Position',  [1,9.5,18,1.5],...
                'Enable',    'off',...
                'UserData',  me...            
                );
            
            % Value - AMPLITUDE
            uicontrol(...
                'Parent',    me.ValuesPanel,...
                'Style',     'text',...
                'Units',     'character',...
                'Position',  [1,8,18,1],...
                'String',    'Amplitude'...
                );
            
            me.TextPointValue = uicontrol(...
                'Parent',    me.ValuesPanel,...
                'Style',     'edit',...
                'Units',     'character',...
                'Position',  [1,6.5,18,1.5],...
                'Enable',    'off',...
                'UserData',  me...            
                );            

            % Freq
            uicontrol(...
                'Parent',    me.ValuesPanel,...
                'Style',     'text',...
                'Units',     'character',...
                'Position',  [1,5,18,1],...
                'String',    'Frequency (Hz)'...
                );
            
            me.TextPointFreq = uicontrol(...
                'Parent',    me.ValuesPanel,...
                'Style',     'edit',...
                'String',    '',...
                'Units',     'character',...
                'Position',  [1,3.5,18,1.5],...
                'Enable',    'off',...
                'UserData',  me...            
                );

            % Time
            uicontrol(...
                'Parent',    me.ValuesPanel,...
                'Style',     'text',...
                'Units',     'character',...
                'Position',  [1,2,18,1],...
                'String',    'Power (dB)'...
                );
            
            me.TextPointPower = uicontrol(...
                'Parent',    me.ValuesPanel,...
                'Style',     'edit',...
                'String',    '',...
                'Units',     'character',...
                'Position',  [1,0.5,18,1.5],...
                'Enable',    'off',...
                'UserData',  me...            
                );
            
        end
        
        % BUILD BUTTONS PANEL
        function buildButtonsPanel(me,width,height)
            me.ButtonsPanel = uipanel(...
                'Parent',     me.BasePanel,...
                'Units',      'character',....
                'Position',   [0,height-3.5,width,3.5],...
                'UserData',   me...
                );
            % Title
            me.TextTitle = uicontrol(...
                'Parent',     me.ButtonsPanel,...
                'Style',      'text',...
                'HorizontalAlignment','left',...
                'FontSize',   11,...
                'Units',      'character',...
                'Position',   [1,1.8,100,1.4],...
                'String',     '' );
            
            % display type buttons
            me.DisplayTypeButtonGroup = uibuttongroup(...
                'Parent',     me.ButtonsPanel,...
                'Units',      'characters',...
                'Position',   [0,0,41,2],...
                'BorderType', 'none',...
                'SelectionChangedFcn', @(hObject,evt)me.displayTypeChanged()...
                );
            me.PushButtonTS = uicontrol(...
                me.DisplayTypeButtonGroup,...
                'Style',      'toggle',...
                'Units',      'character',...
                'Position',   [0,0,11,1.5],...
                'String',     'TS Only',...
                'UserData',   me.tsDisplayType...
                );
            me.PushButtonSpec = uicontrol(...
                me.DisplayTypeButtonGroup,...
                'Style',     'toggle',...
                'Units',     'character',...
                'Position',  [11,0,22,1.5],...
                'String',    'Spectrogram Only',...
                'UserData',  me.specDisplayType...
                );
            me.PushButtonBoth = uicontrol(...
                me.DisplayTypeButtonGroup,...
                'Style',     'toggle',...
                'Units',     'character',...
                'Position',  [33,0,8,1.5],...
                'String',    'Both',...
                'UserData',  me.bothDisplayType...
                );
            
            % text boxes
            textsPanel = uipanel('Parent',me.ButtonsPanel,'Units','character','Position',[42,0,120,2],'BorderType','none');
            uicontrol(...
                'Parent', textsPanel,...
                'Style','text',...
                'Units','character',...
                'Position',[1,0.25,12,1],...
                'HorizontalAlignment','Right',...
                'String', 'Plot Start Time' );
            me.TextTime = uicontrol(...
                'Parent', textsPanel,...
                'Style','edit',...
                'Units','character',...
                'Position',[13,0,14,1.5],...
                'String', '0',...
                'Callback',@(hObject,evt)me.startTimeChanged(str2double(get(hObject,'String')))...
                );
            uicontrol(...
                'Parent', textsPanel,...
                'Style','text',...
                'Units','character',...
                'Position',[29,0.25,11,1],...
                'HorizontalAlignment','Right',...
                'String', 'Plot Span (sec)' );
            me.TextDisplayWindow = uicontrol(...
                'Parent', textsPanel,...
                'Style','edit',...
                'Units','character',...
                'Position',[40,0,14,1.5],...
                'String', num2str(me.DisplayWindow),...
                'Callback',@(hObject,evt)me.displayWindowChanged(str2double(get(hObject,'String')))...
                );
%             me.CheckboxMADL = uicontrol(...
%                 'Parent', textsPanel,...
%                 'Style','checkbox',...
%                 'Units','character',...
%                 'Position',[56,0.20,8,1.1],...
%                 'Value',0,...
%                 'String', 'MADL',...
%                 'TooltipString', 'Manual Amplitude Display Limits',...
%                 'Callback',@(hObject,evt)me.madlCbChanged()...
%                 );
%             me.TextYlim = uicontrol(...
%                 'Parent', textsPanel,...
%                 'Style','edit',...
%                 'Units','character',...
%                 'Position',[64,0,10,1.5],...
%                 'String', '',... %num2str(me.Ylim),...
%                 'Enable', 'off',...
%                 'Callback',@(hObject,evt)me.ylimTextChanged(str2double(get(hObject,'String')))...
%                 );
            uicontrol(textsPanel,...
                'Style','text',...
                'Units','character',...
                'Position',[56,0.25,25,1],...
                'String','Spectrogram Range');
            me.ComboSpecRange = uicontrol(textsPanel,...
                'Style','popupmenu',...
                'Units','character',...
                'String','foo',...
                'Value',1,...
                'Position',[83,0,20,1.5],...
                'Callback',@(h,~)me.specRangeChanged(get(h,'Value')));
            me.buildSpecRangeCombo(false)
            uicontrol(...
                'Parent', textsPanel,...
                'Style','pushbutton',...
                'Units','character',...
                'Position',[110,0,10,1.5],...
                'String', 'Full TS',...
                'Callback', @(~,~)me.fullTS()...
                );                
            
        end

        % BUILD AXES PANEL
        function buildAxesPanel(me,width,height)
            me.AxesPanel = uipanel(...
                'Parent',     me.BasePanel,...
                'Units',      'character',....
                'Position',   [15,1,width-15,height-4.5],...
                'BorderType', 'none',...
                'UserData',   me...
                );
            me.AxesTS = axes(...
                'Parent',   me.AxesPanel,...
                'Visible',  'off',...
                'UserData', {me,'TS'},...
                'UIContextMenu',me.Gui.ContextMenu...
                );
            me.AxesSpec = axes(...
                'Parent',   me.AxesPanel,...
                'Visible',  'off',...
                'UserData', {me,'Spec'},...
                'UIContextMenu',me.Gui.ContextMenu...
                );
            
            me.resizeAxes();
        end        

        % RESIZE AXES
        function resizeAxes(me)
            switch me.DisplayType
                case me.tsDisplayType
                    set(me.AxesTS,'Units','normalized','Position',[0,0,1,1],'Visible','off');
                    set(me.AxesSpec,'Units','normalized','Position',[0,0,0,0],'Visible','off');
                    tsVisible = true;
                    specVisible = false;
                case me.specDisplayType
                    set(me.AxesTS,'Units','normalized','Position',[0,0,0,0],'Visible','off');
                    set(me.AxesSpec,'Units','normalized','Position',[0,0,1,1],'Visible','off');
                    tsVisible = false;
                    specVisible = true;                    
                case me.bothDisplayType
                    set(me.AxesTS,'Units','normalized','Position',[0,0,0.5,1],'Visible','off');
                    set(me.AxesSpec,'Units','normalized','Position',[0.5,0,0.5,1],'Visible','on');                    
                    tsVisible = true;
                    specVisible = true;                    
            end
            
            if tsVisible
                set(me.AxesTS,'Units','character');
                pos = get(me.AxesTS,'Position');
                pos = pos + [8,4,-10,-6];
                set(me.AxesTS,'Position',pos,'Visible','on');
            end
            if specVisible
                set(me.AxesSpec,'Units','character');
                pos = get(me.AxesSpec,'Position');
                pos = pos + [8,4,-10,-6];
                set(me.AxesSpec,'Position',pos,'Visible','on');
            end
            
            % context menu
            set(me.AxesTS,  'UIContextMenu',me.Gui.ContextMenu);
            set(me.AxesSpec,'UIContextMenu',me.Gui.ContextMenu);
            
            % find global position in pixels relative to figure
            absParentPanel = uiPosition(me.BasePanel,'pixels');
            relAxesPanel   = uiPosition(me.AxesPanel,'pixels');
            relAxesTS      = uiPosition(me.AxesTS,'pixels');
            relAxesSpec    = uiPosition(me.AxesSpec,'pixels');
            absAxesTS   = relAxesTS   + [1,1,0,0].*relAxesPanel + [1,1,0,0].*absParentPanel;
            absAxesSpec = relAxesSpec + [1,1,0,0].*relAxesPanel + [1,1,0,0].*absParentPanel;
            me.AxesTSFigurePosition   = absAxesTS;
            me.AxesSpecFigurePosition = absAxesSpec;
        end
        
        % RESIZE
        function resize(me,~)
            set(me.BasePanel,'Units','characters');
            pos = get(me.BasePanel,'Position');
            %set(me.BasePanel,'Units','normalized');
            width  = pos(3);
            height = pos(4);
            set(me.AxesPanel,'Position',[21,1,width-21,height-4.5]);
            set(me.ButtonsPanel,'Position',[0,height-3.5,width,3.5]);
            set(me.ValuesPanel,'Position',[0,height - 16,21,12.5]);
            me.resizeAxes();
            set(me.Slider,'Position',[0,0,width,1]);
        end
        
        % DISPLAY TYPE CHANGED
        function displayTypeChanged(me)
            sel = get(me.DisplayTypeButtonGroup,'SelectedObject');
            displayType = get(sel,'UserData');
            if me.Group.Linked
                me.Group.changeDisplayType(displayType,[]);
            else
                me.setDisplayType(displayType);
            end
        end
        function setDisplayType(me,displayType)
            me.DisplayType = displayType;
            switch displayType
                case me.tsDisplayType
                    set(me.PushButtonTS,'Value',1);
                case me.specDisplayType
                    set(me.PushButtonSpec,'Value',1);
                case me.bothDisplayType
                    set(me.PushButtonBoth,'Value',1);
            end
            me.resizeAxes();
            me.plot();
        end
        
%         % MADL CHANGED
%         function madlCbChanged(me)
%         end
%         function ylimTextChanged(me,val)
%         end
           
        % BUILD SPECTROGRAM RANGES COMBO
        function buildSpecRangeCombo(me,useSelfValue)
            R = ggetParam('displaySpectrogram_ranges');
            if exist('useSelfValue','var') && ~useSelfValue
                I = ggetParam('displaySpectrogram_range2use');
            else
                I = get(me.ComboSpecRange,'Value');
            end
            C = cellfun(@(v)strcat('[',num2str(v),']'),R,'UniformOutput',false);
            S = ['Auto', C, 'Add custom'];
            S{2} = strcat(['Low    ',S{2}]);
            S{3} = strcat(['High   ',S{3}]);
            S{4} = strcat(['Middle ',S{4}]);
            S{5} = strcat(['Wide   ',S{5}]);
            n = length(S);
            for i = 6:(n-1)
                S{i} = strcat(['Custom ',S{i}]);
            end
            set(me.ComboSpecRange,'String',S,'Value',I);
        end
            
        % CLEAR DISPLAY
        function clear(me)
            cla(me.AxesTS);
            cla(me.AxesSpec);
            set(me.Slider, 'Visible','off');
            set(me.AxesPanel,'Visible','off');
            set(me.TextTime,'String','');
            set(me.TextTitle,'String','');
            me.FileIdx = 0;
            me.ChannelIdx = 0;
        end
        
        % SET THE CHANNEL TO DISPLAY
        function setFileChannel(me,fileIdx,channelIdx)
            me.FileIdx = fileIdx;
            me.ChannelIdx = channelIdx;
            me.setSlider();
%             if ~isempty(me.Ylim) && me.MADL
%                 % do nothing
%             else
                me.Ylim = fileData(me.FileIdx,'Ylim');
%             end
            me.plot();
            title = fileData(me.FileIdx,'Title');
            me.Title = strcat(['File: ',num2str(me.FileIdx),'   (',title,') ;  Channel:   ',num2str(me.ChannelIdx)]);
            set(me.TextTitle,'String',me.Title);
        end
        
        % SET SLIDER
        function setSlider(me)
            set(me.Slider, 'Visible','off');
            if me.FileIdx == 0
                M = 0;
            else
                audioLength = fileData(me.FileIdx,'Length');
                M = max(audioLength-me.DisplayWindow,0);
            end
            if M > 0
                S = (me.DisplayWindow/M).*[0.5,1];
                vis = 'on';
            else
                S = [0.5,1];
                vis = 'off';
            end
            V = get(me.Slider, 'Value');
            if V > M
                V = M;
            end
            set(me.Slider, 'Min',0,'Max',M,'SliderStep',S,'Value',V,'Visible',vis);
        end
        
        
        % SHOW FROM TIME + START TIME CHANGED
        function showFromTime(me,startTime)
            me.DisplayStartTime = startTime;
            me.plot();
            set(me.TextTime,'String',num2str(me.DisplayStartTime));
        end
        function startTimeChanged(me,startTime)
            if me.Group.Linked
                me.Group.changeStartTime(startTime,[]);
            else
                me.showFromTime(startTime);
            end
        end
        
        % PLOT
        function plot(me)
            
            dataset = me.Dataset;
            if isempty(dataset)
                return;
            end
            
            switch me.DisplayType
                case me.tsDisplayType
                    me.plotTS(dataset);
                case me.specDisplayType
                    me.plotSpec(dataset);
                case me.bothDisplayType
                    me.plotTS(dataset);
                    me.plotSpec(dataset);
            end
            
            set(me.AxesTS,  'UserData', {me,'TS'}  );
            set(me.AxesSpec,'UserData', {me,'Spec'});
            set(me.AxesPanel,'Visible','on');
        end
        function plotTS(me,dataset)
            if isempty(dataset)
                cla(me.AxesTS);
            else
                p = plot(me.AxesTS,dataset(:,2),dataset(:,1));
                set(p,'UIContextMenu',me.Gui.ContextMenu);
                axis(me.AxesTS,'tight','on');
                axis(me.AxesTS,'tight','manual');
                Tlim = get(me.AxesTS,'Xlim');
                Alim = get(me.AxesTS,'Ylim');
                set(me.AxesTS,'Visible','on','Ylim',me.Ylim.*1.1);
                axes(me.AxesTS);
                switch ggetParam('mainGui_showPois')
                    case 'dont'
                    case 'marks'
                        [T] = channelData(me.FileIdx,me.ChannelIdx,'PoI','TimeInterval',Tlim);
                        A = diff(Alim)/2.*ones(size(T));
                        hold on
                        p = plot(T,A,'g*');
                        set(p,'UIContextMenu',me.Gui.ContextMenu);
                        hold off;
                    case 'texts'
                        [T,TXT] = channelData(me.FileIdx,me.ChannelIdx,'PoI','TimeInterval',Tlim);
                        A = diff(Alim)/2.*ones(size(T)); 
                        hold on
                        p = plot(T,A,'g*');
                        set(p,'UIContextMenu',me.Gui.ContextMenu);
                        text(T,A,TXT);
                        hold off;                        
                end
            end
        end
        function plotSpec(me,dataset)
            if isempty(dataset)
                cla(me.AxesSpec);
            else
                spec = me.GuiTop.Methods.displaySpectrogram.execute(dataset(:,1), fileData(me.FileIdx,'Fs'));
                spec.T = spec.T + dataset(1,2);
                axes(me.AxesSpec);
                R = me.SpecRange;
                if isempty(R)
                    me.SpecImage = imagesc(spec.T,spec.F,spec.P);
                    set(me.SpecImage,'UIContextMenu',me.Gui.ContextMenu);
                else
                    me.SpecImage = imagesc(spec.T,spec.F,spec.P,R);
                    set(me.SpecImage,'UIContextMenu',me.Gui.ContextMenu);
                end
                set(me.AxesSpec,'YDir','normal');
                Tlim = get(me.AxesSpec,'Xlim');
                Flim = get(me.AxesSpec,'Ylim');
                axes(me.AxesSpec);
                switch ggetParam('mainGui_showPois')
                    case 'dont'
                    case 'marks'
                        [T] = channelData(me.FileIdx,me.ChannelIdx,'PoI','TimeInterval',Tlim);
                        F = diff(Flim)/2.*ones(size(T));
                        hold on
                        p = plot(T,F,'g*');
                        set(p,'UIContextMenu',me.Gui.ContextMenu);
                        hold off;
                    case 'texts'
                        [T,TXT] = channelData(me.FileIdx,me.ChannelIdx,'PoI','TimeInterval',Tlim);
                        F = diff(Flim)/2.*ones(size(T));
                        hold on
                        p = plot(T,F,'g*');
                        set(p,'UIContextMenu',me.Gui.ContextMenu);
                        text(T,F,TXT);
                        hold off;                        
                end                
            end
        end
        
        % DISPLAY START TIME PROPERTY (GET/SET)
        function val = get.DisplayStartTime(me)
            if ishandle(me.Slider)
                val = get(me.Slider,'Value');
            else
                val = NaN;
            end
        end
        function set.DisplayStartTime(me,val)
            M = get(me.Slider, 'Max');
            if val > M
                val = M;
            end
            set(me.Slider, 'Value', val);
        end
        
        % DATASET (GET ONLY)
        function val = get.Dataset(me)
            window = [0,me.DisplayWindow] + me.DisplayStartTime;
            if me.FileIdx == 0
                val = [];
            else
                [D,T] = channelData(me.FileIdx,me.ChannelIdx,'TS','TimeInterval',window);
                val = [D,T'];
            end
        end
        
        % VISIBLE PROPERTY (SET/GET)
        function val = get.Visible(me)
            val = get(me.BasePanel,'Visible');
        end
        function set.Visible(me,val)
            set(me.BasePanel,'Visible',val);
        end
        
        % MOUSE MOTION
        function hit = mouseMotion(me,x) % X should be in pixels
            y = x - me.AxesTSFigurePosition(1:2);
            if min(y > 0) && min(y < me.AxesTSFigurePosition(3:4))
                z = y./me.AxesTSFigurePosition(3:4);
                me.mouseMotionTS(z);
                hit = true;
                me.Gui.LastAxesObject = me.AxesTS;
                me.Gui.LastGraphObject = me;
                return;
            end
            y = x - me.AxesSpecFigurePosition(1:2);
            if min(y > 0) && min(y < me.AxesSpecFigurePosition(3:4))
                z = y./me.AxesSpecFigurePosition(3:4);
                me.mouseMotionSpec(z);
                hit = true;
                me.Gui.LastAxesObject = me.AxesSpec;
                me.Gui.LastGraphObject = me;
                return;
            end
            hit = false;
        end
        function mouseMotionTS(me,z)
            xlim = get(me.AxesTS,'Xlim');
            ylim = get(me.AxesTS,'Ylim');
            time  = z(1)*diff(xlim) + xlim(1);
            value = z(2)*diff(ylim) + ylim(1);
            set(me.TextPointTime, 'String',num2str(time,'%1.3e\n'));
            set(me.TextPointValue,'String',num2str(value,'%1.3e\n'));
            set(me.TextPointFreq, 'String','');
            set(me.TextPointPower,'String','');

            me.Group.showMouseMarks(time);
        end
        function mouseMotionSpec(me,z)
            xlim = get(me.AxesSpec,'Xlim');
            ylim = get(me.AxesSpec,'Ylim');
            time  = z(1)*diff(xlim) + xlim(1);
            freq  = z(2)*diff(ylim) + ylim(1);
            CData = get(me.SpecImage,'CData');
            XData = get(me.SpecImage,'XData');
            YData = get(me.SpecImage,'YData');
            [~,t] = min(abs(XData-time));
            [~,f] = min(abs(YData-freq));
            power = CData(f,t);
            set(me.TextPointTime, 'String',num2str(time, '%1.3e\n'));
            set(me.TextPointValue,'String','');
            set(me.TextPointFreq, 'String',num2str(freq, '%1.3e\n'));
            set(me.TextPointPower,'String',num2str(power,'%1.3e\n'));            
            
            me.Group.showMouseMarks(time);
        end
        
        % SHOW MOUSE MARKS
        function showMouseMarks(me,t)
            me.showTSMark(t);
            me.showSpecMark(t);
        end
        function showTSMark(me,t)
            if ishandle(me.TSMark)
                delete(me.TSMark);
            end            
            hold(me.AxesTS,'on');
            ylim = get(me.AxesTS,'Ylim');
            y = ylim(1) + diff(ylim)/2;
            me.TSMark = plot(me.AxesTS,t,y,'rx');
            hold(me.AxesTS,'off');            
        end
        function showSpecMark(me,t)
            if ishandle(me.SpecMark)
                delete(me.SpecMark);
            end
            hold(me.AxesSpec,'on');
            ylim = get(me.AxesSpec,'Ylim');
            y = ylim(1) + diff(ylim)/2;
            me.SpecMark = plot(me.AxesSpec,t,y,'rx');
            hold(me.AxesSpec,'off');
        end            
        
        % SET THE DISPLAY WINDOW (PROPERTY + SLIDER + PLOT)
        function setDisplayWindow(me,window)
            me.DisplayWindow = window;
            set(me.TextDisplayWindow,'String',num2str(window));
            me.setSlider();
            me.plot();
        end
        function displayWindowChanged(me,window)
            if me.Group.Linked
                me.Group.changeDisplayWindow(window,[]);
            else
                me.setDisplayWindow(window);
            end
        end

        % SPECTROGRAM RANGE PROPERTY
        function specRangeChanged(me,rangeID)
            n = length(get(me.ComboSpecRange,'String'));
            if rangeID == n
                me.Group.addNewSpecRange();
            else
                if me.Group.Linked
                    me.Group.changeSpecRange(rangeID,[]);
                else
                    me.SpecRange = rangeIS;
                end 
            end
        end
        function set.SpecRange(me,rangeID)
            if isempty(rangeID)
                rangeID = 1;
            end
            set(me.ComboSpecRange,'Value',rangeID);
            me.plotSpec(me.Dataset);
        end
        function val = get.SpecRange(me)
            v = get(me.ComboSpecRange,'Value');
            if isempty(v)
                val = [];
            elseif v == 1
                val = [];
            else
                R = ggetParam('displaySpectrogram_ranges');
                val = R{v-1};
            end
        end
        
%         % MADL CHECKBOX / PROPERTY
%         function val = get.MADL(me)
%             val = get(me.CheckboxMADL,'Value');
%         end
%         function set.MADL(me,val)
%             set(me.CheckboxMADL, 'Value', val);
%             if val
%                 set(me.TextYlim,'Enable','on');
%             else
%                 set(me.TextYlim,'Enable','off');
%                 
%             end
%         end
        
        % POPUP FULL TS
        function fullTS(me)
            if me.FileIdx == 0
                msgbox('Not assigned to file/channel');
            else
                figure('NumberTitle','off','Name',me.Title);
                [TS,T] = channelData(me.FileIdx,me.ChannelIdx,'TS');
                plot(T,TS);
            end
        end
        
        % GUI TOP GET PROPERTY
        function val = get.GuiTop(me)
            val = me.Group.GuiTop;
        end
        
        % APPLICATION GET PROPERTY
        function val = get.Application(me)
            val = me.Group.GuiTop.Application;
        end
        
        % GUI
        function val = get.Gui(me)
            val = me.Group.Gui;
        end
    end
    
end

