function mcgInit( fig )
%MCGINIT Summary of this function goes here
%   Detailed explanation goes here

    
    uitabPosition = [12,175,530,300];
    uitabUnits = 'pixels';
    uitabColEditable = logical([1 1 1 1 1 1]);
    uitabColNames = {'Use in Localiztion','Use in Beam','X','Y','Z','Gain'};
    uitabColFormats = {'logical','logical','numeric','numeric','numeric','numeric'};
    
    uitab = uitable('parent',fig,...
                    'units',uitabUnits,...
                    'Position',uitabPosition,...
                    'columnname',uitabColNames,...
                    'columnformat',uitabColFormats,...
                    'columnEditable',uitabColEditable,...
                    'Tag','tableMics');
    guiD = guidata(fig);
    guiD.tableMics = uitab;
    guidata(fig,guiD);
    
    
end

