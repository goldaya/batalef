function fcgBuildBeamPanel(fig,k)
%FCGBUILDBEAMPANEL File Calls Gui - build the beam data ui items

    guiD = guidata(fig);

    uitabPositions = [0,0.4,1,0.6];
    uitabUnits = 'normalized';

    N = 10;
    uitabColNames = cell(1,N);
    uitabColEditable = zeros(1,N);
    uitabColFormats  = cell(1,N);
    uitabColWidths   = cell(1,N);
    
    uitabColNames{1}    = 'Mic Rel Azimuth';
    uitabColEditable(1) = 1;
    uitabColFormats{1}  = 'numeric';
    uitabColWidths{1}   = 70;
    
    uitabColNames{2}    = 'Mic Rel Elevation';
    uitabColEditable(2) = 1;
    uitabColFormats{2}  = 'numeric';
    uitabColWidths{2}   = 70;
    
    uitabColNames{3}    = 'Distance';
    uitabColEditable(3) = 1;
    uitabColFormats{3}  = 'numeric';
    uitabColWidths{3}   = 70;

    uitabColNames{4}    = 'Meas. Power';
    uitabColEditable(4) = 0;
    uitabColFormats{4}  = 'numeric';
    uitabColWidths{4}   = 70;

    uitabColNames{5}    = 'Air absorption (dB)';
    uitabColEditable(5) = 1;
    uitabColFormats{5}  = 'numeric';
    uitabColWidths{5}   = 70;

    uitabColNames{6}    = 'Mic Calibration Gain (dB)';
    uitabColEditable(6) = 1;
    uitabColFormats{6}  = 'numeric';
    uitabColWidths{6}   = 70;

    uitabColNames{7}    = 'Mic Direct. Gain (dB)';
    uitabColEditable(7) = 1;
    uitabColFormats{7}  = 'numeric';
    uitabColWidths{7}   = 70;

    uitabColNames{8}    = 'Power after Air + Calib.';
    uitabColEditable(8) = 0;
    uitabColFormats{8}  = 'numeric';
    uitabColWidths{8}   = 70;

    uitabColNames{9}    = 'Power after Direct.';
    uitabColEditable(9) = 0;
    uitabColFormats{9}  = 'numeric';
    uitabColWidths{9}   = 70;

    uitabColNames{10}    = 'Power after all corrections';
    uitabColEditable(10) = 0;
    uitabColFormats{10}  = 'numeric';
    uitabColWidths{10}   = 70;

    uitabColEditable = logical(uitabColEditable);

    uitab = uitable('parent',guiD.panelBeam,...
                    'units',uitabUnits,...
                    'Position',uitabPosition,...
                    'columnname',uitabColNames,...
                    'columnformat',uitabColFormats,...
                    'columnEditable',uitabColEditable,...
                    'columnWidth',uitabColWidths,...
                    'Tag','uitabFileCalls',...
                    'CellEditCallback',@fpgUitabCellEdit);
    guiD.uitabFileCalls = uitab;

    % raw axes object
    axesPosition = [0,0,0.5,0.4];
    axesUnits = 'normalized';
    axobj = axes('parent',guiD.panelLocalization,...
                    'units',axesUnits,...
                    'Position',axesPosition,...
                    'Tag','axesRaw');
    guiD.axesRaw = axobj;

    % beam axes object
    axesPosition = [0.5,0,0.5,0.4];
    axesUnits = 'normalized';
    axobj = axes('parent',guiD.panelBeam,...
                    'units',axesUnits,...
                    'Position',axesPosition,...
                    'Tag','axesBeam');
    guiD.axesBeam = axobj;

end