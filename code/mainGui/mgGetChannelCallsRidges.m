function [ output_args ] = mgGetChannelCallsRidges( input_args )
%MGGETCHANNELCALLSRIDGES Summary of this function goes here
%   Detailed explanation goes here

    K = mgResolveFilesToWork();
    if isempty(K)
        return;
    end
    
    n = length(K);
    A = cell(n,1);
    
    for i = 1:n
        A{i} = fileData(K(i),'Channels','Calls','Ridge');
    end
    
    V = inputdlg('Assign data to variable:');
    var = V{1};
    
    assignin('base',var,A);  
    
    disp(strcat(['   variable "',var,'" is now a nested cell array, holding ridges data']))
    disp('   cells hierarchy: file (selected index) -> channel -> call')
    disp('   the ridge matrix is of the form:')
    disp('   1 - time')
    disp('   2 - fund. freq')
    disp('   3 - fund. freq power')
    disp(' ')
    

end

