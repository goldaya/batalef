function isAlive = isGuiAlive(guiName)
%ISGUIALIVE Check if a gui has active figure object
    global control;
    if isfield(control,guiName) && ~isfield(control.(guiName),'fig') && ishandle(control.(guiName).fig)
        isAlive = true;
    else
        isAlive = false;
    end
end