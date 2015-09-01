function fcgPlotLocalization()
%FCGPLOTLOCALIZATION Plot the mics, call positions and trajectroy in the
%file calls gui

    k = fcgGetCurrent();
    axobj = getHandles('fcg','axesLocalization');
    
    mics = fileData(k,'Mics','Positions');
    Nmics = size(mics,1);
    
    % initialize
    axes(axobj);
    cla();
    scatter3(mics(:,1), mics(:,2), mics(:,3), 'r*');
    hold on;
    micsNumbers = mat2cell(num2str((1:Nmics)'),ones(Nmics,1));
    text(mics(:,1),mics(:,2),mics(:,3),micsNumbers);
    
    % add calls
    locations = fileData(k,'Calls','Locations');
    Ncalls = size(locations,1);
    scatter3(locations(:,1),locations(:,2),locations(:,3),'o');
    callsNumbers = mat2cell(num2str((1:Ncalls)'),ones(Ncalls,1));
    text(locations(:,1),locations(:,2),locations(:,3),callsNumbers);
    
    % trajectory
    % under development
    
    hold off;
    axis tight;
    
end

