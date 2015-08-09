function fpgAcceptAll(  )
%FPGACCEPTALL Internal Accept all possible file calls

    [k,~,j,~] = fpgGetCurrent;
    handles = fpgGetHandles();    
    dev = str2double(get(handles.textError, 'String'))/100 + 1;
    
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
    
end

