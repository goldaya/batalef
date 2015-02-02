function fpgReplaceLocations( D )
%FPGREPLACELOCATIONS INTERNAL Replace the locations of bat according to
%input
    
    global filesObject;
    
    
    % check integrity of new data
    s = size(D);
    if s(2) == 3
        % OK
    elseif s(2) ~= 3 && s(1) == 3
        D = transpose(D);
        s = size(D);
    else
        errmsg = 'Replacing 3D locations: The new data is of a wrong size';
        throw(MException('bats:fileCalls:replaceLocations:wrongInput',errmsg));
    end
        
    % check number of calls in file and in new data is the same
    k = fpgGetCurrent();
    n = length(filesObject(k).fileCalls);
    if s(1) ~= n
        errmsg = 'Replacing 3D locations: The new data is of a wrong size';
        throw(MException('bats:fileCalls:replaceLocations:wrongInput',errmsg));
    end
    
    % Replace
    for a = 1:n
        filesObject(k).fileCalls{a}.location = D(a,:);
    end
    
    
    % refresh calls table
    fpgRefreshFileCallsTable();


end

