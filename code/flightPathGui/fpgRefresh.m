function [  ] = fpgRefresh( a )
%FPGREFRESH Refresh screen items

    if ~exist('a','var')
        [~,a,~,s] = fpgGetCurrent();
    else
        [~,~,~,s] = fpgGetCurrent();
    end
    
    fpgRefreshBaseCallsList(s+1);
    fpgRefreshSeqList();
    fpgRefreshFileCallsTable();
    fpgSelectFileCall( a );
    fpgRefresh3DRoute();

    
end