function bmgCreateTable( fig )
%BMGCREATETABLE Summary of this function goes here
%   Detailed explanation goes here

    uitabPosition = [0,0,1,1];
    uitabUnits = 'normalized';
    
    % columns
    N = 7;
    uitabColNames    = cell(1,N);
    uitabColEditable = zeros(1,N);
    uitabColFormats  = cell(1,N);
    uitabColWidths   = cell(1,N);
    
    % usage
    uitabColNames{1}    = 'Use';
    uitabColFormats{1}  = 'logical';
    uitabColEditable(1) = 1;
    uitabColWidths{1}   = 70    ;
    
    % Azimuth
    uitabColNames{2}    = 'Azimuth';
    uitabColEditable(2) = 1;
    uitabColFormats{2}  = 'numeric';
    uitabColWidths{2}   = 70;

    % Elevation
    uitabColNames{3}    = 'Elevation';
    uitabColEditable(3) = 1;
    uitabColFormats{3}  = 'numeric';
    uitabColWidths{3}   = 70;
    
    % Power at mic
    uitabColNames{4}    = 'P. at mic';
    uitabColEditable(4) = 0;
    uitabColFormats{4}  = 'numeric';
    uitabColWidths{4}   = 70;    
    
    % Power after gain compensation
    uitabColNames{5}    = 'P. after gain';
    uitabColEditable(5) = 0;
    uitabColFormats{5}  = 'numeric';
    uitabColWidths{5}   = 70;    
    
    % Power after directionality
    uitabColNames{6}    = 'P. after direct.';
    uitabColEditable(6) = 0;
    uitabColFormats{6}  = 'numeric';
    uitabColWidths{6}   = 70;    
    
    % Power ready for interpolation
    uitabColNames{7}    = 'P. for interp.';
    uitabColEditable(7) = 1;
    uitabColFormats{7}  = 'numeric';
    uitabColWidths{7}   = 70;        

    
    uitabColEditable = logical(uitabColEditable);
    
    uitab = uitable('parent',fig, ...
                    'units',uitabUnits,...
                    'Position',uitabPosition,...
                    'columnName',uitabColNames,...
                    'columnFormat',uitabColFormats,...
                    'columnEditable',uitabColEditable,...
                    'columnWidth',uitabColWidths,...
                    'Tag','uitabBeamData');
    guiD = guidata(fig);
    guiD.uitabBeamData = uitab;
    guidata(fig,guiD);

end

