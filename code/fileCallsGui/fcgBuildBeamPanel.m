function fcgBuildBeamPanel(fig)
%FCGBUILDBEAMPANEL File Calls Gui - build the beam data ui items

    guiD = guidata(fig);

    uitabPosition = [0,0.6,1,0.4];
    uitabUnits = 'normalized';

    N = 10;
    uitabColNames = cell(1,N);
    uitabColEditable = zeros(1,N);
    uitabColFormats  = cell(1,N);
    uitabColWidths   = cell(1,N);

    i = 0;

    i = i +1;
    uitabColNames{i}    = 'Mic Usage';
    uitabColEditable(i) = 1;
    uitabColFormats{i}  = 'logical';
    uitabColWidths{i}   = 70;
    
    i = i +1;
    uitabColNames{i}    = 'Mic Rel Azimuth';
    uitabColEditable(i) = 1;
    uitabColFormats{i}  = 'numeric';
    uitabColWidths{i}   = 140;
    
    i = i+1;
    uitabColNames{i}    = 'Mic Rel Elevation';
    uitabColEditable(i) = 1;
    uitabColFormats{i}  = 'numeric';
    uitabColWidths{i}   = 140;
    
    i = i + 1;
    uitabColNames{i}    = 'Distance';
    uitabColEditable(i) = 1;
    uitabColFormats{i}  = 'numeric';
    uitabColWidths{i}   = 140;
    
    i = i + 1;
    uitabColNames{i}    = 'Direct. Angle';
    uitabColEditable(i) = 1;
    uitabColFormats{i}  = 'numeric';
    uitabColWidths{i}   = 140;    

    i = i + 1;
    uitabColNames{i}    = 'Meas. Power';
    uitabColEditable(i) = 0;
    uitabColFormats{i}  = 'numeric';
    uitabColWidths{i}   = 140;

    i = i + 1;
    uitabColNames{i}    = 'Air absorption (dB)';
    uitabColEditable(i) = 1;
    uitabColFormats{i}  = 'numeric';
    uitabColWidths{i}   = 140;

    i = i + 1;
    uitabColNames{i}    = 'Mic Calibration Gain (dB)';
    uitabColEditable(i) = 1;
    uitabColFormats{i}  = 'numeric';
    uitabColWidths{i}   = 180;

    i = i + 1;
    uitabColNames{i}    = 'Mic Direct. Gain (dB)';
    uitabColEditable(i) = 1;
    uitabColFormats{i}  = 'numeric';
    uitabColWidths{i}   = 140;

    i = i + 1;
    uitabColNames{i}    = 'Power after Air + Calib.';
    uitabColEditable(i) = 0;
    uitabColFormats{i}  = 'numeric';
    uitabColWidths{i}   = 180;

    i = i + 1;
    uitabColNames{i}    = 'Power after Direct.';
    uitabColEditable(i) = 0;
    uitabColFormats{i}  = 'numeric';
    uitabColWidths{i}   = 140;

    i = i + 1;
    uitabColNames{i}    = 'Power after all corrections';
    uitabColEditable(i) = 0;
    uitabColFormats{i}  = 'numeric';
    uitabColWidths{i}   = 180;

    uitabColEditable = logical(uitabColEditable);

    uitab = uitable('parent',guiD.panelBeam,...
                    'units',uitabUnits,...
                    'Position',uitabPosition,...
                    'columnname',uitabColNames,...
                    'columnformat',uitabColFormats,...
                    'columnEditable',uitabColEditable,...
                    'columnWidth',uitabColWidths,...
                    'Tag','uitabPowers');

    guiD.uitabPowers = uitab;

    % raw axes object
    axesPosition = [0.05,0.05,0.4,0.5];
    axesUnits = 'normalized';
    axobj = axes('parent',guiD.panelBeam,...
                    'units',axesUnits,...
                    'Position',axesPosition,...
                    'Tag','axesRaw');
    guiD.axesRaw = axobj;

    % beam axes object
    axesPosition = [0.55,0.05,0.4,0.5];
    axesUnits = 'normalized';
    axobj = axes('parent',guiD.panelBeam,...
                    'units',axesUnits,...
                    'Position',axesPosition,...
                    'Tag','axesBeam');
    guiD.axesBeam = axobj;

    guidata(fig,guiD);
end