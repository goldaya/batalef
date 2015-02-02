function [  ] = fpgRefresh( a )
%FPGREFRESH Refresh screen items

    if ~exist('a','var')
        [~,~,~,a] = fpgGetCurrent();
    end
    
    fpgRefreshBaseCallsList();
    fpgRefreshSeqList();
    fpgRefreshFileCallsTable( a );
    fpgSelectFileCall( a );
    fpgRefresh3DRoute();

    
end