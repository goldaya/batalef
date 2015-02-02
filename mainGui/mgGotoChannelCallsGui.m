function [  ] = mgGotoChannelCallsGui(  )
%MGGOTOCHANNELCALLSGUI 

    K = mgResolveFilesToWork();
    if ~isempty(K)
        for i = 1:length(K)
            J = fileData(K(i),'Channels','Count');
            if ~isempty(J)
                for j = 1:J
                    n = channelData(K(i),j,'Calls','Count');
                    if n > 0
                        callsGUI(K(i),j,1);
                        return;
                    end
                end
            end
        end
    end

end

