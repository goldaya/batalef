function fcgRefresh( a )
%FCGREFRESH Refresh the fcg base calls list, file calls list, etc

    fcgPlotLocalization();
    fcgPopulateBaseCallsList();
    fcgPopulatePossibleMatches();
    fcgPopulateCallsList();
    
    if exist('a','var')
        idx = getHandles('fcg','textIdx');
        set(idx,'String',num2str(a));
    end
    
    fcgRefreshBeamPanel();

end

