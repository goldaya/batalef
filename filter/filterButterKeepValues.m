function [  ] = filterButterKeepValues( type,order,f1,f2 )
%FILTERBUTTERKEEPVALUES put values in parameters array

    setParam('filter:butter:type',type);
    setParam('filter:butter:order',order);
    setParam('filter:butter:f1',f1/1000);
    setParam('filter:butter:f2',f2/1000);

end

