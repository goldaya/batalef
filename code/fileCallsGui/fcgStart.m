function fcgStart( fig, k )
%FCGSTART Start the file calls gui

    global control;
    
    control.fcg.k = k;
    if ~isGuiAlive('fcg')
        fcgBuildBeamPanel(fig);
        fcgBuildLocalizationPanel(fig);
        registerGui('fcg',fig);
        locAdminBuildList(fig);
        locAdminMethodSelectedInternal(control.beam.method,true);
        bmAdminBuildList(fig);
        bmAdminMethodSelectedInternal(control.beam.method,true);        
    end

    handles = getHandles('fcg');
    
    % matching
    fcgPopulateBaseChannelsList(k);
    fcgPopulateBaseCallsList();
    fcgPopulatePossibleMatches();
    
    % list & localization 
    fcgDefineFileCallsColumns(k);
    fcgPopulateCallsList();
    fcgPlotLocalization();
    
    % selection & operations
    set(handles.textIdx,'String','0');
    
        
    % beam
    cla(handles.axesBeam);
    cla(handles.axesRaw);
    set(handles.uitabPowers,'Data',[]);
    
%     N = fileData(k,'Calls','Count');
%     if N > 0
%     end
    
    
    
end

