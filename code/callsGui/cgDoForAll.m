function [  ] = cgDoForAll( K, J )
%CGDOFORALL Summary of this function goes here
%   Detailed explanation goes here

    global control;
    
    handles = cgGetHandles();
    [~,~,~,t] = cgGetCurrent;
    
    % overwrite existing data?
    overwrite = questdlg('There might be previously extracted calls. Overwrite existing calls data? (If you choose " No " unprocessed calls will be processed)','Overwrite?','Yes','No','No');
    if strcmp(overwrite,'Yes')
        overwrite = true;
    else
        overwrite = false;
    end
    
    % keep some values to use
    dt = str2double(get(handles.textCallWindow, 'String'))/1000 ;
    startThreshold = str2double(get(handles.textStartDiff,'String'));
    endThreshold   = str2double(get(handles.textEndDiff,  'String'));
    gapTolerance = str2double(get(handles.textGap, 'String'))/1000;

    
    for k = 1:length(K)
        if isempty(J)
            Jbar = 1:fileData(K(k),'Channels','Count');
        else
            nChannels = fileData(K(k),'Channels','Count');
            Jbar = J(J<=nChannels);
        end
        for j = 1:length(Jbar)
            
            % get un/filtered TS for channel
            dataset = channelData(K(k),Jbar(j),'TS','Filter',control.cg.filter);
            
            % do for all calls in this channel
            for s=1:channelData(K(k),Jbar(j),'Calls','Count')
                call = channelCall(K(k),Jbar(j),s,t,false);
                if ~call.Saved || overwrite
                    window = [call.DetectionTime-dt/2, call.DetectionTime+dt/2];
                    wip = channelCall.inPoints(call, window);
                    call = channelCallAnalyze(K(k),Jbar(j),s,t,window,dataset(wip),[],startThreshold,endThreshold,gapTolerance,[],true,true);
                    ok = cgSave(call, handles);
                    if ~ok
                        return;
                    end
                end
            end
            
        end
    end
    
    msgbox('Finished');

end

