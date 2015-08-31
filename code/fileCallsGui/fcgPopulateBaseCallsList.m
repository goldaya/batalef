function s = fcgPopulateBaseCallsList( k,j )
%FCGPOPULATEBASECALLSLIST Put all the free base channels in the drop down
%list and select the first

    ddBaseCall = getHandles('fcg','ddBaseCall');
    N = 1:channelData(k,j,'Calls','Count');
    I = arrayfun(@(s) channelCallData(k,j,s,'FileCall')==0,N);
    C = N(I);

    if isempty(C)
        s = [];
        S = 'N/A';
    else
        s = C(1);
        S = num2str(C);
    end
    
    set(ddBaseCall,'String',S);
    set(ddBaseCall,'Value',1);
    
end

