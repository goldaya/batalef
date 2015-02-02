function [  ] = mgGetChannelCallsMatrix(  )
%MGGETCHANNELCALLSMATRIX Summary of this function goes here
%   Detailed explanation goes here

    K = mgResolveFilesToWork();
    if isempty(K)
        return;
    end
    
    n = length(K);
    A = cell(n,1);
    
    for i = 1:n
        A{i} = fileData(K(i),'Channels','Calls','Matrix');
    end
    
    V = inputdlg('Assign data to variable:');
    var = V{1};
    
    assignin('base',var,A);
    
    disp(strcat(['   variable "',var,'" is now a cell array']))
    disp('   each cell holds the calls matrix for a file')
    disp('   the matrix is of the form:')
    disp('   01 - channel index')
    disp('   02 - call index')
    disp('   03 - detection time (seconds)')
    disp('   04 - detection value')
    disp('   05 - peak time')
    disp('   06 - peak value')
    disp('   07 - peak fund. freq. (Hz)')
    disp('   08 - start time')
    disp('   09 - start value')
    disp('   10 - start fund. freq.')
    disp('   11 - end time')
    disp('   12 - end value')
    disp('   13 - end fund. freq')
    disp('   14 - file call index')
    disp('   15 - IPI')
    disp('   16 - Duration (seconds)')
    disp(' ')
    
end