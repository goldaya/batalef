function fcgSavePowersMatrix(  )
%FCGSAVEPOWERSMATRIX Save the powers matrix to call's data structures

    global filesObject;
    
    [k,a] = fcgGetCurrent();
    if a == 0
        return;
    end
    
    uitab = getHandles('fcg','uitabPowers');
    D = get(uitab,'Data');
    
    U = cell2mat(D(:,1));
    N = size(D,2);
    M = cell2mat(D(:,2:N));
    
    filesObject(k).fileCalls{a}.beam.powers   = M;
    filesObject(k).fileCalls{a}.beam.micsUsed = U;

end

