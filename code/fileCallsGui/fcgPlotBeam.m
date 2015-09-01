function fcgPlotBeam()
%FCGPLOTBEAM Plot beam if the beam.image exists

    [k,a] = fcgGetCurrent();
    axobj = getHandles('fcg','axesBeam');
    cla(axobj);
    if a < 1
        return;
    end
    
    beam = fileCallData(k,a,'BeamStructure');
    if isfield(beam,'image') && ~isempty(beam.image)
        imagesc(beam.image.azCoors,beam.image.elCoors,beam.image.image,'Parent',axobj);
        set(axobj,'YDir','normal');        
    end
    
end

