function seqs = fpgSuggestFileCalls(  )
%FPGSUGGESTFILECALLS Summary of this function goes here
%   Detailed explanation goes here

    seqs = [];
    [k,~,j,s] = fpgGetCurrent();
    if isnan(s)
        return;
    end
    %timePointToUse = 'Start';
    if isscalar(s)
        %seqs = suggestSeqs( s,j,k, timePointToUse);
        
        handles = fpgGetHandles();
        
        nChannels = fileData(k,'Channels','Count');
        V = zeros(nChannels,1);
        V(j) = s;
        
        usage = fileData(k,'Mics','LocalizationUsage');
        %nMics = sum(usage);
        U = 1:nChannels;
        U = U(usage);
        U = U(U~=j);
        %U = [j U];
        
        dev = str2double(get(handles.textError, 'String'))/100 + 1;
        
        [seqs,R] = ccmRecursiveStep( V, U, k, dev );
        seqs = {seqs};
        if R < (sum(usage)-1)
            seqs = cell(0,0);
        end
        
    end

end

