classdef bMainGuiContextMenu
    %BMAINGUICONTEXTMENU Object for creating and handling main gui axes
    %context menu
    
    properties
        Gui
        UIObject
    end
    
    properties (Dependent = true)
        
    end
    
    methods (Access = public)
        
        % CONSTRUCTOR
        function me = bMainGuiContextMenu(mainGui)
            me.Gui= mainGui;
            
            me.UIObject = uicontextmenu(me.Gui.Figure);
            uimenu(me.UIObject,'Label','Measure Time Diff.','Callback',@(~,~)me.measureTime);
            uimenu(me.UIObject,'Label','Zoom in','Callback',@(~,~)me.zoomIn());
            pois = uimenu(me.UIObject,'Label','POIs');
            uimenu(pois,'Label','Add','Callback',@(~,~)me.addPoi());
            uimenu(pois,'Label','Remove','Callback',@(~,~)me.removePois(false));
            uimenu(pois,'Label','Remove in all channels','Callback',@(~,~)me.removePois(true));
            cc = uimenu(me.UIObject,'Label','Channel Calls');
            uimenu(cc,'Label','Add detection here');
            uimenu(cc,'Label','Remove');
            uimenu(cc,'Label','Remove in all channels');
            uimenu(cc,'Label','Show call info');              
        end
        
    end
    
    methods (Access = private)
       
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
        
        % POIS
        % ADD
        function addPoi(me)
            axes(me.Gui.LastAxesObject);
            [x,y] = ginput(1);
            A = inputdlg('Point of Interest text:');
            if ~isempty(A)
                UD = get(me.Gui.LastAxesObject,'UserData');
                if strcmp(UD{2},'Spec')
                    C = {x,A{1},0,y};
                elseif strcmp(UD{2},'TS')
                    C = {x,A{1},y,0};
                else
                    errid  = 'batalef:mainGui:wrongAxesType';
                    errstr = sprintf('Wrong Axes Type: %s',UD{2});
                    err = MException(errid,errstr);
                    throwAsCaller(err);
                end
                
                k = me.Gui.LastGraphObject.FileIdx;
                j = me.Gui.LastGraphObject.ChannelIdx;
                addPois(k,j,C);
                me.Gui.LastGraphObject.plot();
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
        
    end
    
end

