function [  ] = mgGetChannelCallsMatrix(  )
%MGGETCHANNELCALLSMATRIX Output channel calls data to matrix
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
    disp('   03 - start time (seconds)')
    disp('   04 - start value (from envelope)')
    disp('   05 - start freq (Hz, from spectrogram)')
    disp('   06 - start power (dB, from Spectrogram)')
    disp('   07 - peak time')
    disp('   08 - peak value')
    disp('   09 - peak freq')
    disp('   10 - peak power')
    disp('   11 - end time')
    disp('   12 - end value')
    disp('   13 - end fund. freq')
    disp('   14 - end power')
    disp('   15 - IPI')
    disp('   16 - Duration (seconds)')
    disp('   17 - Detection time')
    disp('   18 - Detection value')
    disp(' ')
    
end