function overwriteFiles( files )
%OVERWRITEFILES For each file, save the content of the raw data object's TS into its path 

    global control;
    if control.app.parProcAllowed
        parfor i = 1:length(files)
            doOverwrite(files,i);
        end
    else
        for i = 1:length(files)
            doOverwrite(files,i);
        end
    end

end

function doOverwrite(V,i)

    global control;
    k = V(i);
    control.app.file(k).overwriteAudio();
    
end