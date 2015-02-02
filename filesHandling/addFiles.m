function addFiles(  )
%ADDFILES Open files and add the data to dataObject
    global control c;
    
    control.overwriteFile = c.ask;
    
    [files,path] = uigetfile({'*.wav';'*.WAV'},'MultiSelect','on');

    if iscell(files) % multiple files
        s = size(files);
        l = s(2);
        for i=1:l
            addDataFromFile( path, files{1,i} );
        end                
    elseif  files == 0 % user canceled  - do nothing
    
    else % single file
        addDataFromFile(path, files);
    end
end

