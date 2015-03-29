 function [  ] = fpgDeleteFileCall(  )
%FPGDELETEFILECALL Deletes the currently selected file calls
  
    k = fpgGetCurrent();
    handles = fpgGetHandles();
    A = str2num(get(handles.textIdx,'String'));
    deleteFileCall(k,A);
    fpgRefresh(0);
    
    %{
    [k,~,~,a] = fpgGetCurrent();
    if a > 0
        n = fileData(k,'Calls','Count','NoValidation',true);
        deleteFileCall(k,a);
        if a == n
            a = a - 1;
        end
        fpgRefresh(a);
    end
%}
    
end

