function [  ] = fpgRefresh( a )
%FPGREFRESH Refresh screen items

    if ~exist('a','var')
        [~,~,s,a] = fpgGetCurrent();
    else
        [~,~,s,~] = fpgGetCurrent();
    end
    
    fpgRefreshBaseCallsList(s+1);
    fpgRefreshSeqList();
    fpgRefreshFileCallsTable( a );
    fpgSelectFileCall( a );
    fpgRefresh3DRoute();

    
end