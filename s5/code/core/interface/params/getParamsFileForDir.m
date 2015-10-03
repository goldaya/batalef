function [ fullpath ] = getParamsFileForDir( folder, type )
%GETPARAMSFILEFORDIR get the right para,eter file for the directory, and
%ask user when needed

    global control;
    
    switch type
        case 'app'
            ext = '*.bap';
        case 'gui'
            ext = '*.bgp';
        case 'file'
            ext = '*.bfp';
        otherwise
            err = MException('batalef:parameters:objectWrongType',sprintf('Parameters-object type %s is not allowed',type));
            throwAsCaller(err);
    end
    
    F = dir(strcat(folder,filesep(),ext));
    switch size(F,1)
        case 0
            fullpath = control.app.CommonParams.(type);
        case 1
            fullpath = strcat(folder,filesep(),F(1).name);
        otherwise
            str = sprintf('There are several %s parameter files in the working directory. Which one to use?',type);
            a = menu(str,{F.name,'None, use batalef default instead'});
            n = size(F,1);
            if a > n
                fullpath = control.app.CommonParams.(type);
            else
                fullpath = strcat(folder,filesep(),F(a).name);
            end
    end
end

