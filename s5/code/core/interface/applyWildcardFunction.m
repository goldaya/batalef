function applyWildcardFunction(files,funcName)
%APPLYWILDCARDFUNCTION Apply the specified function on the TS matrix of the
%specified files

    global control;
    N  = length(files);
    Files = control.app.Files(files);
    if appData('ParProc','Allowed')
        parfor i = 1:N
            tentacleAttack(Files{i},funcName);
        end
    else
        for i = 1:N
            tentacleAttack(Files{i},funcName);
        end
    end

end

function tentacleAttack(File,funcName)
    func = str2func(funcName);
    [TS,Fs] = func(File.RawData.getTS([],[]),File.RawData.Fs);
    File.RawData.alter(TS,{'UserFunction',NaN},Fs);
end