function [ fitness ] = genComputeFitness( i,w,a,e,A,E,P )
%GENCOMPUTEFITNESS Compute fitness by computing log gaussian impacts vs.
%log measured impacts on microphones

    alpha = log(i)/(2*w^2);
    fitness = norm(((A-a).^2 + (E-e).^2).*alpha+log(P));
    
end

