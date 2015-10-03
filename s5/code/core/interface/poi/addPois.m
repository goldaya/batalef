function addPois( k,j,C )
%ADDPOIS Create points of interest

    global control;
    control.app.file(k).channel(j).addPois(C);

end

