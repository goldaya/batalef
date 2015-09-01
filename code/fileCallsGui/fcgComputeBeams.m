function fcgComputeBeams()
%FCGCOMPUTEBEAMS compute the beams of selected calls

    global filesObject;
    
    [k,~,~,~,A] = fcgGetCurrent();
    
    n = length(A);
    for i = 1:n
        beam = filesObject(k).fileCalls{A(i)}.beam;
        U = 1:length(beam.micsUsed);
        U = U(beam.micsUsed);
        micDirections = [beam.powers(U,1),beam.powers(U,2)];
        micPowers = beam.powers(U,11);
        [IM] = bmAdminCompute(micPowers,micDirections);
        beam.image = IM;
        filesObject(k).fileCalls{A(i)}.beam = beam;
    end
    msgbox('Finished beam computation')

end

