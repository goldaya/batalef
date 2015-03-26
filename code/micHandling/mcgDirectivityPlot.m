function mcgDirectivityPlot( Dmat )
%MCGDIRECTIVITYPLOT -INTERNAL- plot the directivity graph based on
%directivity matrix

    handles = mcgGetHandles();
    axobj = handles.axesDirectivity;
    cla(axobj)    
    if isempty(Dmat)
        return;
    end
    
    % create different graph for each frequency
    C = cell(1,2);
    for i = 1:size(Dmat,1)
        % cellIdx is the freq index for specific 
        cellIdx = find(strcmp(num2str(Dmat{i,1}), C{1}));
        if isempty(cellIdx)
            cellIdx = length(C{1}) + 1;
            C{1}{cellIdx} = num2str(Dmat{i,1});
            C{2}{cellIdx} = cell(1,2);
            C{2}{cellIdx}{1} = zeros(1,1);
            C{2}{cellIdx}{2} = zeros(1,1);
            n = 0;
        else
            n = length(C{2}{cellIdx}{1});
        end
        
        % the angle-gain vector for specific freq
        C{2}{cellIdx}{1}(n+1)=Dmat{i,2}; % angle
        C{2}{cellIdx}{2}(n+1)=Dmat{i,3}; % gain
    end
    
    col = graphColors();
    
    N = length(C{1});
    lString = cell(N,1);
    for i = 1:N
        color = col.getNext();
        x = deg2rad(C{2}{i}{1});
        y = C{2}{i}{2} + 70;
        polar(axobj,x,y,color);
        hold(axobj,'on');
        lString{i} = strcat([C{1}{i},' KHz']);
    end
    hold(axobj,'off');
    legend(lString,'Location','NorthEastOutside');

end

