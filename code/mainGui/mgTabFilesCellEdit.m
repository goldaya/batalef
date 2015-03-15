function [ output_args ] = mgTabFilesCellEdit( hObject,callbackdata )
%MGTABFILESCELLEDIT

    sCell = callbackdata.Indices;
    k = sCell(1);
    
    switch sCell(2)
        case 1 % selection CB
            fileData(k,'Select',callbackdata.EditData);

            
    end


end

