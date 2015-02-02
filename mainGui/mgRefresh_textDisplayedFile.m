function [  ] = mgRefresh_textDisplayedFile(  )
%MGREFRESH_TEXTDISPLAYEDFILE 

    handles = mgGetHandles();
    k = appData('Files','Displayed');
    if k == 0
        str = '';
    else
        str = strcat(['#',num2str(k),' - ',fileData(k,'Name','NoValidation',true)]);
    end
    set(handles.textDisplayedFile,'String',str);

end

