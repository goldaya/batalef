function [  ] = cgDoForAll( K, J )
%CGDOFORALL Summary of this function goes here
%   Detailed explanation goes here

    handles = cgGetHandles();
    
    % overwrite existing data?
    overwrite = questdlg('There might be previously extracted calls. Overwrite existing calls data? (If you choose " No " unprocessed calls will be processed)','Overwrite?','Yes','No','No');
    if strcmp(overwrite,'Yes')
        overwrite = true;
    else
        overwrite = false;
    end
    
    % keep some values to use
    startRelativeThreshold = 1 - get(handles.sliderStartDiff, 'Value');
    endRelativeThreshold = 1 - get(handles.sliderEndDiff, 'Value');
    rawGapTolerance = str2double(get(handles.textGap, 'String'))/1000;
    
    for k = 1:length(K)
        Fs = fileData(K(k),'Fs');
        gapTolerance = rawGapTolerance*Fs;
        dp = round( str2double(get(handles.textCallWindow, 'String'))/1000 * Fs );
        if isempty(J)
            Jbar = 1:fileData(K(k),'Channels','Count');
        else
            nChannels = fileData(K(k),'Channels','Count');
            Jbar = J(J<=nChannels);
        end
        for j = 1:length(Jbar)
            for s=1:channelData(K(k),Jbar(j),'Calls','Count')
                call = channelCall(K(k),Jbar(j),s);
                if ~call.Saved || overwrite
                    call = calculateCall(call,overwrite,dp,startRelativeThreshold,endRelativeThreshold,gapTolerance);
                    call.save();
                end
            end
        end
    end
    
    msgbox('Finished');

end

