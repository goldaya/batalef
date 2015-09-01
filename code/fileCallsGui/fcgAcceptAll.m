function fcgAcceptAll(  )
%FCGACCEPTALL Accept all possible file calls

    [k,~,j,~] = fcgGetCurrent;
    handles = getHandles('fcg');    
    dev = str2double(get(handles.textErrTol, 'String'))/100 + 1;
    
    % go over unassigned base calls, for each accept the 1st seq
    n = channelData(k,j,'Calls','Count');
    for s = 1:n
        if channelCallData(k,j,s,'FileCall')==0
            seqs = ccmSimple(k,j,s,dev);    
            if ~isempty(seqs)
                addFileCall(k, seqs{1});
            end
        end
    end
    
    msgbox('Accepted all calls');
    fcgRefresh();
    
end

