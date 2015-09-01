function [  ] = fcgPopulatePossibleMatches(  )
%fCGPOPULATEPOSSIBLEMATCHES find possible matches based on the base channel
%and call and put it in the dropdown lisr


    handles = getHandles('fcg');
    set(handles.ddSeqs, 'Value', 1);
    
    dev = str2double(get(handles.textErrTol, 'String'))/100 + 1;
    [k,~,j,s] = fcgGetCurrent;
    if isnan(s)
        Seqs = [];
    else
        Seqs = ccmSimple(k,j,s,dev);
    end
        
    if isempty(Seqs)
        S = 'N/A';
    else
        %S{1}='';
        n=length(Seqs);
        S = cell(n,1);
        for i=1:n
            A = seq2string(Seqs{i});
            S{i}=A;
        end
    end

    set(handles.ddSeqs, 'String', S);
    set(handles.ddSeqs, 'UserData', Seqs);
    
end

