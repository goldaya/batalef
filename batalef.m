%gitCheckout('master');

%%%
disp(' ');
initG();
disp(' ');


disp(' ');
disp('  Starting BATALEF');
disp(' ');
disp('  Initializing constants');

%%%
initC();

disp('  Initializing global structures');

%%%
initB();    

disp(' ');
disp('  Starting GUI...');
disp(' ');

%%%
mainGUI();