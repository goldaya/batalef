function [  ] = mgRefreshDisplay(  )
%MGREFRESHDISPLAY Refresh slider and axes display

    mgSetSlider();
    mgRefreshAxes();
    mgRefresh_textDisplayedFile();

end

