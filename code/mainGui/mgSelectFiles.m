function mgSelectFiles(K)

	global filesObject;
	nk = appData('Files','Count');
	for k = 1:nk
		filesObject(k).selected = ~isempty(find(K==k,1));
	end

end	
