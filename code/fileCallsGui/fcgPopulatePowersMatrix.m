function fcgPopulatePowersMatrix(  )
%FCGPOPULATEPOWERSMATRIX Put the current file-call's powers matrix on
%screen
    
    [k,a] = fcgGetCurrent();
    uitab = getHandles('fcg','uitabPowers');
    if a > 0;
        beam = fileCallData(k,a,'BeamStructure');
        D = [num2cell(beam.micsUsed),num2cell(beam.powers)];
    else
        D = [];
    end
    set(uitab,'Data',D);

end

