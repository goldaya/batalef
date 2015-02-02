function [  ] = mgMpInit(  )
%MGMPINIT 

    zoom('off');
    pan('off');
    manualPeaksGUI();
    mgAssignAxesFunctions(@mgMpZoom,@mgMpClick);

end

