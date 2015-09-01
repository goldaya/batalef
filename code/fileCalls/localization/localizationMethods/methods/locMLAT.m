function [ x,t ] = locMLAT( callsTimes, micPositions, params )
%LOCMLAT approximate location and time of call using MLAT

    intArray = callsTimes - callsTimes(1);
    x = MLAT( micPositions, intArray, params.sonic ); 
    t = callsTimes(1);

end

