class bApplication < handle

	properties
		DataFiles
		ParameterFiles
		FilesParametersObjects
		FilesParametersStandard

	end

	methods
		function [FileIdx] = addFile(me.audioPath,parametersFilePath)
			% create raw data object
			 rawDataObject = bRawData('external',[],[],[],audioPath,[]);

			% create / get parameters object
			if isempty(parametersFilePath)
				parametersObject = FilesParametersStandard;
			else
				[~,pfname] = fileparts(parametersFilePath);
				strmatch(pfname,
				parametersObject = bParameters(me,'file');
				parametersObject.loadFromFile(parametersFilePath);
			end
			% create file object
			% add to data files list
		end
	end
