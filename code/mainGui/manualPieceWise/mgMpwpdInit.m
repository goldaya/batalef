function [  ] = mgMpwpdInit(  )
%MGMpwpdINIT


    % clear both start and end lines
    mgMpwpdClearVerticalLines();
      
    % set motion and click functions for axes objects
    mgAssignAxesFunctions(@mgMpwpdStartVerticalLines,@mgMpwpdStart);
    
end

