function [  ] = fpgDeleteFileCall(  )
%FPGDELETEFILECALL Deletes the currently selected file call
    
    [k,~,~,a] = fpgGetCurrent();
    if a > 0
        n = fileData(k,'Calls','Count','NoValidation',true);
        deleteFileCall(k,a);
        if a == n
            a = a - 1;
        end
        fpgRefresh(a);
    end
    
end

