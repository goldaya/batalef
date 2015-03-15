function fpgUitabCellEdit( hObject,callbackdata )
%FPGUITABCELLEDIT

    sCell = callbackdata.Indices;
    
    switch sCell(2)
        case 1
            fpgSelectFileCall( sCell(1) );
            
    end
            

end

