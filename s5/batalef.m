function batalef( varargin )
%BATALEF batalef startup script

    % SWITCHES
    gui = false;
    cli = false;
    verbose = false;
    silent = false;
    
    if isempty(varargin)
        gui = true;
    else
        for i = 1:length(varargin)
            switch varargin{i}
                case 'gui'
                    gui = true;
                case 'nogui'
                    gui = false;
                case 'cli'
                    cli = true;
                case '-v'
                    verbose = true;
                case '-s'
                    silent = true;
            end
        end
    end    
    
    % START !!!
    disp(' ');
    disp('  Starting BATALEF');
    batFolder = fileparts(which('batalef'));
    currFolder = pwd;

    % add batalef directories to path 
    disp(' ');
    disp('  Adding batalef directories to path');
    addpath(genpath(batFolder));    

    % initialize batalef
    fprintf('\n  Initializing application object\n')
    global control;
    control = [];
    control.app = bApplication(batFolder,currFolder);
    
    
    % GUI
    if gui
        fprintf('\n  Initializing GUI\n')
        guiParams = getParamsFileForDir( currFolder, 'gui');
        relGuiParamsPath = relativepath(guiParams,currFolder);
        control.gui = bGuiTop(control.app,relGuiParamsPath);
        control.gui.mgInit();
        
    end
            
        
    % FINISHED
    disp(' ');
    disp('  Finished batalef startup');
    disp(' ');
    % warn against alteing files
    disp(' Save/alter files ONLY inside "user" folder.');
    disp(' DO NOT change other batalef files and directories !');    

end

