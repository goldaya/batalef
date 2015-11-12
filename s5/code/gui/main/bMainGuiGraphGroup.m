classdef bMainGuiGraphGroup < handle
    %BMAINGUIGRAPHGROUP main gui object that holds and handle the gui
    %graphs
    
    properties
        DisplayType   = 1;
        DisplayWindow = 0;
        Graphs = {};
        Slider = NaN;
        Panel  = NaN;
        FilesVectorInner = [];
        
        % switches
        Link
        LinkTime
        LinkYlim
        LinkDisplayType
        Gui
    end
    
    properties (Dependent = true)
        GuiTop
        ParentUI
        Count
        ChannelsCount
        ChannelsMatrix
        ZeroIndex
        FilesVector
        MinHeight
        MinWidth
        Linked
    end
    
    properties (Constant = true, Access = private)
        minGraphHeight = 18;
        minGraphWidth  = 50;
    end
    
    methods
        
        % CONSTRUCTOR
        function me = bMainGuiGraphGroup(gui,displayType,displayWindow)
            me.Gui           = gui;
            me.DisplayType   = displayType;
            me.DisplayWindow = displayWindow;
        end
        
        % BUILD DISPLAY
        function buildDisplay(me,n,position) % position should be in chars
            me.Panel  = uipanel(me.ParentUI);
            me.Slider = uicontrol(me.ParentUI,'Style','slider','Callback',@(~,~)me.sliderMove(),'Max',1,'Min',0);
            me.resize(position);
            me.addGraph(n);
            me.refreshDisplay();
        end
        
        % REFRESH DISPLAY
        function refreshDisplay(me)
            me.repositionGraphs();
            me.resetSlider();
            me.setChannels();            
        end
        
        % RESIZE
        function resize(me,position) % position should be in chars
            if position(3) < me.MinWidth || position(4) < me.MinHeight
                fprintf('Graphs area too small\n')
                fprintf('current: %.2f X %.2f characters\n',position(3),position(4));
                fprintf('minimum: %.2f X %.2f characters\n',me.MinWidth,me.MinHeight);
                fprintf('Please increase the gui size or reduce number of graphs\n');
                return;
            end
            set(me.Panel, 'Units','character','Position',[0,0,position(3)-3,position(4)]);
            set(me.Slider,'Units','character','Position',[position(3)-3,0,3,position(4)]);
            me.repositionGraphs();
        end
        
        % ADD GRAPH
        function addGraph(me,n)
            for i = 1:n
                newGraph = bMainGuiGraph(me,me.Panel,me.DisplayType,me.DisplayWindow);
                newGraph.Idx = me.Count + 1;
                newGraph.buildPanels(100,30);
                me.Graphs{me.Count + 1} = newGraph;
            end
        end
        
        % REMOVE GRAPH
        function removeGraph(me,n)
            for i = 1:n
                me.Graphs{me.Count}.kill();
                me.Graphs(me.Count) = [];
            end
        end
        
        % REPOSITION
        function repositionGraphs(me)
            N = me.Count;
            if N > 0
                d = 1/N;
            else
                d = 0;
            end
            for i = 1:N
                set(me.Graphs{i}.BasePanel,'Units','normalized','Position',[0,(N-i)*d,1,d]);
%                 set(me.Graphs{i}.BasePanel,'Units','character');
            end
        end
        
        % MINIMUM HEIGHT/WIDTH (GET ONLY)
        function val = get.MinHeight(me)
            val = me.Count * me.minGraphHeight;
        end
        function val = get.MinWidth(me)
            val = me.minGraphWidth;
        end
        
        % SET CHANNELS
        function setChannels(me)
            M  = me.ChannelsMatrix;
            nM = size(M,1);
            for i = 1:me.Count
                idx = me.ZeroIndex + i - 1;
                if idx > nM
                    me.Graphs{i}.clear();
                else
                    me.Graphs{i}.setFileChannel(M(idx,1),M(idx,2));
                end
            end
        end
        
        % PLOT
        function plot(me)
            cellfun(@(g) g.plot(),me.Graphs);
        end
        
        % REPLOT CHANNEL CALLS
        function replotChannelCalls(me)
            cellfun(@(g) g.plotChannelCalls(g.AxesTS,'ccTS','ccTxtTS',true),me.Graphs);
            cellfun(@(g) g.plotChannelCalls(g.AxesSpec,'ccSpec','ccTxtSpec',false),me.Graphs);
        end
        
        % REPLOT POI
        function replotPoi(me)
            cellfun(@(g) g.plotPoi(g.AxesTS,'poiTS','poiTxtTS'),me.Graphs);
            cellfun(@(g) g.plotPoi(g.AxesSpec,'poiSpec','poiTxtSpec'),me.Graphs);
                
                            
        end
        
        % COUNT PROPERTY (GET ONLY)
        function val = get.Count(me)
            val = length(me.Graphs);
        end
        
        % CHANNELS COUNT PROPERTY (GET ONLY)
        function val = get.ChannelsCount(me)
            val = 0;
            for i = 1:length(me.FilesVector)
                val = val + fileData(me.FilesVector(i),'Channels','Count');
            end
        end
        
        % CHANNELS MATRIX PROPERTY (GET ONLY)
        function val = get.ChannelsMatrix(me)
            N = me.ChannelsCount;
            val = zeros(N,2);
            a = 0;
            for i = 1:length(me.FilesVector)
                k = me.FilesVector(i);
                n = fileData(k,'Channels','Count');
                M = [ones(n,1).*k,transpose(1:n)];
                val(a+1:a+n,1:2) = M;
                a = a + n;                
            end
        end
        
        % ZERO INDEX PROPERTY (GET ONLY)
        function val = get.ZeroIndex(me)
            v = get(me.Slider,'Value');
            M = get(me.Slider,'Max');
            val = round(M - v + 1);
        end
        
        % FILES VECTOR PROPERTY (GET/SET)
        function val = get.FilesVector(me)
            val = me.FilesVectorInner;
        end
        function set.FilesVector(me,val)
            me.FilesVectorInner = val;
            if isempty(val) || val(1) == 0
                me.clear();
            else
                me.resetSlider();
                me.setChannels();
            end
        end
        
        % CLEAR 
        function clear(me)
            cellfun(@(g)g.clear(),me.Graphs);
        end

        % RESET SLIDER
        function resetSlider(me)
            N = max(me.ChannelsCount - me.Count,0);
            z = me.ZeroIndex;
            ss2 = min(1,1/me.Count);
            ss1 = min([1,1/N,ss2]);
            set(me.Slider,'SliderStep',[ss1,ss2]);
            set(me.Slider,'Value',round(max(0,N-z+1)));
            set(me.Slider,'Max',max(N,0.01));
        end
        
        % SLIDER MOVE
        function sliderMove(me)
            set(me.Slider,'Value',round(get(me.Slider,'Value')));
            me.setChannels();
        end
        
        % MOUSE MOTION
        function mouseMotion(me,x) % x should be in pixels
            cellfun(@(g) g.mouseMotion(x),me.Graphs);
        end
        
        % SHOW MOUSE MARKS ON GROUP
        function showMouseMarks(me,t)
            cellfun(@(g) g.showMouseMarks(t),me.Graphs);
        end
        
        % LINK AXES
        function linkAxes(me,link)
            for i = 1:me.Count
                tsGroup(i)   = me.Graphs{i}.AxesTS; %#ok<AGROW>
                specGroup(i) = me.Graphs{i}.AxesSpec; %#ok<AGROW>
            end
            if link
                linkaxes(tsGroup);
                linkaxes(specGroup);
            else
                linkaxes(tsGroup,'off');
                linkaxes(specGroup,'off');
            end
            me.Link = link;
            me.changeDisplayType(me.Graphs{1}.DisplayType,[]);
            me.changeDisplayWindow(me.Graphs{1}.DisplayWindow,[])
            me.changeStartTime(me.Graphs{1}.DisplayStartTime,[])
            me.changeSpecRange(me.Graphs{1}.SpecRange,[]);
        end
        function val = get.Linked(me)
            val = me.Link;
        end
        
        % CHANGE DISPLAY TYPE FOR ALL GRAPHS
        function changeDisplayType(me,displayType,exempt) %#ok<INUSD>
            cellfun(@(g) g.setDisplayType(displayType),me.Graphs);
        end
        
        % CHANGE TIME WINDOW FOR ALL GRAPHS
        function changeDisplayWindow(me,displayWindow,exempt) %#ok<INUSD>
            cellfun(@(g) g.setDisplayWindow(displayWindow),me.Graphs);
        end
        
        % CHANGE START TIME FOR ALL GRAPHS
        function changeStartTime(me,startTime,exempt) %#ok<INUSD>
            cellfun(@(g) g.showFromTime(startTime),me.Graphs);
        end
        
        % CHANGE SPECTRO RANGE
        function changeSpecRange(me,rangeID,exempt) %#ok<INUSD>
            cellfun(@(g) set(g,'SpecRange',rangeID),me.Graphs);
        end
       
        % ADD SPECTRO RANGE
        function addNewSpecRange(me)
            Q{1}  = 'Specify range as dB vector: [min max]';
            title = 'Add Custom Spectrogram Range';
            A = inputdlg(Q,title);
            if isempty(A)
            else
                % check new value is ok
                try
                    V = str2num(A{1}); %#ok<ST2NM>
                    if V(1) > V(2)
                        msgbox('Error: First value higher then second value');
                    elseif length(V) > 2
                        msgbox('Error: Vector cannot be longer than 2 scalars');
                    else
                        R = ggetParam('displaySpectrogram_ranges');
                        R = [R,V];
                        gsetParam('displaySpectrogram_ranges',R);
                        cellfun(@(g) g.buildSpecRangeCombo(true),me.Graphs);
                    end
                    
                catch err
                    msgbox(err.message);
                    return;
                end
            end
        end
        
        % GUI TOP
        function val = get.GuiTop(me)
            val = me.Gui.Top;
        end
        
        % PARENT UI
        function val = get.ParentUI(me)
            val = me.Gui.Figure;
        end
        
    end
    
end

