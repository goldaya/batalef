function mgMarkPointOfInterest(  )
%MGMARKPOINTOFINTEREST Mark a point of interest on the graph
    
    global filesObject;
    
    
    % get user input
    [t,v] = ginput(1);
    j = get(gca,'UserData');
    
    % keep
    k = appData('Files','Displayed');
    pois = channelData(k,j,'Pois');
    i = size(pois,1)+1;
    pois(i,1) = t;
    pois(i,2) = v;
    filesObject(k).channels(j).pois = [];
    filesObject(k).channels(j).pois = pois;
    
    mgPlotPois(k,j,get(gca,'tag'));
    
end

