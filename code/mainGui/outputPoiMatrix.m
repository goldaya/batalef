function outputPoiMatrix( K )
%OUTPUTPOIMATRIX 

    C = arrayfun(@(k) {arrayfun(@(j) {channelData(k,j,'Pois')},1:fileData(k,'Channels','Count'))},K);
    assignin('base','pois',C);
    
end

