function [ str ] = seq2string( seq )
%SEQ2STRING convert a seq of elements into a comma seperated string

    for t=1:length(seq)
        
        if seq(t)==0
            tStr = '~';
        else
            tStr = num2str(seq(t));
        end
        
        if t==1
            str = tStr;
        else
            str=strcat(str,', ',tStr);
        end
        
    end    

end

