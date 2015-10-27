 classdef bCallGui < bGuiDefinition & hgsetget
   %BCALLGUI Channel call analysis
    
   properties % GENERAL
       WorkMode = 'display-relaxed';
       Call % a bChanelCall object
       FileIdx = 0;
       ChannelIdx = 1;
       CallIdx    = 1;
       CallType
       ChannelTimeSeries  = [];
       ChannelTimeVector  = [];
       ChannelFilteredTS  = [];
       ChannelEnvelopedTS = [];
       SpecImage = [];
       SpectrumImage = [];
       Keep = true;
       
       
   end
   
    properties % BUILD
        IndexPanel
          ComboChannel
          ComboCall
          PmodePanel
            CheckboxFeatures
            CheckboxForLocalization
            CheckboxForBeam
          DmodePanel
            DmodeGroup
        
        ActivePanel
          ActiveAxesPanel
            AxesSpectrogram
            AxesEnvelope
          ActiveParamsPanel
            TextAnalysisWindow
            TextD2P
            ButtonFilter
            TextStartThreshold
            TextEndThreshold
            TextGapTolerance
            ComboSpecRange
            MessageDisplayRelaxed
          ActiveButtonsPanel
            ButtonAnalyze
            ButtonSave
            ButtonNext
            ButtonDelete
        
        StaticPanel
          StaticAxesPanel
            AxesSpectrum
            AxesTS
          StaticValuesPanel
            TextValueStartValue
            TextValueStartTime
            TextValueStartFreq
            TextValueStartPower
            TextValuePeakValue
            TextValuePeakTime
            TextValuePeakFreq
            TextValuePeakPower
            TextValueEndValue
            TextValueEndTime
            TextValueEndFreq
            TextValueEndPower
            TextValueDuration
            TextValueIPI
            TextValueBandwidth
            
        Menus
        DisRelxModeMenuItem
        DisHardModeMenuItem
        ProcModeMenuItem
        MenuFilter
        MenuEnvelope
        MenuSpectrogram
        MenuSpectrum
        MenuKeepOn
        MenuKeepOff
        
        InteractiveUI
        StatsTexts
        AxesObjects
        
    end
    
    properties (Constant = true)
        TopPanelMinSize    = [150,4.3];
        ActivePanelMinSize = [150,28];
        StaticPanelMinSize = [150,28];
    end
    
    properties (Dependent = true)
        DisplayType
        SpecRange
    end
    
    methods
        
        % CONSTRUCTOR
        function me = bCallGui(guiTop,name)
            me = me@bGuiDefinition(guiTop,name);
            me.Build = true;
            minWidth = max([me.TopPanelMinSize(1),me.ActivePanelMinSize(1),me.StaticPanelMinSize(1)]);
            minHeight = me.TopPanelMinSize(2) + me.ActivePanelMinSize(2) + me.StaticPanelMinSize(2);
            me.Figure = figure(...
                'Units','character',...
                'Position',[0,0,minWidth,minHeight],...
                'Visible','off',...
                'ToolBar','none',...
                'MenuBar','none',...
                'Name','BATALEF - Channel Call Analysis',...
                'NumberTitle','off',...
                'CloseRequestFcn',@(~,~)me.Top.removeGui(me.Name),...
                'SizeChangedFcn',@(~,~)me.resize());
            
            % The gui has 3 sections: 
            % TOP where the ribbon is + indices of channel and call +
            % dis/proc type
            % ACTIVE where the user type values and push buttons in order
            % to analyze the call
            % STATIC where the call analysis data is displayed
            % CONTEXT MENUS are for the envelope & spectrogram in the
            % active section
            me.buildContextMenu();
            me.buildTopPanels();
            me.buildActivePanel();
            me.buildStaticPanel();
            me.buildMenus();
            
            % set desired position + visibility + start in display mode
            me.setDisplayedFiles(me.DisplayVector)
            set(me,'Visible','on');            
            me.setWorkMode('display-relaxed');
            
            % end build
            me.Build = false;
            me.showCall();
        end
        
        % DESTRUCTOR
        function delete(me)
            me.Application.Methods.callAnalysisFilter.removeMenu(me.MenuFilter);
            me.Application.Methods.callAnalysisEnvelope.removeMenu(me.MenuEnvelope);
            me.Application.Methods.callAnalysisSpectrogram.removeMenu(me.MenuSpectrogram);
            me.Application.Methods.callAnalysisSpectrum.removeMenu(me.MenuSpectrum);
            delete(me.Figure);
        end

        % BUILD TOP PANELS
        function buildTopPanels(me)
            me.SelectionRibbon = bSelectionRibbon(me,false,true);
            pos = uiPosition(me.SelectionRibbon.Panel,'characters');
            
            % dis/proc types
            modePanelsPosition = [pos(3)-20,0,20,pos(4)];
            me.DmodePanel = uipanel(me.SelectionRibbon.Panel,'Units','character','Position',modePanelsPosition,'Visible','off','BorderType','none');
                me.DmodeGroup = uibuttongroup('Parent',me.DmodePanel,'Units','normalized','Position',[0,0,1,1],'SelectionChangedFcn',@(h,~)me.disTypeChange(get(get(h,'SelectedObject'),'UserData'),h),'BorderType','none');
                s = uicontrol(me.DmodeGroup,'Style','radiobutton','Units','normalized','Position',[0,0.666,1,0.333],'String','Features','UserData',{'features'});
                uicontrol(me.DmodeGroup,'Style','radiobutton','Units','normalized','Position',[0,0.333,1,0.333],'String','Localization','UserData',{'forLocalization'});
                uicontrol(me.DmodeGroup,'Style','radiobutton','Units','normalized','Position',[0,0.001,1,0.333],'String','Beam','UserData',{'forBeam'});
                set(me.DmodeGroup,'SelectedObject',s);
                
            me.PmodePanel = uipanel(me.SelectionRibbon.Panel,'Units','character','Position',modePanelsPosition,'Visible','off','BorderType','none');
                me.CheckboxFeatures        = uicontrol(me.PmodePanel,'Style','checkbox','Units','normalized','Position',[0,0.666,1,0.333],'String','Features','Value',1);
                me.CheckboxForLocalization = uicontrol(me.PmodePanel,'Style','checkbox','Units','normalized','Position',[0,0.333,1,0.333],'String','Localization');
                me.CheckboxForBeam         = uicontrol(me.PmodePanel,'Style','checkbox','Units','normalized','Position',[0,0.001,1,0.333],'String','Beam');
                
            % channel / call selectors
            me.IndexPanel = uipanel(me.SelectionRibbon.Panel,'Units','character','Position',[pos(3)-20-20,0,20,pos(4)],'BorderType','none');
                uicontrol(me.IndexPanel,'Style','text','String','Channel:','HorizontalAlignment','right','Units','character','Position',[0,2.6,10,1]);
                me.ComboChannel = uicontrol(me.IndexPanel,'Style','popupmenu','String','foo','Value',1,'Units','character','Position',[11,2.4,7,1.4],'Callback',@(h,~)me.changeChannel(get(h,'Value'),true));
                uicontrol(me.IndexPanel,'Style','text','String','Call:','HorizontalAlignment','right','Units','character','Position',[0,0.7,10,1]);
                me.ComboCall = uicontrol(me.IndexPanel,'Style','popupmenu','String','foo','Value',1,'Units','character','Position',[11,0.5,7,1.4],'Callback',@(h,~)me.changeCall(get(h,'Value'),true));
        end
        
        % BUILD ACTIVE SECTION
        function buildActivePanel(me)
            % this section has 3 panels:
            % AXES with the envelope and spectrogram
            % PARAMS with the parameters for analysis
            % BUTTONS with the "analyze", "save", "delete call", etc. buttons
            %
            % when changing the active section build, please maintian the
            % MinActivePanelSize property            
            
            PH = 28;
            me.ActivePanel = uipanel(me.Figure,...
                'Units','character',...
                'Position',[0,me.StaticPanelMinSize(2),me.ActivePanelMinSize(1),PH]);
            
            axesPos = [12,3,34,9]; % +2 for height du to top padding
            me.ActiveAxesPanel = uipanel(me.ActivePanel,...
                'BorderType','none',...
                'Units','character',...
                'Position',[0,0,50,PH]);
            me.AxesEnvelope = axes('Parent',me.ActiveAxesPanel,...
                'Units','character',...
                'Position',axesPos + [0,14,0,0],...
                'UserData',{me,'Envelope'});
            me.AxesSpectrogram = axes('Parent',me.ActiveAxesPanel,...
                'Units','character',...
                'Position',axesPos,...
                'UserData',{me,'Spectrogram'});
            
            me.ActiveParamsPanel = uipanel(me.ActivePanel,...
                'BorderType','none',...
                'Units','character',...
                'Position',[50,0,70,PH]);
            AP = me.ActiveParamsPanel;
            b = PH - 2;
            sw = 45;
            sp = 2;
            vw = 20;
            
            s = 'Analysis Window (msec):';
            b = b - 2;
            v = num2str(agetParam('channelCallAnalysis_window')*1000);
            uicontrol(AP,'Style','text','Units','character','Position',[sp,b+0.5,sw,1],'HorizontalAlignment','left','String',s);
            me.TextAnalysisWindow = uicontrol(AP,'Style','edit','Units','character','Position',[sw+sp,b+0.3,vw,1.4],'String',v,'Callback',@(h,~)me.setAnalysisWindow(str2double(get(h,'String'))/1000));
            me.InteractiveUI = {me.TextAnalysisWindow};
            
            s = 'Detection to Peak window (msec):';
            b = b - 2;
            v = num2str(agetParam('channelCallAnalysis_d2pWindow')*1000);
            uicontrol(AP,'Style','text','Units','character','Position',[sp,b+0.5,sw,1],'HorizontalAlignment','left','String',s);
            me.TextD2P = uicontrol(AP,'Style','edit','Units','character','Position',[sw+sp,b+0.3,vw,1.4],'String',v,'Callback',@(h,~)asetParam('channelCallAnalysis_d2pWindow',str2double(get(h,'String'))/1000));
            me.InteractiveUI = [me.InteractiveUI,{me.TextD2P}];
            
            s = 'Filter (click for details):';
            b = b - 2;
            uicontrol(AP,'Style','text','Units','character','Position',[sp,b+0.5,sw,1],'HorizontalAlignment','left','String',s);
            me.ButtonFilter = uicontrol(AP,'Style','pushbutton','Units','character','Position',[sw+sp,b+0.3,vw,1.4],'String','foo','Callback',@(~,~)me.showFilterDetails());
 
            s = 'Call start threshold (dB):';
            b = b - 2;
            v = num2str(agetParam('channelCallAnalysis_startThreshold'));
            uicontrol(AP,'Style','text','Units','character','Position',[sp,b+0.5,sw,1],'HorizontalAlignment','left','String',s);
            me.TextStartThreshold = uicontrol(AP,'Style','edit','Units','character','Position',[sw+sp,b+0.3,vw,1.4],'String',v,'Callback',@(h,~)asetParam('channelCallAnalysis_startThreshold',str2double(get(h,'String'))));
            me.InteractiveUI = [me.InteractiveUI,{me.TextStartThreshold}];
            
            s = 'Call end threshold (dB):';
            b = b - 2;
            v = num2str(agetParam('channelCallAnalysis_endThreshold'));
            uicontrol(AP,'Style','text','Units','character','Position',[sp,b+0.5,sw,1],'HorizontalAlignment','left','String',s);
            me.TextEndThreshold = uicontrol(AP,'Style','edit','Units','character','Position',[sw+sp,b+0.3,vw,1.4],'String',v,'Callback',@(h,~)asetParam('channelCallAnalysis_endThreshold',str2double(get(h,'String'))));
            me.InteractiveUI = [me.InteractiveUI,{me.TextEndThreshold}];
            
            s = 'Gap tolerance (msec):';
            b = b - 2;
            v = num2str(agetParam('channelCallAnalysis_gapTolerance')*1000);
            uicontrol(AP,'Style','text','Units','character','Position',[sp,b+0.5,sw,1],'HorizontalAlignment','left','String',s);
            me.TextGapTolerance = uicontrol(AP,'Style','edit','Units','character','Position',[sw+sp,b+0.3,vw,1.4],'String',v,'Callback',@(h,~)asetParam('channelCallAnalysis_gapTolerance',str2double(get(h,'String'))/1000));
            me.InteractiveUI = [me.InteractiveUI,{me.TextGapTolerance}];
            
            b = 0;
            me.MessageDisplayRelaxed = uicontrol(AP,'Style','text','Units','character','Position',[sp,b+0.5,200,3],'String',sprintf('Relaxed Display Mode!\nGraphs might not represent data at original analysis'),'ForegroundColor',[1,0,0],'Visible','off','HorizontalAlignment','Left');
            
            b = 4;
            uicontrol(AP,...
                'Style','text',...
                'Units','character',...
                'Position',[sp,b+0.5,sw,1],...
                'HorizontalAlignment','Left',...
                'String','Spectrogram Range');
            me.ComboSpecRange = uicontrol(AP,...
                'Style','popupmenu',...
                'Units','character',...
                'String','foo',...
                'Value',1,...
                'Position',[sw+sp,b+0.3,vw,1.4],...
                'Callback',@(h,~)me.specRangeChanged(get(h,'Value')));
            me.buildSpecRangeCombo(false)            

            
            me.ActiveButtonsPanel = uipanel(me.ActivePanel,...
                'BorderType','none',...
                'Units','character',...
                'Position',[120,0,30,PH]);
            AB = me.ActiveButtonsPanel;
            p = 5;
            w = 20;
            h = 1.4;
            b = PH - 2;
            
            s = 'Analyze';
            b = b - 2;
            me.ButtonAnalyze = uicontrol(AB,'Style','pushbutton','Units','character','Position',[p,b,w,h],'String',s,'Callback',@(~,~)me.analyzeCallButton());
            me.InteractiveUI = [me.InteractiveUI,{me.ButtonAnalyze}];
            
            s = 'Save';
            b = b - 2;
            me.ButtonSave = uicontrol(AB,'Style','pushbutton','Units','character','Position',[p,b,w,h],'String',s,'Callback',@(~,~)me.saveCall());
            me.InteractiveUI = [me.InteractiveUI,{me.ButtonSave}];
            
            s = 'Next Call';
            b = b - 2;
            me.ButtonNext = uicontrol(AB,'Style','pushbutton','Units','character','Position',[p,b,w,h],'String',s,'Callback',@(~,~)me.nextCall());

            s = 'Delete Call';
            b = b - 2;
            me.ButtonDelete = uicontrol(AB,'Style','pushbutton','Units','character','Position',[p,b,w,h],'String',s,'Callback',@(~,~)me.deleteCall('ask'));
            

        end
        
        % BUILD STATIC SECTION
        function buildStaticPanel(me)
            % the static section has 2 parts:
            % AXES with TS + spectrum display of the realised call
            % VALUES with the analysis results
            % 
            % when changing the static section build, please maintian the
            % MinStaticPanelSize property
            
            PH = 28;
            me.StaticPanel = uipanel(me.Figure,...
                'Units','character',...
                'Position',[0,0,150,PH],...
                'BorderType','etchedin');                
        
            axesPos = [12,3,34,9]; % +2 for height du to top padding
            me.StaticAxesPanel = uipanel(me.StaticPanel,...
                'BorderType','none',...
                'Units','character',...
                'Position',[0,0,50,PH]);
            me.AxesTS = axes('Parent',me.StaticAxesPanel,...
                'Units','character',...
                'Position',axesPos + [0,14,0,0],...
                'UserData',{me,'TS'});
            me.AxesSpectrum = axes('Parent',me.StaticAxesPanel,...
                'Units','character',...
                'Position',axesPos,...
                'UserData',{me,'Spectrum'});
            me.AxesObjects = {me.AxesSpectrum,me.AxesTS,me.AxesEnvelope,me.AxesSpectrogram};
            
            
            % Values panel
            me.StaticValuesPanel = uipanel(me.StaticPanel,...
                'BorderType','none',...
                'Units','character',...
                'Position',[50,0,100,PH]);
            SV = me.StaticValuesPanel;
            p  = 2;
            sw = 20;
            sh = 1;
            vw = 17;
            vh = 1.4;
            b = PH - 2;
            
            % special headers
            b = b - 2;
            s = sprintf('Time\n(sec)');
            pos = [2*p+sw,b,vw,2.2];
            uicontrol(SV,'Style','text','String',s,'Units','character','Position',pos,'HorizontalAlignment','center');

            s = sprintf('Envelope\nValue');
            pos = pos + [p+vw,0,0,0];
            uicontrol(SV,'Style','text','String',s,'Units','character','Position',pos,'HorizontalAlignment','center');
            
            s = sprintf('Frequency\n(Hz)');
            pos = pos + [p+vw,0,0,0];
            uicontrol(SV,'Style','text','String',s,'Units','character','Position',pos,'HorizontalAlignment','center');
            
            s = sprintf('Power\n(dB)');
            pos = pos + [p+vw,0,0,0];
            uicontrol(SV,'Style','text','String',s,'Units','character','Position',pos,'HorizontalAlignment','center');
            
            % start
            b = b - 2;
            s = 'Call Start';
            pos = [p,b+0.5,sw,1];
            uicontrol(SV,'Style','text','String',s,'Units','character','Position',pos,'HorizontalAlignment','left');
            
            s = '';
            pos = [2*p+sw,b+0.3,vw,1.4];
            me.TextValueStartTime = uicontrol(SV,'Style','edit','Enable','inactive','String',s,'Units','character','Position',pos,'HorizontalAlignment','center');
            me.StatsTexts = [me.StatsTexts,{me.TextValueStartTime}];
            
            s = '';
            pos = pos + [p+vw,0,0,0];
            me.TextValueStartValue = uicontrol(SV,'Style','edit','Enable','inactive','String',s,'Units','character','Position',pos,'HorizontalAlignment','center');
            me.StatsTexts = [me.StatsTexts,{me.TextValueStartValue}];
            
            s = '';
            pos = pos + [p+vw,0,0,0];
            me.TextValueStartFreq = uicontrol(SV,'Style','edit','Enable','inactive','String',s,'Units','character','Position',pos,'HorizontalAlignment','center');
            me.StatsTexts = [me.StatsTexts,{me.TextValueStartFreq}];
            
            s = '';
            pos = pos + [p+vw,0,0,0];
            me.TextValueStartPower = uicontrol(SV,'Style','edit','Enable','inactive','String',s,'Units','character','Position',pos,'HorizontalAlignment','center');
            me.StatsTexts = [me.StatsTexts,{me.TextValueStartPower}];
            
            % peak
            b = b - 2;
            s = 'Peak';
            pos = [p,b+0.5,sw,1];
            uicontrol(SV,'Style','text','String',s,'Units','character','Position',pos,'HorizontalAlignment','left');
            
            s = '';
            pos = [2*p+sw,b+0.3,vw,1.4];
            me.TextValuePeakTime = uicontrol(SV,'Style','edit','Enable','inactive','String',s,'Units','character','Position',pos,'HorizontalAlignment','center');
            me.StatsTexts = [me.StatsTexts,{me.TextValuePeakTime}];
            
            s = '';
            pos = pos + [p+vw,0,0,0];
            me.TextValuePeakValue = uicontrol(SV,'Style','edit','Enable','inactive','String',s,'Units','character','Position',pos,'HorizontalAlignment','center');
            me.StatsTexts = [me.StatsTexts,{me.TextValuePeakValue}];
            
            s = '';
            pos = pos + [p+vw,0,0,0];
            me.TextValuePeakFreq = uicontrol(SV,'Style','edit','Enable','inactive','String',s,'Units','character','Position',pos,'HorizontalAlignment','center');
            me.StatsTexts = [me.StatsTexts,{me.TextValuePeakFreq}];
            
            s = '';
            pos = pos + [p+vw,0,0,0];
            me.TextValuePeakPower = uicontrol(SV,'Style','edit','Enable','inactive','String',s,'Units','character','Position',pos,'HorizontalAlignment','center');
            me.StatsTexts = [me.StatsTexts,{me.TextValuePeakPower}];

            % end
            b = b - 2;
            s = 'Call End';
            pos = [p,b+0.5,sw,sh];
            uicontrol(SV,'Style','text','String',s,'Units','character','Position',pos,'HorizontalAlignment','left');
            
            s = '';
            pos = [2*p+sw,b+0.3,vw,vh];
            me.TextValueEndTime = uicontrol(SV,'Style','edit','Enable','inactive','String',s,'Units','character','Position',pos,'HorizontalAlignment','center');
            me.StatsTexts = [me.StatsTexts,{me.TextValueEndTime}];
            
            s = '';
            pos = pos + [p+vw,0,0,0];
            me.TextValueEndValue = uicontrol(SV,'Style','edit','Enable','inactive','String',s,'Units','character','Position',pos,'HorizontalAlignment','center');
            me.StatsTexts = [me.StatsTexts,{me.TextValueEndValue}];
            
            s = '';
            pos = pos + [p+vw,0,0,0];
            me.TextValueEndFreq = uicontrol(SV,'Style','edit','Enable','inactive','String',s,'Units','character','Position',pos,'HorizontalAlignment','center');
            me.StatsTexts = [me.StatsTexts,{me.TextValueEndFreq}];
            
            s = '';
            pos = pos + [p+vw,0,0,0];
            me.TextValueEndPower = uicontrol(SV,'Style','edit','Enable','inactive','String',s,'Units','character','Position',pos,'HorizontalAlignment','center');
            me.StatsTexts = [me.StatsTexts,{me.TextValueEndPower}];
            
            % duration
            b = b - 4;
            s = 'Duration (msec)';
            pos = [p,b+0.5,sw,sh];
            uicontrol(SV,'Style','text','String',s,'Units','character','Position',pos,'HorizontalAlignment','left');
            pos = [2*p+sw,b+0.3,vw,vh];
            me.TextValueDuration = uicontrol(SV,'Style','edit','Enable','inactive','Units','character','Position',pos,'HorizontalAlignment','center');
            me.StatsTexts = [me.StatsTexts,{me.TextValueDuration}];
            
            % IPI
            s = 'IPI (msec)';
            pos = [3*p+sw+vw,b+0.5,sw,sh];
            uicontrol(SV,'Style','text','String',s,'Units','character','Position',pos,'HorizontalAlignment','left');
            pos = [5*p+3*vw+sw,b+0.3,vw,vh];
            me.TextValueIPI = uicontrol(SV,'Style','edit','Enable','inactive','Units','character','Position',pos,'HorizontalAlignment','center');
            me.StatsTexts = [me.StatsTexts,{me.TextValueIPI}];
            
            % bandwidth
            b = b - 2;
            s = 'Bandwidth RMS (Hz)';
            pos = [p,b+0.5,sw,sh];
            uicontrol(SV,'Style','text','String',s,'Units','character','Position',pos,'HorizontalAlignment','left');
            pos = [2*p+sw,b+0.3,vw,vh];
            me.TextValueBandwidth = uicontrol(SV,'Style','edit','Enable','inactive','Units','character','Position',pos,'HorizontalAlignment','center');
            me.StatsTexts = [me.StatsTexts,{me.TextValueBandwidth}];
            
        end
        
        % MENUS
        function buildMenus(me)
            % process
            me.Menus.Process = uimenu(me.Figure,'Label','Process');
            s = me.Menus.Process;
            s2 = uimenu(me.Menus.Process,'Label','Analyze all calls in ...');
            uimenu(s2,'Label','Current channel','Callback',@(~,~)me.do4All('channel'));
            uimenu(s2,'Label','Selected Files','Callback',@(~,~)me.do4All('files'));
            uimenu(me.Menus.Process,'Label','Manually determine call boundaries','Callback',@(~,~)me.manualBoundaries());
            me.MenuFilter = uimenu(s,'Label','Filter','Separator','On');
            me.Application.Methods.callAnalysisFilter.createMenu(me.MenuFilter,me);
            me.MenuEnvelope = uimenu(s,'Label','Envelope');
            me.Application.Methods.callAnalysisEnvelope.createMenu(me.MenuEnvelope,me);
            me.MenuSpectrogram = uimenu(s,'Label','Spectrogram');
            me.Application.Methods.callAnalysisSpectrogram.createMenu(me.MenuSpectrogram,me);
            me.MenuSpectrum = uimenu(s,'Label','Spectrum');
            me.Application.Methods.callAnalysisSpectrum.createMenu(me.MenuSpectrum,me);
            
            % settings
            s = uimenu(me.Figure,'Label','Settings');
            m = uimenu(s,'Label','Work Mode');
            me.DisRelxModeMenuItem  = uimenu(m,'Label','Display - Plot always','Callback',@(~,~)me.setWorkMode('display-relaxed'));
            me.DisHardModeMenuItem  = uimenu(m,'Label','Display - Saved data only','Callback',@(~,~)me.setWorkMode('display-hard'));
            me.ProcModeMenuItem = uimenu(m,'Label','Process','Callback',@(~,~)me.setWorkMode('process'));
            s2 = uimenu(s,'Label','Keep Full Analysis Parameters');
            me.MenuKeepOn  = uimenu(s2,'Label','On','Callback',@(~,~)me.setKeepFullParameters(true),'Checked','on');
            me.MenuKeepOff = uimenu(s2,'Label','Off','Callback',@(~,~)me.setKeepFullParameters(false));

        end
        
        % CONTEXT MENU
        function buildContextMenu(me)
        end
        
        % RESIZE
        function resize(me)
        end
        
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
            S{3} = strcat(['Middle ',S{3}]);
            S{4} = strcat(['High   ',S{4}]);
            S{5} = strcat(['Wide   ',S{5}]);
            n = length(S);
            for i = 6:(n-1)
                S{i} = strcat(['Custom ',S{i}]);
            end
            set(me.ComboSpecRange,'String',S,'Value',I);
        end
        
        %%%%%%%%%%%%%%%%%%
        % PULLS & LEVERS %
        %%%%%%%%%%%%%%%%%%
        
        % WORKMODE
        function setWorkMode(me,mode)
            me.WorkMode = mode;
            switch mode
                case 'display-relaxed'
                    set(me.DisRelxModeMenuItem, 'Checked','on');
                    set(me.DisHardModeMenuItem, 'Checked','off');
                    set(me.DmodePanel,'Visible','on');
                    set(me.ProcModeMenuItem,'Checked','off');
                    set(me.PmodePanel,'Visible','off');
                    cellfun(@(h)set(h,'Enable','off'),me.InteractiveUI);
                    me.filterAndEnvelope();
                    set(me.MessageDisplayRelaxed,'Visible','on');
                    set(me.Menus.Process,'Enable','off');
                case 'display-hard'
                    set(me.DisRelxModeMenuItem, 'Checked','off');
                    set(me.DisHardModeMenuItem, 'Checked','on');
                    set(me.DmodePanel,'Visible','on');
                    set(me.ProcModeMenuItem,'Checked','off');
                    set(me.PmodePanel,'Visible','off');                 
                    cellfun(@(h)set(h,'Enable','off'),me.InteractiveUI);
                    set(me.MessageDisplayRelaxed,'Visible','off');
                    set(me.Menus.Process,'Enable','off');
                case 'process'
                    set(me.DisRelxModeMenuItem, 'Checked','off');
                    set(me.DisHardModeMenuItem, 'Checked','off');
                    set(me.DmodePanel,'Visible','off');
                    set(me.ProcModeMenuItem,'Checked','on');
                    set(me.PmodePanel,'Visible','on');
                    cellfun(@(h)set(h,'Enable','on'),me.InteractiveUI);
                    me.filterAndEnvelope();
                    set(me.MessageDisplayRelaxed,'Visible','off');
                    set(me.Menus.Process,'Enable','on');
            end 
            if ~me.Build
                me.showCall();
            end
        end
        
        % CHANGE DISPLAY TYPE
        function disTypeChange(me,type,group)
            if ~me.Build
                me.showCall();
            end
        end
        
        % ANALYZE BUTTON
        function analyzeCallButton(me)
            me.showCall();
        end
        
        % SAVE BUTTON
        function saveCall(me)
            T = me.getProcCallTypes();
            if isempty(T)
                msgbox('No call types chosen');
            else
                if ~me.Keep
                    me.Call.AnalysisParameters.spectrum = [];
                    me.Call.AnalysisParameters.spectrogram = [];
                    me.Call.AnalysisParameters.envelope = [];
                    me.Call.AnalysisParameters.TS = [];
                end
                cellfun(@(t)me.Call.saveCall(t),T);
            end
        end
        
        % NEXT BUTTON
        function nextCall(me)
            me.changeCall(me.CallIdx+1,true);
        end
        
        % DELETE BUTTON
        function deleteCall(me,inAllChannels)
            if strcmp(inAllChannels,'ask')
                answer = questdlg('Do you want to remove calls in all channels?','Remove Call','Yes','No','Yes');
                if strcmp(answer,'Yes')
                    me.deleteCall(true);
                else
                    me.deleteCall(false);
                end
                return;
            elseif inAllChannels % true
                window = ggetParam('callAnalysisGui_deleteCallWindow');
                A = inputdlg('Window (msec)','Calls removal',[1 70],{num2str(window*1000)});
                if isempty(A)
                    return;
                else
                    window = str2double(A{1})/1000;
                    gsetParam('callAnalysisGui_deleteCallWindow',window);
                end
                timeInterval = me.Call.Detection.Time + window.*[-0.5,+0.5];
                file = me.Application.file(me.FileIdx);
                arrayfun(@(j) file.channel(j).removeCallsByTimeInterval(timeInterval),1:file.ChannelsCount);
            else % false
                me.Application.file(me.FileIdx).channel(me.ChannelIdx).removeCallsByIndex(me.CallIdx);
            end
            me.changeCall(me.CallIdx,true);
            me.Top.Guis.Main.Graphs.replotChannelCalls();
        end
        
        % CALL TYPE - DISPLAY & PROCESS
        function val = get.DisplayType(me)
            if strncmp(me.WorkMode,'display',7)
                UD = get(get(me.DmodeGroup,'SelectedObject'),'UserData');
                val = UD{1};
            else
                val = 'proc';
            end
        end
        function val = get.CallType(me)
            val = me.DisplayType;
            if strcmp(val,'proc')
                V = me.getProcCallTypes();
                if isempty(V)
                    val = [];
                else
                    val = V{1};
                end
            end
        end
        function V = getProcCallTypes(me)
            V = {};
            if get(me.CheckboxFeatures,'Value')
                V = [V,{'features'}];
            end
            if get(me.CheckboxForLocalization,'Value')
                V = [V,{'forLocalization'}];
            end
            if get(me.CheckboxForBeam,'Value')
                V = [V,{'forBeam'}];
            end            
        end
        
        % SET ANALYSIS WINDOW
        function setAnalysisWindow(me,window)
            asetParam('channelCallAnalysis_window',window);
            
            me.plotEnvelope();
            me.plotSpectrogram();
        end
        
        % FILTER CHANGED
        function filterChanged(me)
            if strcmp(me.WorkMode,'process') || strcmp(me.WorkMode,'display-relaxed')
                me.filterAndEnvelope();
            end            
            me.partialRefresh();            
        end
        
        % SPECTROGRAM RANGE PROPERTY
        function specRangeChanged(me,rangeID)
            n = length(get(me.ComboSpecRange,'String'));
            if rangeID == n
                me.Top.Guis.Main.Graphs.addNewSpecRange();
                me.buildSpecRangeCombo(true);
            else
                me.SpecRange = rangeID;
            end
        end
        function set.SpecRange(me,rangeID)
            if isempty(rangeID)
                rangeID = 1;
            end
            set(me.ComboSpecRange,'Value',rangeID);
            me.plotSpectrogram();
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
        
        % CHANGE KEEP
        function setKeepFullParameters(me,keep)
            me.Keep = keep;
            if keep
                set(me.MenuKeepOn,'Checked','on');
                set(me.MenuKeepOff,'Checked','off');
            else
                set(me.MenuKeepOn,'Checked','off');
                set(me.MenuKeepOff,'Checked','on');
            end
        end
        
        %%%%%%%%%%%
        % DATASET %
        %%%%%%%%%%%
        
        % SET DISPLAYED FILES
        function setDisplayedFiles(me,files)
            if isempty(files)
                file = 0;
            else
                file = files(1);
            end
            me.changeFile(file,true);
        end
        
        % CHANGE FILE
        function changeFile(me,fileIdx,cascade)
            
            me.FileIdx = fileIdx;
            
            if fileIdx == 0
                % clear everything
                cellfun(@(h)set(h,'String',''),me.StatsTexts);
                cellfun(@(a)cla(a),me.AxesObjects);
                % disable everything
                cellfun(@(h)set(h,'Enable','off'),me.InteractiveUI);
            else
                cellfun(@(h)set(h,'Enable','on'),me.InteractiveUI);
                % rebuild channels list
                N = me.Application.file(me.FileIdx).ChannelsCount;
                S = mat2cell(num2str((1:N)'),ones(N,1));
                wid = 'MATLAB:hg:uicontrol:ValueMustBeWithinStringRange';
                w = warning('query',wid);
                warning('off',wid);
                set(me.ComboChannel,'String',S);
                warning(w.state,wid);
                if cascade
                    me.changeChannel(me.ChannelIdx,true);
                end
            end
        end
        
        % CHANGE CHANNEL
        function changeChannel(me,channelIdx,cascade)
            N = me.Application.file(me.FileIdx).ChannelsCount;
            if isempty(channelIdx) || N < channelIdx
                me.ChannelIdx = 1;
                set(me.ComboChannel,'Value',me.ChannelIdx);
                msgbox('Channel index out of range. Changed to 1');
            else
                me.ChannelIdx = channelIdx;
                set(me.ComboChannel,'Value',me.ChannelIdx);
            end
            
            
            % filter & envelope
            if strcmp(me.WorkMode,'process') || strcmp(me.WorkMode,'display-relaxed')
                me.filterAndEnvelope();
            end
            
            % calls selector
            channel = me.Application.file(me.FileIdx).channel(me.ChannelIdx);            
            M = channel.CallsCount;
            S = mat2cell(num2str((1:M)'),ones(M,1));
            wid = 'MATLAB:hg:uicontrol:ValueMustBeWithinStringRange';
            w = warning('query',wid);
            warning('off',wid);
            set(me.ComboCall,'String',S);
            warning(w.state,wid);
            if cascade
                me.changeCall(me.CallIdx,true);
            end
            
        end
        
        % CHANGE CALL
        function changeCall(me,callIdx,cascade)
            channel = me.Application.file(me.FileIdx).channel(me.ChannelIdx);            
            if isempty(callIdx)  || callIdx > channel.CallsCount
                me.CallIdx = 1;
                set(me.ComboCall,'Value',me.CallIdx);
                msgbox('Call index out of range. Changed to 1');
            else
                me.CallIdx = callIdx;
                set(me.ComboCall,'Value',me.CallIdx);
            end
            
            
            if cascade
                me.showCall();
            end
        end
        
        % FILTER AND ENVELOPE CHANNEL
        function filterAndEnvelope(me)
            channel = me.Application.file(me.FileIdx).channel(me.ChannelIdx);
            [me.ChannelTimeSeries,me.ChannelTimeVector] = channel.getTS([]);
            Fs = channel.Fs;
            me.ChannelFilteredTS  = me.Application.Methods.callAnalysisFilter.execute(me.ChannelTimeSeries,Fs);
            me.ChannelEnvelopedTS = me.Application.Methods.callAnalysisEnvelope.execute(me.ChannelFilteredTS,Fs);
        end
                 
        %%%%%%%%%%%
        % DISPLAY %
        %%%%%%%%%%%
        
        % SHOW CALL
        function showCall(me,forcedBoundaries)
            if me.FileIdx == 0
                return;
            end
                
            if ~exist('forcedBoundaries','var')
                forcedBoundaries = [];
            end
            
            try
                me.Call = me.Application.file(me.FileIdx).channel(me.ChannelIdx).call(me.CallIdx);
            catch err
                disp(err.message);
                return;
            end
            switch me.WorkMode
                case {'display-relaxed','display-hard'}
                    me.Call.loadCall(me.DisplayType);
                case 'process'
                    me.analyzeCall(forcedBoundaries);
            end
            

            me.partialRefresh();
            me.refreshAnalysisParameters();
            me.showStats();
            me.plotTS();
            me.plotSpectrum();
            
        end    
        
        % PARTIAL REFRESH
        function partialRefresh(me)
            me.plotEnvelope();
            me.plotSpectrogram();
            me.refreshFilterButton();
        end
        
        % PLOT ENVELOPE WITH COLORS
        function plotEnvelope(me)
            if ~strcmp(me.WorkMode,'process') && isfield(me.Call.AnalysisParameters,'envelope') && ~isempty(me.Call.AnalysisParameters.envelope)
                % get the analysis window, envelope dataset and 
                window = me.Call.AnalysisParameters.window;
                I = me.Call.Detection.Time + [-0.5,+0.5].*window;
                E = me.Call.AnalysisParameters.envelope;
                Fs = me.Call.AnalysisParameters.Fs;
            elseif ~strcmp(me.WorkMode,'display-hard')
                % get the analysis window, envelope dataset and 
                Fs = me.Application.file(me.FileIdx).Fs;
                window = agetParam('channelCallAnalysis_window');
                I = me.Call.Detection.Time + [-0.5,+0.5].*window;
                E = getInterval(me.ChannelEnvelopedTS,Fs,I);
%                 E = me.ChannelEnvelopedTS(wip(1):wip(2));
            else
                cla(me.AxesEnvelope);
                return;
            end
            
            % find the realised call start & end points
            np = length(E);
            T = I(1)+linspace(0,np/Fs,np);
            sip = round((me.Call.Start.Time-I(1))*Fs);
            if sip < 1
                sip = 1;
            elseif sip > np
                sip = np;
            end
            eip = round((me.Call.End.Time-I(1))*Fs);
            if eip < 1
                eip = 1;
            elseif eip > np
                eip = np;
            end
            if me.Call.Peak.Time ~= 0
                pip = round((me.Call.Peak.Time-I(1))*Fs);
                if pip < 1
                    pip = 1;
                elseif pip > np
                    pip = np;
                end
            else
                pip = [];
            end
            dip = round((me.Call.Detection.Time-I(1))*Fs);
            if dip < 1
                dip = 1;
            elseif dip > np
                dip = np;
            end
            
            % PLOT
            T1 = T(1:sip);
            E1 = E(1:sip);
            plot(me.AxesEnvelope,T1,E1,'b');
            hold(me.AxesEnvelope,'on');
            T2 = T(sip:eip);
            E2 = E(sip:eip);
            plot(me.AxesEnvelope,T2,E2,'r');
            T3 = T(eip:np);
            E3 = E(eip:np);
            plot(me.AxesEnvelope,T3,E3,'b');
            
            % put detection point + peak
            plot(me.AxesEnvelope,me.Call.Detection.Time,E(dip),'r*');
            if ~isempty(pip)
                plot(me.AxesEnvelope,me.Call.Peak.Time,E(pip),'g*');
            end
            hold(me.AxesEnvelope,'off');
            axis(me.AxesEnvelope,'tight');
            ylabel(me.AxesEnvelope, {'Envelope','Amplitude'});
            xlabel(me.AxesEnvelope,'Time: seconds');                            
            
        end
        
        % PLOT SPECTROGRAM
        function plotSpectrogram(me)
            if ~strcmp(me.WorkMode,'process') && isfield(me.Call.AnalysisParameters,'spectrogram') && ~isempty(me.Call.AnalysisParameters.spectrogram)
                % get the spectrogram 
                S = me.Call.AnalysisParameters.spectrogram;
            elseif ~strcmp(me.WorkMode,'display-hard')
                % get the spectrogram
                Fs = me.Application.file(me.FileIdx).Fs;
                window = agetParam('channelCallAnalysis_window');
                I = me.Call.Detection.Time + [-0.5,+0.5].*window;
                S = me.Application.Methods.callAnalysisSpectrogram.execute(getInterval(me.ChannelFilteredTS,Fs,I),Fs);
                S.T = S.T + I(1);
            else
                cla(me.AxesSpectrogram);
                return;
            end
            
            axes(me.AxesSpectrogram);
            R = me.SpecRange;
            if isempty(R)
                me.SpecImage = imagesc(S.T,S.F,S.P);
%                 set(me.SpecImage,'UIContextMenu',me.Gui.ContextMenu);
            else
                me.SpecImage = imagesc(S.T,S.F,S.P,R);
%                 set(me.SpecImage,'UIContextMenu',me.Gui.ContextMenu);
            end
            set(me.AxesSpectrogram,'YDir','normal');
            hold(me.AxesSpectrogram,'on');
            Y = [min(S.F),max(S.F)];
            startTime = me.Call.Start.Time;
            if startTime > 0
                line([startTime,startTime],Y,'LineWidth',2,'Color','white');
            end
            endTime = me.Call.End.Time;
            if endTime > 0
                line([endTime,endTime],Y,'LineWidth',2,'Color','white');
            end            
            hold(me.AxesSpectrogram,'off');
            ylabel(me.AxesSpectrogram, {'Spectrogram','Frequency: Hz'});
            xlabel(me.AxesSpectrogram,'Time: seconds');                
        end
        
        % PUT STATS
        function showStats(me)
            times = {'Start','Peak','End'};
            types = {'Time','Value','Freq','Power'};
            for i = 1:3
                for j = 1:4
                    propName = strcat('TextValue',times{i},types{j});
                    set(me.(propName),'String',num2str(me.Call.(times{i}).(types{j})));
                    
                end
            end
            
            set(me.TextValueDuration,'String',num2str(me.Call.Duration));
            callType = me.CallType;
            if isempty(callType)
                set(me.TextValueIPI,'String','');
            else
                set(me.TextValueIPI,'String',num2str(me.Call.getIPI(callType)));
            end
        
        end
        
        % REFRESH FILTER BUTTON
        function refreshFilterButton(me)
            switch me.WorkMode
                case 'process'
                    [buttonString,messageString] = me.getFilterSpec();
                case 'display-relaxed'
                    if isfield(me.Call.AnalysisParameters,'filter') && ~isempty(me.Call.AnalysisParameters.filter)
                        buttonString = me.Call.AnalysisParameters.filter.nameString;
                        messageString = me.Call.AnalysisParameters.filter.descString;
                    else
                        [buttonString,messageString] = me.getFilterSpec();
                    end
                case 'display-hard'
                    if isfield(me.Call.AnalysisParameters,'filter') && ~isempty(me.Call.AnalysisParameters.filter)
                        buttonString = me.Call.AnalysisParameters.filter.nameString;
                        messageString = me.Call.AnalysisParameters.filter.descString;                        
                    else
                        buttonString = 'Unknown';
                        messageString = 'Unknown';
                    end
            end
            set(me.ButtonFilter,'String',buttonString,'Callback',@(~,~)msgbox(messageString));
        end
        
        % GET FILTER SPECIFICATIONS
        function [nameString,descString] = getFilterSpec(me)
            methObj = me.Application.Methods.callAnalysisFilter;
            if strcmp(methObj.Default,'none')
                nameString = 'None';
                descString = 'No filter used';
            else
                meth = methObj.getMethod(methObj.Default);
                nameString = meth.name;
                [Q,D] = methObj.buildParamList(meth);
                D = cellfun(@(d) {num2str(d)},D);
                str = strcat(['Filter Method: ',meth.name,'\n']);
                for i = 1:length(Q)
                    str = strcat([str,'\n',Q{i},': ',D{i}]);
                end
                descString = sprintf(str);
            end
        end
        
        % ANALYSIS PARAMETERS
        function refreshAnalysisParameters(me)
            if strcmp(me.WorkMode,'process')
                
                set(me.TextAnalysisWindow,'String',num2str(agetParam('channelCallAnalysis_window')*1000));
                set(me.TextD2P,'String',num2str(agetParam('channelCallAnalysis_d2pWindow')*1000));
                set(me.TextStartThreshold,'String',num2str(agetParam('channelCallAnalysis_startThreshold')));
                set(me.TextEndThreshold,'String',num2str(agetParam('channelCallAnalysis_endThreshold')));
                set(me.TextGapTolerance,'String',num2str(agetParam('channelCallAnalysis_gapTolerance')*1000));                
                
            elseif isfield(me.Call.AnalysisParameters,'startThreshold')
                set(me.TextAnalysisWindow,'String',num2str(me.Call.AnalysisParameters.window*1000));
                set(me.TextD2P,'String',num2str(me.Call.AnalysisParameters.d2pWindow*1000));
                set(me.TextStartThreshold,'String',num2str(me.Call.AnalysisParameters.startThreshold));
                set(me.TextEndThreshold,'String',num2str(me.Call.AnalysisParameters.endThreshold));
                set(me.TextGapTolerance,'String',num2str(me.Call.AnalysisParameters.gapTolerance*1000));
            else
                set(me.TextAnalysisWindow,'String','N/A');
                set(me.TextD2P,'String','N/A');
                set(me.TextStartThreshold,'String','N/A');
                set(me.TextEndThreshold,'String','N/A');
                set(me.TextGapTolerance,'String','N/A');
            end
        end
        
        % PLOT TS
        function plotTS(me)
            if ~strcmp(me.WorkMode,'process') && isfield(me.Call.AnalysisParameters,'TS') && ~isempty(me.Call.AnalysisParameters.TS)
                % get the spectrum data
                TS = me.Call.AnalysisParameters.TS;
                T = linspace(me.Call.Start.Time,me.Call.End.Time,length(TS));
            elseif ~strcmp(me.WorkMode,'display-hard')
                % get the spectrogram
                Fs = me.Application.file(me.FileIdx).Fs;
                I = [me.Call.Start.Time , me.Call.End.Time];
                TS = getInterval(me.ChannelFilteredTS,Fs,I);
                T = linspace(I(1),I(2),length(TS));
            else
                cla(me.AxesTS);
                return;
            end
            
            plot(me.AxesTS,T,TS);
            ylabel(me.AxesTS, {'Time Signal','Amplitude'});
            xlabel(me.AxesTS, 'Time: sec');  
            axis(me.AxesTS,'tight');            
        end
        
        % PLOT SPECTRUM
        function plotSpectrum(me)
            if ~strcmp(me.WorkMode,'process') && isfield(me.Call.AnalysisParameters,'spectrum') && ~isempty(me.Call.AnalysisParameters.spectrum)
                % get the spectrum data
                S = me.Call.AnalysisParameters.spectrum;
            elseif ~strcmp(me.WorkMode,'display-hard')
                % get the spectrogram
                Fs = me.Application.file(me.FileIdx).Fs;
                window = agetParam('channelCallAnalysis_window');
                I = me.Call.Detection.Time + [-0.5,+0.5].*window;
                S = me.Application.Methods.callAnalysisSpectrum.execute(getInterval(me.ChannelFilteredTS,Fs,I),Fs);
            else
                cla(me.AxesSpectrum);
                return;
            end
            me.SpectrumImage = plot(me.AxesSpectrum,S.F,S.P);
            ylabel(me.AxesSpectrum, {'Spectrum','Gain: dB'});
            xlabel(me.AxesSpectrum, 'Frequency: Hz');  
            axis(me.AxesSpectrum,'tight');
        end
        
        %%%%%%%%%%%%
        % ANALYSIS %
        %%%%%%%%%%%%
        
        % ANALYZE CALL
        function analyzeCall(me,forcedBoundaries)
            
            %{
            call = channelCallAnalyze( call,...
                window,...
                dataset,...
                envDataset,...
                detectionPeakWindow,...
                startThreshold,...
                endThreshold,...
                gapTolerance,...
                forcedBoundries,...
                computeSpectral,...
                computeRidge )
            %}
            
            window = agetParam('channelCallAnalysis_window');
            I = me.Call.Detection.Time + window.*[-0.5,+0.5];
            dataset = getInterval(me.ChannelFilteredTS, me.Call.Fs,I);
            envDataset = getInterval(me.ChannelEnvelopedTS, me.Call.Fs,I);
                        
            me.Call = channelCallAnalyze( me.Call,...
                window,...
                dataset,...
                envDataset,...
                agetParam('channelCallAnalysis_d2pWindow'),...
                agetParam('channelCallAnalysis_startThreshold'),...
                agetParam('channelCallAnalysis_endThreshold'),...
                agetParam('channelCallAnalysis_gapTolerance'),...
                forcedBoundaries,...
                true,...
                false );
            
            me.Call.AnalysisParameters.filter = [];
            [f.nameString,f.descString] = me.getFilterSpec();
            me.Call.AnalysisParameters.filter = f;
            
        end
        
        % DO FOR ALL
        function do4All(me,type)

            types = me.getProcCallTypes();
            if isempty(types)
                msgbox('No call types chosen');
                return;
            end
            
            params.analysisWindow = agetParam('channelCallAnalysis_window');
            params.d2pWindow = agetParam('channelCallAnalysis_d2pWindow');
            params.startThreshold = agetParam('channelCallAnalysis_startThreshold');
            params.endThreshold = agetParam('channelCallAnalysis_endThreshold');
            params.gapTolerance = agetParam('channelCallAnalysis_gapTolerance');
            params.computeSpectral = true;
            params.computeRidge = false;
            [f.nameString,f.descString] = me.getFilterSpec();
            params.filterSpecification = f;
            params.keep = me.Keep;
            
            switch type
                case 'channel'
                    channelCallsAnalyzeChannel(me.Application.file(me.FileIdx),...
                        me.ChannelIdx,...
                        types,...
                        params );                           
                case 'files'
                    channelCallsAnalyze( me.Application,...
                        me.ProcessVector,...
                        [],...
                        types,...
                        params );                   
            end
            
            me.showCall();
            msgbox('Analysis finished');
            
        end
        
       
        % MANUAL BOUNDARIES
        function manualBoundaries(me)

            % rubberand selection
            r = getrect(me.AxesSpectrogram);
            me.showCall([r(1),r(1)+r(3)]);

            % approximate start threshold
            s = me.Call.Start.Value / me.Call.Peak.Value;
            dB = 20*log10(s);
            set(me.TextStartThreshold,'String',num2str(dB));
            asetParam('channelCallAnalysis_startThreshold',dB);

            % approximate end threshold
            e = me.Call.Start.Value / me.Call.Peak.Value;
            dB = 20*log10(e);
            set(me.TextEndThreshold,'String',num2str(dB));
            asetParam('channelCallAnalysis_endThreshold',dB);

            % the gap is undetermined. consider future dev.
        end
                
    end
    
end

