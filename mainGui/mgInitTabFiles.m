function mgInitTabFiles( fig )
%MGINITTABFILES 

    guiD = guidata(fig);
    
    uitabPosition = [0,19,600,100];
    uitabUnits = 'pixels';
    uitabColEditable = logical([1 0 0 0 0 0 0]);
    uitabColNames = {'','Path + Name','Length','Fs','# Channels','# Calls','Raw Data Status'};
    uitabColWidths = {20,300,60,60,60,60,100};
    uitabColFormats = {'logical','char','numeric','numeric','numeric','numeric','char'};
    
    uitab = uitable('parent',guiD.topPanel,...
                    'units',uitabUnits,...
                    'Position',uitabPosition,...
                    'columnname',uitabColNames,...
                    'columnformat',uitabColFormats,...
                    'ColumnWidth',uitabColWidths,...
                    'columnEditable',uitabColEditable,...
                    'Tag','tabFiles',...
                    'CellEditCallback',@mgTabFilesCellEdit);
    
    guiD.tabFiles = uitab;
    guidata(fig,guiD);


end

