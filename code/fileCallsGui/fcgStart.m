function fcgStart( fig, k )
%FCGSTART Start the file calls gui

    if ~isGuiAlive('fcg')
        registerGui('fcg',fig);
        fcgBuildPanels(fig, k);
    end

    handles = getHandles('fcg');
    
    % list & localization 
    fcgDefineFileCallsColumns(k);
    fcgPopulateCallsList(k);
    
    
    % matching
    fcgPopulateBaseChannelsList(k);
    fcgPopulateBaseCallsList(k,1);
    
    
    % beam
    N = fileData(k,'Calls','Count');
    if N > 0
    end
    
    
    
end

