function mcgInit( fig )
%MCGINIT Summary of this function goes here
%   Detailed explanation goes here

    guiD = guidata(fig);
    
    uitabPosition = [0.05,0.05,0.9,0.9];
    uitabUnits = 'normalized';
    uitabColEditable = logical([1 1 1 1 1 1]);
    uitabColNames = {'Use in Localiztion','Use in Beam','X','Y','Z','Gain'};
    uitabColFormats = {'logical','logical','numeric','numeric','numeric','numeric'};
    
    uitab = uitable('parent',guiD.panelTable,...
                    'units',uitabUnits,...
                    'Position',uitabPosition,...
                    'columnname',uitabColNames,...
                    'columnformat',uitabColFormats,...
                    'columnEditable',uitabColEditable,...
                    'Tag','tableMics');
    
    guiD.tableMics = uitab;
    guidata(fig,guiD);
    
    
end

