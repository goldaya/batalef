function saveBeam( k,a,beam )
%SAVEBEAM Summary of this function goes here
%   Detailed explanation goes here

    global filesObject;
    
    if ~exist('beam','var') || isempty(beam)
        beam = calculateBeam(k,a);
    end
    
    filesObject(k).fileCalls{a}.beam = beam;
    
end

