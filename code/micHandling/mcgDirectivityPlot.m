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
            C{2}{cellIdx} = zeros(1,2);
            n = 0;
        else
            n = size(C{2}{cellIdx},1);
        end
        
        % the angle-gain vector for specific freq
        C{2}{cellIdx}(n+1,1)=Dmat{i,2}; % angle
        C{2}{cellIdx}(n+1,2)=Dmat{i,3}; % gain
    end
    
    col = graphColors();
    
    N = length(C{1});
    lString = cell(N,1);
    for i = 1:N
        color = col.getNext();
        A = sortrows(C{2}{i},1);
        x = deg2rad(A(:,1));
        y = A(:,2) + 70;
        polar(axobj,x,y,color);
        hold(axobj,'on');
        lString{i} = strcat([C{1}{i},' KHz']);
    end
    hold(axobj,'off');
    set(axobj,'View',[270,90]);
    legend(lString,'Location','NorthEast');

end

