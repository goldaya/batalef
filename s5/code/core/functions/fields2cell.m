function [ C,N ] = fields2cell( S )
%FIELDS2CELL Get the content of structure fields (top level) int cell array
%+ names
    N = fields(S);
    C = cellfun(@(n) S.(n),N,'UniformOutput',false);
end

