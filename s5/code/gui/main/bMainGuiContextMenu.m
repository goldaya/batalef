classdef bMainGuiContextMenu
    %BMAINGUICONTEXTMENU Object for creating and handling main gui axes
    %context menu
    
    properties
        Gui
        UIObject
    end
    
    properties (Dependent = true)
        Application
    end
    
    methods (Access = public)
        
        % CONSTRUCTOR
        function me = bMainGuiContextMenu(mainGui)
            me.Gui= mainGui;
            
            me.UIObject = uicontextmenu(me.Gui.Figure);
            uimenu(me.UIObject,'Label','Measure Time Diff.','Callback',@(~,~)me.measureTime);
            uimenu(me.UIObject,'Label','Zoom in','Callback',@(~,~)me.zoomIn());
            pois = uimenu(me.UIObject,'Label','POIs');
            uimenu(pois,'Label','Add','Callback',@(~,~)me.addPoiHere());
            uimenu(pois,'Label','Remove','Callback',@(~,~)me.removePois(false));
            uimenu(pois,'Label','Remove in all channels','Callback',@(~,~)me.removePois(true));
            cc = uimenu(me.UIObject,'Label','Channel Calls');
            uimenu(cc,'Label','Add detection here','Callback',@(~,~)me.addChannelCallHere());
            uimenu(cc,'Label','Remove','Callback',@(~,~)me.removeChannelCalls(false));
            uimenu(cc,'Label','Remove in all channels','Callback',@(~,~)me.removeChannelCalls(true));
            uimenu(cc,'Label','Show call info','Callback',@(~,~)me.callAnalysisGui());              
        end
        
    end
    
    methods
       
        % MEASURE TIME
        function measureTime(me)
            r = getrect(me.Gui.LastAxesObject);
            msgbox(sprintf('Time difference:\n%.3e sec',r(3)));            
        end
        
        % ZOOM IN
        function zoomIn(me)
            r = getrect(me.Gui.LastAxesObject);
            me.Gui.LastGraphObject.displayWindowChanged(r(3));
            me.Gui.LastGraphObject.startTimeChanged(r(1));
        end
        
        % APPLICATION
        function app = get.Application(me)
            app = me.Gui.Application;
        end
        
        %%%%%%%%
        % POIS %
        %%%%%%%%
        
        % ADD
        function addPoiHere(me)
            A = inputdlg('Point of Interest text:');
            if ~isempty(A)
                pos = me.Gui.LastGraphObject.LastPointerPosition;
                C = {pos(1),A{1},pos(2),pos(3)};
                k = me.Gui.LastGraphObject.FileIdx;
                j = me.Gui.LastGraphObject.ChannelIdx;
                addPois(k,j,C);
                axobj = me.Gui.LastAxesObject;
                UD = get(axobj,'UserData');
                poiMarks = strcat('poi',UD{2});
                poiTexts = strcat('poiTxt',UD{2});
                me.Gui.LastGraphObject.plotPoi(axobj,poiMarks,poiTexts);
            end
        end
        
        % REMOVE
        function removePois(me,inAllChannels)
            axes(me.Gui.LastAxesObject);
            r = getrect(me.Gui.LastAxesObject);
            k = me.Gui.LastGraphObject.FileIdx;
            if inAllChannels
                J = fileData(k,'Channels','Count');
                for j = 1:J
                    removePoi(k,j,'BetweenTimes',[r(1),r(1)+r(3)]);
                end
                me.Gui.Graphs.plot();
            else
                j = me.Gui.LastGraphObject.ChannelIdx;
                removePoi(k,j,'BetweenTimes',[r(1),r(1)+r(3)]);
                me.Gui.LastGraphObject.plot();
            end
            
        end
        
        %%%%%%%%%%%%%%%%%
        % CHANNEL CALLS %
        %%%%%%%%%%%%%%%%%
        
        % ADD HERE
        function addChannelCallHere(me)
            pos = me.Gui.LastGraphObject.LastPointerPosition;
            D = [pos(1),pos(2)];
            k = me.Gui.LastGraphObject.FileIdx;
            j = me.Gui.LastGraphObject.ChannelIdx;
            me.Application.file(k).channel(j).addCallDetections(D);
            me.Gui.Graphs.replotChannelCalls();

        end
        
        % REMOVE
        function removeChannelCalls(me,inAllChannels)
            axes(me.Gui.LastAxesObject);
            r = getrect(me.Gui.LastAxesObject);
            k = me.Gui.LastGraphObject.FileIdx;
            f = me.Application.file(k);
            if inAllChannels
                J = f.ChannelsCount;
                arrayfun(@(j) f.channel(j).removeCallsByTimeInterval([r(1),r(1)+r(3)]),1:J);
            else
                j = me.Gui.LastGraphObject.ChannelIdx;
                f.channel(j).removeCallsByTimeInterval([r(1),r(1)+r(3)]);
            end            
            me.Gui.Graphs.replotChannelCalls();
        end
        
        % GOTO CALL ANALYSIS GUI
        function callAnalysisGui(me)
            axes(me.Gui.LastAxesObject);
            r = getrect(me.Gui.LastAxesObject);            
            k = me.Gui.LastGraphObject.FileIdx;
            j = me.Gui.LastGraphObject.ChannelIdx;
            c = me.Application.file(k).channel(j);
            I = c.getCalls('Index','TimeInterval',[r(1),r(1)+r(3)]);
            if ~isempty(I)
                s = I(1);
                g = me.Gui.Top.callGui('CallAnalysis');
                g.changeFile(k,false);
                g.changeChannel(j,false);
                g.changeCall(s,true);
            end
        end
    end
    
end

