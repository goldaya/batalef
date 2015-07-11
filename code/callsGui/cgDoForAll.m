function [  ] = cgDoForAll( K, J )
%CGDOFORALL Summary of this function goes here
%   Detailed explanation goes here

    global control;
%     global test;
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

%     test = cell(12,1);
    for k = 1:length(K)
        if isempty(J)
            Jbar = 1:fileData(K(k),'Channels','Count');
        else
            nChannels = fileData(K(k),'Channels','Count');
            Jbar = J(J<=nChannels);
        end
        for j = 1:length(Jbar)
            SS = zeros(channelData(K(k),Jbar(j),'Calls','Count'),2);
            
            % get un/filtered TS for channel
            dataset = channelData(K(k),Jbar(j),'TS','Filter',control.cg.filter);
            
            % do for all calls in this channel
            for s=1:channelData(K(k),Jbar(j),'Calls','Count')
                call = channelCall(K(k),Jbar(j),s,t,false);
                if ~call.Saved || overwrite
                    window = [call.DetectionTime-dt/2, call.DetectionTime+dt/2];
                    wip = channelCall.inPoints(call, window);
%                     tic;
                    [call] = channelCallAnalyze(K(k),Jbar(j),s,t,window,dataset(wip(1):wip(2)),[],startThreshold,endThreshold,gapTolerance,[],true,true);
%                     SS(s,1) = toc;
%                     tic;
%                     [call] = channelCallAnalyze_new(K(k),Jbar(j),s,t,window,dataset(wip(1):wip(2)),[],startThreshold,endThreshold,gapTolerance,[],true,true);
%                     SS(s,2) = toc;
                    ok = cgSave(call, handles);
                    if ~ok
                        return;
                    end
                end
            end
            test{j} = SS;
        end
    end
    
    msgbox('Finished');

end

