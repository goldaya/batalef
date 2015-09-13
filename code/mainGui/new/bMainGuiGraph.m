classdef bMainGuiGraph < handle
%BMAINGUIGRAPH class for handling main gui grpah. an instance is child of a
%bMainGuiGraphGroup object

    
    properties (Access = public)

    end
    
    properties (Access = ?bMainGuiGraphGroup)
        BasePanel
        AxesTS
        AxesSpec
        Idx
    end
    
    properties (Access = private)

        Group
        FileIdx
        ChannelIdx
        DisplayType
        DisplayWindow
        Ylim

        ParentUI
        Slider = NaN;
        
        ValuesPanel
        TextPointTime
        TextPointValue
        TextPointFreq
        TextPointPower
        
        ButtonsPanel
        DisplayTypeButtonGroup
        PushButtonTS
        PushButtonSpec
        PushButtonBoth
        TextTime
        TextDisplayWindow
        TextTitle
        
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
                'Callback',  @(hObject,evt)me.startTimeChange(get(hObject,'Value')),...
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
                'Units',     'ch            aracter',...
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
                'Position',   [1,2,100,1],...
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
            textsPanel = uipanel('Parent',me.ButtonsPanel,'Units','character','Position',[42,0,72,2],'BorderType','none');
            uicontrol(...
                'Parent', textsPanel,...
                'Style','text',...
                'Units','character',...
                'Position',[1,0.25,15,1],...
                'HorizontalAlignment','Right',...
                'String', 'Plot Start Time' );
            me.TextTime = uicontrol(...
                'Parent', textsPanel,...
                'Style','edit',...
                'Units','character',...
                'Position',[16,0,14,1.5],...
                'String', '0',...
                'Callback',@(hObject,evt)me.startTimeChange(str2double(get(hObject,'String')))...
                );
            uicontrol(...
                'Parent', textsPanel,...
                'Style','text',...
                'Units','character',...
                'Position',[31,0.25,15,1],...
                'HorizontalAlignment','Right',...
                'String', 'Plot Span (sec)' );
            me.TextDisplayWindow = uicontrol(...
                'Parent', textsPanel,...
                'Style','edit',...
                'Units','character',...
                'Position',[46,0,14,1.5],...
                'String', num2str(me.DisplayWindow),...
                'Callback',@(hObject,evt)me.displayWindowChanged(str2double(get(hObject,'String')))...
                );
            uicontrol(...
                'Parent', textsPanel,...
                'Style','pushbutton',...
                'Units','character',...
                'Position',[65,0,11,1.5],...
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
                'Visible',  'off'...
                );
            me.AxesSpec = axes(...
                'Parent',   me.AxesPanel,...
                'Visible',  'off'...
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
            me.resizeAxes();
            me.plot();
        end
        
        % CLEAR DISPLAY
        function clear(me)
            cla(me.AxesTS);
            cla(me.AxesSpec);
            set(me.Slider, 'Visible','off');
            set(me.AxesPanel,'Visible','off');
            set(me.TextTime,'String','');
            set(me.TextTitle,'String','');
        end
        
        % SET THE CHANNEL TO DISPLAY
        function setFileChannel(me,fileIdx,channelIdx)
            me.FileIdx = fileIdx;
            me.ChannelIdx = channelIdx;
            me.setSlider();
            me.Ylim = fileData(me.FileIdx,'Ylim');
            me.plot();
            title = fileData(me.FileIdx,'Title');
            topString = strcat(['File: ',num2str(me.FileIdx),'   (',title,') ;  Channel:   ',num2str(me.ChannelIdx)]);
            set(me.TextTitle,'String',topString);
        end
        
        % SET SLIDER
        function setSlider(me)
            set(me.Slider, 'Visible','off');
            audioLength = fileData(me.FileIdx,'Length');
            M = max(audioLength-me.DisplayWindow,0);
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
        function startTimeChange(me,startTime)
            if me.Group.Linked
                me.Group.changeStartTime(startTime,[]);
            else
                me.showFromTime(startTime);
            end
        end
        
        % PLOT
        function plot(me)
            
            dataset = me.Dataset;
            
            switch me.DisplayType
                case me.tsDisplayType
                    me.plotTS(dataset);
                case me.specDisplayType
                    me.plotSpec(dataset);
                case me.bothDisplayType
                    me.plotTS(dataset);
                    me.plotSpec(dataset);
            end
            
            set(me.AxesPanel,'Visible','on');
        end
        function plotTS(me,dataset)
            plot(me.AxesTS,dataset(:,2),dataset(:,1));
            axis(me.AxesTS,'tight','on');
            axis(me.AxesTS,'tight','manual');
            set(me.AxesTS,'Visible','on','Ylim',me.Ylim);
        end
        function plotSpec(me,dataset)
            spec = somAdminCompute(dataset(:,1), fileData(me.FileIdx,'Fs'));
            spec.T = spec.T + dataset(1,2);
            axes(me.AxesSpec);
            me.SpecImage = imagesc(spec.T,spec.F,spec.P);
            set(me.AxesSpec,'YDir','normal');            
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
        
        % DISPLAYED DATASET (GET ONLY)
        function val = get.Dataset(me)
            window = [0,me.DisplayWindow] + me.DisplayStartTime;
            [D,T] = channelData(me.FileIdx,me.ChannelIdx,'TS','TimeInterval',window);
            val = [D,T];
        end
        
        % VISIBLE PROPERTY (SET/GET)
        function val = get.Visible(me)
            val = get(me.BasePanel,'Visible');
        end
        function set.Visible(me,val)
            set(me.BasePanel,'Visible',val);
        end
        
        % MOUSE MOTION
        function mouseMotion(me,x) % X should be in pixels
            y = x - me.AxesTSFigurePosition(1:2);
            if min(y > 0) && min(y < me.AxesTSFigurePosition(3:4))
                z = y./me.AxesTSFigurePosition(3:4);
                me.mouseMotionTS(z);
                return;
            end
            y = x - me.AxesSpecFigurePosition(1:2);
            if min(y > 0) && min(y < me.AxesSpecFigurePosition(3:4))
                z = y./me.AxesSpecFigurePosition(3:4);
                me.mouseMotionSpec(z);
                return;
            end            
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
            me.TSMark = plot(me.AxesTS,t,y,'ro');
            hold(me.AxesTS,'off');            
        end
        function showSpecMark(me,t)
            if ishandle(me.SpecMark)
                delete(me.SpecMark);
            end
            hold(me.AxesSpec,'on');
            ylim = get(me.AxesSpec,'Ylim');
            y = ylim(1) + diff(ylim)/2;
            me.SpecMark = plot(me.AxesSpec,t,y,'ro');
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
        
        % POPUP FULL TS
        function fullTS(me)
            figure;
            [TS,T] = channelData(me.FileIdx,me.ChannelIdx,'TS');
            plot(T,TS);
        end
        
    end
    
end

