function fpgRefreshBeam(  )
%FPGREFRESHBEAM Summary of this function goes here
%   Detailed explanation goes here

    global control;
    handles = fpgGetHandles();
    
    
    [k,~,~,a] = fpgGetCurrent();
    if a == 0
        cla;
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
        surf(C(:,1),C(:,2),P,'edgecolor','none');
        view(2);
        axis tight;
        hold on;
        maxP = max(max(P));
        scatter3(M(:,1),M(:,2),zeros(size(M,1),1)+maxP,'*','white');
        for i = 1 : size(M,1)
            text(M(i,1),M(i,2),maxP,num2str(i));
        end
        hold off;
        % color legend
        colorbar;
    end
    
end

