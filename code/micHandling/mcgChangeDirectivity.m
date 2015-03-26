function mcgChangeDirectivity( D )
%MCGCHANGEDIRECTIVITY -INTERNAL- Change directivity data in Mic Admin Gui

    % check D is 3d
    if size(D,2) ~= 3
        msgbox('Input matrix not 3D')
        return
    end
    
    handles = mcgGetHandles();
    set(handles.tableDirectivity, 'Data', num2cell(D));
    
    mcgDirectivityPlot(num2cell(D));
    

end

