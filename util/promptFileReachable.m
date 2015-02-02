function [ isReachable ] = promptFileReachable( k )
%PROMPTFILEREACHABLE Check that a file is reachcble, and prompt path change
%if not

        try
            audioinfo(fileData(k,'Fullpath'));
            isReachable = true;
        catch err
            if strcmp(err.identifier,'MATLAB:audiovideo:audioinfo:fileNotFound')
                A = questdlg('Would you like to change the path?','File unreachable','Yes','No','Yes');
                if strcmp(A,'Yes')
                    mgChangeFilePathName(k);
                    isReachable = promptFileReachable(k);
                else
                    isReachable = false;
                end
            else
                throw(err);
            end
        end

end

