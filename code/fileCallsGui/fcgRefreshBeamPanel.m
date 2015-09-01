function fcgRefreshBeamPanel()
%FCGREFRESHBEAMPANEL Refresh the call specific data (beam data)

    fcgPopulatePowersMatrix();
    fcgPlotRaw();
    fcgPlotBeam();
    
end

