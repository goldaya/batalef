function [  ] = sogTmShowVerticalLines( time, type )
%SOGTMSHOWVERTICALLINES Summary of this function goes here
%   Detailed explanation goes here


    handles = sogGetHandles;
    nAxes = appData('Axes','Count');
    for i=1:nAxes
        axesName = strcat('axes',num2str(i));
        axobj = handles.(axesName);
        % delete old lines
        aoc = get(axobj,'Children');
        for j = 1:length(aoc)
            if strcmp(type,get(aoc(j),'UserData'))
                delete(aoc(j));
            end
        end
        Ylim = get(axobj,'Ylim');
        Zlim = get(axobj,'Zlim');
        axes(axobj);
        hold(axobj,'on') ;
        vline = line([time,time],Ylim,[Zlim(2),Zlim(2)],'LineWidth',2,'Color','white');
        set(vline,'UserData',type);
        switch type
            case 'start'
                set(vline, 'ButtonDownFcn', @sogTmStart);
            case 'end'
                set(vline, 'ButtonDownFcn', @sogTmEnd);
        end
        hold(axobj,'off');
    end
    
end
