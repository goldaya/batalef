function feInConsole( inputPath, configFile, outputPath )
%FEINCONSOLE Run Feature Extraction on an export file and save

    global control;
    global filesObject;
    
    % load export file
    importFileObjectFromFile( inputPath );
    K = 1:appData('Files','Count');
    
    % run FE
    currentParameters = control.params;
    loadParametersFile( configFile );
    fExtraction(K);
    control.params = currentParameters;
    
    % save export file
    save(outputPath,'filesObject');
    
end

