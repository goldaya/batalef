function mcgChangeGains( G )
%MCGCHANGEGAINS Summary of this function goes here
%   Detailed explanation goes here

    global control;
    
    if size(G,1)==control.mcg.n
        % OK
    elseif size(G,2)==control.mcg.n
        G = transpose(G);
    else
        errordlg('Mismatch in number of channels');
        return;
    end
    [~,tableObj] = mcgGetHandles('tableMics');
    D = get(tableObj, 'Data');
    GCell = num2cell(G);
    D(:,6) = GCell;
    set(tableObj,'Data',D); 
    
end

