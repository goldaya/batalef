function fpgRefreshBeam(  )
%FPGREFRESHBEAM Summary of this function goes here
%   Detailed explanation goes here

    handles = fpgGetHandles();
    axes(handles.axesBeam);
    
    [k,~,~,a] = fpgGetCurrent();
    if a == 0
        cla;
        return;
    end
    
    P = fileCallData(k,a,'Beam','Interpolated');
    C = fileCallData(k,a,'Beam','Coordinates','NoValidation',true);
    M = fileCallData(k,a,'Beam','Mics','NoValidation',true);
    
    if isempty(P)
        cla;
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
    end
    
end

