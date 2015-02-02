function mgGetFileCalls(  )
%MGGETFILECALLS 

    K = mgResolveFilesToWork();
    if isempty(K)
        return;
    end
    
    n = length(K);
    A = cell(n,1);
    
    for i = 1:n
        A{i} = fileData(K(i),'Calls','Data');
    end
    
    V = inputdlg('Assign data to variable:');
    var = V{1};
    
    assignin('base',var,A);  
    
    disp(strcat(['   variable "',var,'" is now a nested cell array, holding File Calls']))
    disp('   cells hierarchy: File (selected index) -> File Call ')
    disp('   the call structure has the following fields:')
    disp('   channelCalls   = the channel calls mathced to determine the file call')
    disp('   location       = 3D position of bat during call ')
    disp('   time           = time of call ')
    disp('   beam           = struct:')
    disp('   +micDirections = direction of mics from bat''s viepoint')
    disp('   +leads         = micDirections with call power toward mics')
    disp('   +raw           = full matrix with only the leads on it')
    disp('   +interpolated  = full matrix of beam')
    disp(' ')
    
end