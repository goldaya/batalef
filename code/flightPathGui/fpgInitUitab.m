function fpgInitUitab( fig )
%FPGINITUITAB Summary of this function goes here
%   Detailed explanation goes here

    global control;
    handles = fpgGetHandles();
    
    uitabPosition = [0,0,1,1];
    uitabUnits = 'normalized';
    
    % columns
    N = fileData(control.fpg.k,'Channels','Count');
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
    
    uitab = uitable('parent',handles.panelTable,...
                    'units',uitabUnits,...
                    'Position',uitabPosition,...
                    'columnname',uitabColNames,...
                    'columnformat',uitabColFormats,...
                    'columnEditable',uitabColEditable,...
                    'columnWidth',uitabColWidths,...
                    'Tag','uitabFileCalls',...
                    'CellEditCallback',@fpgUitabCellEdit);
    guiD = guidata(fig);
    guiD.uitabFileCalls = uitab;
    guidata(fig,guiD);

end

