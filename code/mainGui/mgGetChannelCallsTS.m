function mgGetChannelCallsTS(  )
%MGGETCHANNELCALLSTS 

    K = mgResolveFilesToWork();
    if isempty(K)
        return;
    end
    
    n = length(K);
    A = cell(n,1);
    
    for i = 1:n
        A{i} = fileData(K(i),'Channels','Calls','TS');
    end
    
    V = inputdlg('Assign data to variable:');
    var = V{1};
    
    assignin('base',var,A);  
    
    disp(strcat(['   variable "',var,'" is now a nested cell array, holding channel calls TS']))
    disp('   cells hierarchy: file (selected index) -> channel -> call')
    disp('   the call matrix is of the form:')
    disp('   1 - time')
    disp('   2 - value')
    disp(' ')


end

