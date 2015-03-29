function [  ] = fpgSelectFileCall( a )
%FPGSELECTFILECALL -INTERNAL- select file call for processing

    global control;
    handles = fpgGetHandles();
    
    k = fpgGetCurrent();
    N = fileData(k,'Calls','Count','NoValidation',true);
    if a > N
        err = MException('bats:fileCalls:outOfRange','File call is out of range');
        throw(err);
    end
    control.fpg.a = a;
    set(handles.textIdx,'String',num2str(a));
    fpgRefreshBeam();
    
end