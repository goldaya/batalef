function [  ] = cgGotoCall( k,j,s )
%CGGOTOCALL Jump to call if exist

    if ~isscalar(k)
        s = k(3);
        j = k(2);
        k = k(1);
    end
    
    if k==0 || j==0 || s==0
        msgbox('No Call');
        return;
    end
    
    try
        validateFileChannelCallIndex(k,j,s);
    catch err
       switch err.identifier
           case 'bats:channelCalls:indexOutOfRange'
               msgbox('No call');
           case 'bats:channels:indexOutOfRange'
               msgbox('No channel');
           case 'bats:files:indexOutOfRange'
               msgbox('No file');
           otherwise
               throw(err)
       end
       return;
    end
    
    global control;
    control.cg.k = k;
    control.cg.j = j;
    control.cg.s = s;
    
    cgShowCall();

end

