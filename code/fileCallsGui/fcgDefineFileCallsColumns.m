function fcgDefineFileCallsColumns(k)
%FCGDEFINEFILECALLSCOLUMNS set the columns of the file list table (number of mics is file specific)

    N = fileData(k,'Mics','Count');
    uitabColNames    = cell(1,2+N);
    uitabColEditable = zeros(1,2+N);
    uitabColFormats  = cell(1,2+N);
    uitabColWidths   = cell(1,2+N);
    
    uitabColNames{1}    = 'Time';
    uitabColEditable(1) = 1;
    uitabColFormats{1}  = 'numeric';
    uitabColWidths{1}   = 70;
    
    uitabColNames{2}    = '3D Location';
    uitabColEditable(2) = 1;
    uitabColFormats{2}  = 'numeric';
    uitabColWidths{2}   = 200;
    
    for i = 1:N
        uitabColNames{i+2}    = num2str(i);
        uitabColEditable(i+2) = 0;
        uitabColFormats{i+2}  = 'numeric';
        uitabColWidths{i+2}   = 20;
    end
    
    uitabColEditable = logical(uitabColEditable);

    uitab = getHandles('fcg','uitabFileCalls');
    set(uitab,'columnname',uitabColNames);
    set(uitab,'columnformat',uitabColFormats);
    set(uitab,'columnWidth',uitabColWidths);
    set(uitab,'columnEditable',uitabColEditable);

end