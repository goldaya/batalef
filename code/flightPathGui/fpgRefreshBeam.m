function fpgRefreshBeam(  )
%FPGREFRESHBEAM -INTERNAL- display beam on flight path & beam gui

    handles = fpgGetHandles();
    
    
    [k,a] = fpgGetCurrent();
    if a == 0
        cla(handles.axesBeam);
        return;
    end
    
    P = fileCallData(k,a,'Beam','Interpolated');
    C = fileCallData(k,a,'Beam','Coordinates','NoValidation',true);
    M = fileCallData(k,a,'Beam','Mics','NoValidation',true);
    
    
    % clear / show beam
    axes(handles.axesBeam);
    cla;
    if isempty(P)
    else
        %P = log(P);
        surf(C(:,1),C(:,2),P,'edgecolor','none');
        view(2);
        axis tight;
        xlim = get(gca, 'Xlim');
        ylim = get(gca, 'Ylim');
        zlim = get(gca, 'Zlim');
        hold on;
        maxP = max(max(P));
        X = M(:,1);
        Y = M(:,2);
        I = logical( ...
            (X >= xlim(1)) .* (X <= xlim(2)) .* ...
            (Y >= ylim(1)) .* (Y <= ylim(2)) );
        scatter3(X(I),Y(I),zeros(size(I(I==1),1),1)+maxP,'*','white');
        for i = 1 : size(M,1)
            if I(i)
                text(M(i,1),M(i,2),maxP,num2str(i));
            end
        end
        hold off;
        % color legend
        colorbar;
        %set(gca,'Xlim',xlim);
        %set(gca,'Ylim',ylim);
        %set(gca,'Zlim',zlim);
    end
    
end

