function [t1,t2,t3] = perfTest(N,M)

A = cell(N,1);
A = cellfun(@(a) rand(M),A,'UniformOutput',false);
B = cell(N,1);
C = cell(N,1);
D = cell(N,1);

% regular for
disp('regular for')
tic;
for i = 1:N
    B{i} = dummy(A{i});
end
t1 = toc

% parfor
disp('parfor')
disp('open pool')
tic;
pp = parpool();
toc
disp('process')
tic
parfor i = 1:N
    C{i} = dummy(A{i});
end
t2 = toc
delete(pp);

% cellfun
disp('cellfun')
tic
D = cellfun(@(a) dummy(a),A,'UniformOutput',false);
t3 = toc
end

function Y = dummy(X)
    Y = X.^2;
end