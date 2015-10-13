 classdef bCallGui < bGuiDefinition & hgsetget
   %BCALLGUI Channel call analysis
    
   properties % GENERAL
       WorkMode
       Call % a bChanelCall object
       FileIdx
       ChannelIdx
       CallIdx
       CallType
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
            TextValueStartEnv
            TextValueStartTime
            TextValueStartFreq
            TextValueStartPower
            TextValuePeakEnv
            TextValuePeakTime
            TextValuePeakFreq
            TextValuePeakPower
            TextValueEndEnv
            TextValueEndTime
            TextValueEndFreq
            TextValueEndPower
            TextValueDuration
            TextValueIPI
            TextValueBandwidth
            
        DisModeMenuItem
        ProcModeMenuItem
        MenuFilter
        MenuEnvelope
        MenuSpectrogram
        MenuSpectrum
        
        
    end
    
    properties (Constant = true)
        TopPanelMinSize    = [150,4.3];
        ActivePanelMinSize = [150,28];
        StaticPanelMinSize = [150,28];
    end
    
    properties (Dependent = true)
        DisplayType
    end
    
    methods
        
        % CONSTRUCTOR
        function me = bCallGui(guiTop)
            me = me@bGuiDefinition(guiTop);
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
            me.setWorkMode('display');
            set(me,'Visible','on');
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
            me.DmodePanel = uipanel(me.SelectionRibbon.Panel,'Units','character','Position',modePanelsPosition,'Visible','off');
                me.DmodeGroup = uibuttongroup('Parent',me.DmodePanel,'Units','normalized','Position',[0,0,1,1],'SelectionChangedFcn',@(h,~)me.disTypeChange(get(get(h,'SelectedObject'),'UserData'),h));
                s = uicontrol(me.DmodeGroup,'Style','radiobutton','Units','normalized','Position',[0,0.666,1,0.333],'String','Features','UserData','features');
                uicontrol(me.DmodeGroup,'Style','radiobutton','Units','normalized','Position',[0,0.333,1,0.333],'String','Localization','UserData','forLocalization');
                uicontrol(me.DmodeGroup,'Style','radiobutton','Units','normalized','Position',[0,0.001,1,0.333],'String','Beam','UserData','forBeam');
                set(me.DmodeGroup,'SelectedObject',s);
                
            me.PmodePanel = uipanel(me.SelectionRibbon.Panel,'Units','character','Position',modePanelsPosition,'Visible','off');
                me.CheckboxFeatures        = uicontrol(me.PmodePanel,'Style','checkbox','Units','normalized','Position',[0,0.333,1,0.333],'String','Features');
                me.CheckboxForLocalization = uicontrol(me.PmodePanel,'Style','checkbox','Units','normalized','Position',[0,0.666,1,0.333],'String','Localization');
                me.CheckboxForBeam         = uicontrol(me.PmodePanel,'Style','checkbox','Units','normalized','Position',[0,0.001,1,0.333],'String','Beam');
                
            % channel / call selectors
            me.IndexPanel = uipanel(me.SelectionRibbon.Panel,'Units','character','Position',[pos(3)-20-20,0,20,pos(4)]);
                uicontrol(me.IndexPanel,'Style','text','String','Channel:','HorizontalAlignment','right','Units','character','Position',[0,2.6,10,1]);
                me.ComboChannel = uicontrol(me.IndexPanel,'Style','popupmenu','String','foo','Value',1,'Units','character','Position',[12,2.4,6,1.4]);
                uicontrol(me.IndexPanel,'Style','text','String','Call:','HorizontalAlignment','right','Units','character','Position',[0,0.7,10,1]);
                me.ComboCall = uicontrol(me.IndexPanel,'Style','popupmenu','String','foo','Value',1,'Units','character','Position',[12,0.5,6,1.4]);
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
            
            axesPos = [6,3,40,9]; % +2 for height du to top padding
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
            me.TextAnalysisWindow = uicontrol(AP,'Style','edit','Units','character','Position',[sw+sp,b+0.3,vw,1.4],'String',v);
            
            s = 'Detection to Peak window (msec):';
            b = b - 2;
            v = num2str(agetParam('channelCallAnalysis_d2pWindow')*1000);
            uicontrol(AP,'Style','text','Units','character','Position',[sp,b+0.5,sw,1],'HorizontalAlignment','left','String',s);
            me.TextD2P = uicontrol(AP,'Style','edit','Units','character','Position',[sw+sp,b+0.3,vw,1.4],'String',v);
            
            s = 'Filter (click for details):';
            b = b - 2;
            uicontrol(AP,'Style','text','Units','character','Position',[sp,b+0.5,sw,1],'HorizontalAlignment','left','String',s);
            me.ButtonFilter = uicontrol(AP,'Style','pushbutton','Units','character','Position',[sw+sp,b+0.3,vw,1.4],'String','foo','Callback',@(~,~)me.showFilterDetails());
 
            s = 'Call start threshold (dB):';
            b = b - 2;
            v = num2str(agetParam('channelCallAnalysis_startThreshold'));
            uicontrol(AP,'Style','text','Units','character','Position',[sp,b+0.5,sw,1],'HorizontalAlignment','left','String',s);
            me.TextStartThreshold = uicontrol(AP,'Style','edit','Units','character','Position',[sw+sp,b+0.3,vw,1.4],'String',v);
            
            s = 'Call end threshold (dB):';
            b = b - 2;
            v = num2str(agetParam('channelCallAnalysis_endThreshold'));
            uicontrol(AP,'Style','text','Units','character','Position',[sp,b+0.5,sw,1],'HorizontalAlignment','left','String',s);
            me.TextEndThreshold = uicontrol(AP,'Style','edit','Units','character','Position',[sw+sp,b+0.3,vw,1.4],'String',v);            
            
            s = 'Gap tolerance (msec):';
            b = b - 2;
            v = num2str(agetParam('channelCallAnalysis_gapTolerance')*1000);
            uicontrol(AP,'Style','text','Units','character','Position',[sp,b+0.5,sw,1],'HorizontalAlignment','left','String',s);
            me.TextGapTolerance = uicontrol(AP,'Style','edit','Units','character','Position',[sw+sp,b+0.3,vw,1.4],'String',v);            
            
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
            me.ButtonAnalyze = uicontrol(AB,'Style','pushbutton','Units','character','Position',[p,b,w,h],'String',s,'Callback',@(~,~)me.analyzeCall());
            
            s = 'Save';
            b = b - 2;
            me.ButtonSave = uicontrol(AB,'Style','pushbutton','Units','character','Position',[p,b,w,h],'String',s,'Callback',@(~,~)me.saveCall());
            
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
        
            axesPos = [6,3,40,9]; % +2 for height du to top padding
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
            
            % Values panel
            me.StaticValuesPanel = uipanel(me.StaticPanel,...
                'BorderType','none',...
                'Units','character',...
                'Position',[50,0,100,PH]);
            SV = me.StaticValuesPanel;
            p  = 2;
            sw = 20;
            sh = 1;
            vw = 13;
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
            
            s = '';
            pos = pos + [p+vw,0,0,0];
            me.TextValueStartEnv = uicontrol(SV,'Style','edit','Enable','inactive','String',s,'Units','character','Position',pos,'HorizontalAlignment','center');
            
            s = '';
            pos = pos + [p+vw,0,0,0];
            me.TextValueStartFreq = uicontrol(SV,'Style','edit','Enable','inactive','String',s,'Units','character','Position',pos,'HorizontalAlignment','center');
            
            s = '';
            pos = pos + [p+vw,0,0,0];
            me.TextValueStartPower = uicontrol(SV,'Style','edit','Enable','inactive','String',s,'Units','character','Position',pos,'HorizontalAlignment','center');
            
            % peak
            b = b - 2;
            s = 'Peak';
            pos = [p,b+0.5,sw,1];
            uicontrol(SV,'Style','text','String',s,'Units','character','Position',pos,'HorizontalAlignment','left');
            
            s = '';
            pos = [2*p+sw,b+0.3,vw,1.4];
            me.TextValuePeakTime = uicontrol(SV,'Style','edit','Enable','inactive','String',s,'Units','character','Position',pos,'HorizontalAlignment','center');
            
            s = '';
            pos = pos + [p+vw,0,0,0];
            me.TextValuePeakEnv = uicontrol(SV,'Style','edit','Enable','inactive','String',s,'Units','character','Position',pos,'HorizontalAlignment','center');
            
            s = '';
            pos = pos + [p+vw,0,0,0];
            me.TextValuePeakFreq = uicontrol(SV,'Style','edit','Enable','inactive','String',s,'Units','character','Position',pos,'HorizontalAlignment','center');
            
            s = '';
            pos = pos + [p+vw,0,0,0];
            me.TextValuePeakPower = uicontrol(SV,'Style','edit','Enable','inactive','String',s,'Units','character','Position',pos,'HorizontalAlignment','center');

            % end
            b = b - 2;
            s = 'Call End';
            pos = [p,b+0.5,sw,sh];
            uicontrol(SV,'Style','text','String',s,'Units','character','Position',pos,'HorizontalAlignment','left');
            
            s = '';
            pos = [2*p+sw,b+0.3,vw,vh];
            me.TextValueEndTime = uicontrol(SV,'Style','edit','Enable','inactive','String',s,'Units','character','Position',pos,'HorizontalAlignment','center');
            
            s = '';
            pos = pos + [p+vw,0,0,0];
            me.TextValueEndEnv = uicontrol(SV,'Style','edit','Enable','inactive','String',s,'Units','character','Position',pos,'HorizontalAlignment','center');
            
            s = '';
            pos = pos + [p+vw,0,0,0];
            me.TextValueEndFreq = uicontrol(SV,'Style','edit','Enable','inactive','String',s,'Units','character','Position',pos,'HorizontalAlignment','center');
            
            s = '';
            pos = pos + [p+vw,0,0,0];
            me.TextValueEndPower = uicontrol(SV,'Style','edit','Enable','inactive','String',s,'Units','character','Position',pos,'HorizontalAlignment','center');

            % duration
            b = b - 4;
            s = 'Duration (msec)';
            pos = [p,b+0.5,sw,sh];
            uicontrol(SV,'Style','text','String',s,'Units','character','Position',pos,'HorizontalAlignment','left');
            pos = [2*p+sw,b+0.3,vw,vh];
            me.TextValueDuration = uicontrol(SV,'Style','edit','Enable','inactive','Units','character','Position',pos,'HorizontalAlignment','center');
            
            % IPI
            s = 'IPI (msec)';
            pos = [3*p+sw+vw,b+0.5,sw,sh];
            uicontrol(SV,'Style','text','String',s,'Units','character','Position',pos,'HorizontalAlignment','left');
            pos = [5*p+3*vw+sw,b+0.3,vw,vh];
            me.TextValueIPI = uicontrol(SV,'Style','edit','Enable','inactive','Units','character','Position',pos,'HorizontalAlignment','center');
            
            % bandwidth
            b = b - 2;
            s = 'Bandwidth RMS (Hz)';
            pos = [p,b+0.5,sw,sh];
            uicontrol(SV,'Style','text','String',s,'Units','character','Position',pos,'HorizontalAlignment','left');
            pos = [2*p+sw,b+0.3,vw,vh];
            me.TextValueBandwidth = uicontrol(SV,'Style','edit','Enable','inactive','Units','character','Position',pos,'HorizontalAlignment','center');
            
        end
        
        % MENUS
        function buildMenus(me)
            % settings
            s = uimenu(me.Figure,'Label','Settings');
            m = uimenu(s,'Label','Work Mode');
            me.DisModeMenuItem  = uimenu(m,'Label','Display','Callback',@(~,~)me.setWorkMode('display'));
            me.ProcModeMenuItem = uimenu(m,'Label','Process','Callback',@(~,~)me.setWorkMode('process'));
            me.MenuFilter = uimenu(s,'Label','Filter');
            me.Application.Methods.callAnalysisFilter.createMenu(me.MenuFilter,me);
            me.MenuEnvelope = uimenu(s,'Label','Envelope');
            me.Application.Methods.callAnalysisEnvelope.createMenu(me.MenuEnvelope,me);
            me.MenuSpectrogram = uimenu(s,'Label','Spectrogram');
            me.Application.Methods.callAnalysisSpectrogram.createMenu(me.MenuSpectrogram,me);
            me.MenuSpectrum = uimenu(s,'Label','Spectrum');
            me.Application.Methods.callAnalysisSpectrum.createMenu(me.MenuSpectrum,me);
        end
        
        % CONTEXT MENU
        function buildContextMenu(me)
        end
        
        % RESIZE
        function resize(me)
        end
        
        %%%%%%%%%%%%%%%%%%
        % PULLS & LEVERS %
        %%%%%%%%%%%%%%%%%%
        
        % WORKMODE
        function setWorkMode(me,mode)
            me.WorkMode = mode;
            switch mode
                case 'display'
                    set(me.DisModeMenuItem, 'Checked','on');
                    set(me.DmodePanel,'Visible','on');
                    set(me.ProcModeMenuItem,'Checked','off');
                    set(me.PmodePanel,'Visible','off');
                case 'process'
                    set(me.DisModeMenuItem, 'Checked','off');
                    set(me.DmodePanel,'Visible','off');
                    set(me.ProcModeMenuItem,'Checked','on');
                    set(me.PmodePanel,'Visible','on');
            end 
        end
        
        % CHANGE DISPLAY TYPE
        function disTypeChange(me,type,group)
        end
        
        % SHOW FILTER DETAILS
        function showFilterDetails(me)
        end
        
        % ANALYZE BUTTON
        function analyzeCall(me)
        end
        
        % SAVE BUTTON
        function saveCall(me)
        end
        
        % NEXT BUTTON
        function nextCall(me)
        end
        
        % DELETE BUTTON
        function deleteCall(me,inAllChannels)
            if strcmp(inAllChannels,'ask')
            elseif inAllChannels % true
            else % false
            end
        end
        
        % DISPLAY TYPE PROPERTY
        function val = get.DisplayType(me)
            if strcmp(me.WorkMode,'display')
                val = get(get(me.DmodeGroup,'SelectedObject'),'String');
            else
                val = 'proc';
            end
        end
        
        %%%%%%%%%%%
        % DATASET %
        %%%%%%%%%%%
        
        % SHOW CALL
        function showCall(me,k,j,s,t)
        end
        
        % DISPLAY CALL
        function display(me)
        end
        
        
        % SET DISPLAYED FILES
        function setDisplayedFiles(me,files)
            if isempty(files)
                me.FileIdx = 0;
            else
                me.FileIdx = files(1);
            end
        end
        
        
    end
    
end

