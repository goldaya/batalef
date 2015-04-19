function mgGetFileCallsBeamsData(  )
%MGGETFILECALLSBEAMSDATA 

    K = mgResolveFilesToWork();
    if isempty(K)
        return;
    end
    
    n = length(K);
    A = cell(n,1);
    
    for i = 1:n
        A{i} = fileData(K(i),'Calls','Beam');
    end
    
    V = inputdlg('Assign data to variable:');
    var = V{1};
    
    assignin('base',var,A);
    
    disp(strcat(['   variable "',var,'" is now a cell array']))
    disp('   each cell holds the beams data for file-calls of single file')
    disp('   the beam data structure is:')
    disp('   leads          - the mic direction and computed "power at mic" [az,el,p] - used mics only')
    disp('   raw            - before interpolation: "power at mic" in the coordinated matrix')
    disp('   interpolated   - interpolated beam matrix')
    disp('   coordinates    - the Azimuth & Elevation coordinates of the "raw" and "interpolated" matrices')
    disp('   micDirections  - mic directions [az,el] of all mics')
    disp('   used           - mic used for beam computation')
    


end

