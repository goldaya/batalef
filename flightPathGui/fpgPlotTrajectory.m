function [  ] = fpgPlotTrajectory( locations, Tvalues, mics )
%FPGPLOTTRAJECTORY Plot the trajectory of the bat

    handles = fpgGetHandles();
    axes(handles.axesTraj);
    
    if ~exist('mics', 'var')
        mics = [];
    end
    
    if size(locations) == [3,1]
        locations = transpose(locations);
    end
    
    % reset (with mics if provided)
    if ~isempty(mics)
       scatter3(handles.axesTraj, mics(:,1), mics(:,2), mics(:,3), 'r*'); 
       hold( handles.axesTraj, 'on' );
       for i = 1:size(mics,1)
           text(mics(i,1),mics(i,2),mics(i,3),num2str(i));
       end
       hold( handles.axesTraj, 'off' );
    else
        cla(handles.axesTraj);
    end
    
    if ~isempty(Tvalues)
        X = locations(:,1);
        Y = locations(:,2);
        Z = locations(:,3);

        hold( handles.axesTraj, 'on' );    
        scatter3(handles.axesTraj,X,Y,Z,'o');
        for i=1:length(X)
            text(X(i),Y(i),Z(i),num2str(i));
        end
        %text(X,Y,Z,cellstr(num2str(transpose(1:length(X)))));
    end
    
    if length(Tvalues) >= 2
        T = linspace(0, max(Tvalues), 20);
        sX = spline(Tvalues,X, T);
        sY = spline(Tvalues,Y, T);
        sZ = spline(Tvalues,Z, T);    
        plot3(handles.axesTraj, sX,sY,sZ);
    end
    hold( handles.axesTraj, 'off' );     
    axis( handles.axesTraj, 'tight' );
    
    A = [mics;locations];
    if ~isempty(A)
        maxA = max(A);
        minA = min(A);
        if min(maxA - minA) > 0
            set(handles.axesTraj, 'Xlim', [minA(1), maxA(1)]);
            set(handles.axesTraj, 'Ylim', [minA(2), maxA(2)]);
            set(handles.axesTraj, 'Zlim', [minA(3), maxA(3)]);
        end
    end

end