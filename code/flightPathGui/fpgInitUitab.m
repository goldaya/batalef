function fpgInitUitab( fig )
%FPGINITUITAB Summary of this function goes here
%   Detailed explanation goes here

    handles = fpgGetHandles();
    
    uitabPosition = [0,0,1,1];
    uitabUnits = 'normalized';
    uitabColEditable = logical([1 1 0]);
    uitabColNames = {'Time','3D Location','Channel Calls'};
    uitabColFormats = {'numeric','numeric','char'};
    uitabColWidths = {70,200,300};
    
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

