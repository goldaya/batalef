function [ a ] = checkMicsUnity( K )
%CHECKMICSUNITY check if files can have their mics managed together, and if
%so, whether they are all the same

    if isempty(K)
        a = -1;
        return;
    end
    
    if length(K) == 1
        a = 1;
        return;
    end
    
    n = fileData(K(1),'Channels','Count');
    M = fileData(K(1),'Mics','Matrix');
    for i = 2:length(K)
        ntag = fileData(K(i),'Channels','Count');
        if n ~= ntag
            a = -1;
            return;
        end
        Mtag = fileData(K(i),'Mics','Matrix');
        B = M ~= Mtag;
        if max(max(B)) > 0
            a = 0;
            return;
        end        
    end
    
    a = 1;
    
end

