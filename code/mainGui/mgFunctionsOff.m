function mgFunctionsOff()
%MGFUNCTIONSOFF -INTERNAL- switch off all main gui functions

mgSuInit(false);
mgSoInit(false);
mgTmInit(false);
mgRmInit(false);
zoom('off');
pan('off');
datacursormode('off');

end
