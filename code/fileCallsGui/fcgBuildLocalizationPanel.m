function fcgBuildLocalizationPanel(fig,k)
% FCGBUILDLOCALIZATIONPANEL build the UI table and axes objects

    guiD = guidata(fig);

    % calls table
    uitabPosition = [0,0,0.7,1];
    uitabUnits = 'normalized';
    
    
    uitab = uitable('parent',guiD.panelLocalization,...
                    'units',uitabUnits,...
                    'Position',uitabPosition,...
                    'Tag','uitabFileCalls',...
                    'CellEditCallback',@fpgUitabCellEdit);


    % axes object
    axesPosition = [0.7,0,0.3,1];
    axesUnits = 'normalized';
    axobj = axes('parent',guiD.panelLocalization,...
                    'units',axesUnits,...
                    'Position',axesPosition,...
                    'Tag','axesLocalization');

    guiD = guidata(fig);
    guiD.uitabFileCalls = uitab;
    guiD.axesLocalization = axobj;
    guidata(fig,guiD);

	
end