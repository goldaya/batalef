function mcgChangePositions( M )
%MCGCHANGEPOSITIONS Summary of this function goes here
%   Detailed explanation goes here

    global control;
    
    if size(M,1)~=control.mcg.n
        errordlg('Mismatch in number of channels');
        return;
    end
    [~,tableObj] = mcgGetHandles('tableMics');
    D = get(tableObj, 'Data');
    MCell = num2cell(M);
    D(:,3:5) = MCell;
    set(tableObj,'Data',D);    
    
end

