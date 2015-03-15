function [ overwrite ] = askFileOverwrite( path, name )
%ASKFILEOVERWRITE Summary of this function goes here
%   Detailed explanation goes here

    global control;
    global c;
    
    Q{1} = strcat('File "',path,name,'" is being processed by you. Would you like to overwrite? [Yes,No]');
    Q{2} = 'Only this time or throughout sesssion? [Once\Keep]';
    title = 'Overwrite';
    if control.overwriteFile == c.yes
        D{1} = 'Yes';
        D{2} = 'Once';
    elseif control.overwriteFile == c.no
        D{1} = 'No';
        D{2} = 'Once';
    elseif control.overwriteFile == c.always
        D{1} = 'Yes';
        D{2} = 'Keep';
    elseif control.overwriteFile == c.never
        D{1} = 'No';
        D{2} = 'Keep';
    else
        D{1} = '';
        D{2} = '';
    end
    
    A = inputdlg(Q,title,[1,70],D);
    
    if isempty(A)
        overwrite = c.no;
    elseif strcmp(A{1},'Yes');
        if strcmp(A{2},'Keep')
            overwrite = c.always;
        else
            overwrite = c.yes;
        end
    elseif strcmp(A{1},'No')
        if strcmp(A{2},'Keep')
            overwrite = c.never;
        else
            overwrite = c.no;
        end
    else
        overwrite = c.no;
    end       
    

end

