classdef bFiles < handle

	properties
		List
		ApplicationObject
	end

	properties (Dependent)
		Count
	end

	methods
		function add(audioPath,loadOnCreation,parametersObject)
			% create the raw data object
			rawDataObject = bRawData('external',[],[],[],audioPath,[]);
			if loadOnCreation
				rawDataObject.loadExplicit();
			end

			% create file object
			title = rawDataObject.FileName;
			fileObject = bFile(me.ApplicationObject,title,rawDataObject,parametersObject);

			% add file object to list
			k = me.Count;
			me.List{k,1} = title;
			me.List{k,2} = fileObject;
		end

		function k = getIndex(me,title)
			k = strmatch(title,me.List{:,1});
		end
		function obj = getInstance(me,title)
			k = me.getIndex(title);
			if isempty(k)
				obj = [];
			else
				obj = me.List{k,2};
			end
		end
				

		function k = get.Count(me)
			k = size(me.List,1);
		end
	end

end

