function [  ] = mgSetAxesNumber( n )
%MGSETAXESNUMBER Set the GUI axes to show n axes object

    global control;
    N = control.mg.nAxes;
    
    if n < N
        d = N - n;
        mgRemoveAxes(d);
    elseif n > N
        d = n - N;
        mgAddAxes(d);
    else
        return; % do nothing
    end
    
    mgRefreshAxes();

end