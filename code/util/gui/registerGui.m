function registerGui( guiName, guiFig )
%REGISTERGUI Register the gui figure object with batalef

    global control;
    control.(guiName).fig = guiFig;

end

