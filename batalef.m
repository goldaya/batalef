
disp(' ');
disp('  Starting BATALEF');

% change working folder
batFolder = fileparts(which('batalef'));
currFolder = pwd;
cd(batFolder);
disp(' ');
disp(strcat(['  Changed working directory to: ',batFolder]));
    
% update from git
disp(' ');
addpath('git');
load('user/gitSettings.mat')
updateFromGit();
    
% add batalef to path 
disp(' ');
disp('  Adding batalef to path');
addpath(genpath(batFolder));

% update /user from /common
disp('  Making sure /user does not miss anything');
updateUserFromCommon();

% restore working folder
cd(currFolder);
disp(' ');
disp(strcat(['  Restored working directory to: ',batFolder]));
clear currFolder;
clear batFolder;

% constants
disp(' ');
disp('  Initializing constants');
initC();

% global structures
disp('  Initializing global structures');
initB();    

% go gui :)
disp('  Starting GUI...');
mainGUI();

% FINISHED
disp(' ');
disp('  Finished batalef startup');
disp(' ');
