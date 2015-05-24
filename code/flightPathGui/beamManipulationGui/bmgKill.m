function bmgKill(  )
%BMGKILL Summary of this function goes here
%   Detailed explanation goes here
    global control
    try
        delete(control.bmg.fig)
    catch err
    end

end

