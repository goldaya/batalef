function mgLinkAxes( link )
%MGLINKAXES Internal Link axes of graphs

    handles = mgGetHandles();
    nAxes = appData('Axes','Count');
    V = zeros(nAxes,1);
    for i = 1:nAxes;
        axesName = strcat('axes',num2str(i));
        if link
            V(i) = handles.(axesName);
        else
            linkaxes(handles.(axesName));
        end
    end
    if link
        linkaxes(V);
    end

end

