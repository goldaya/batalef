function [ bestValues, bestAccuracy ] = geneticBeam( nInitial, nSurvivors, mutationProb, mutationFactor, micsAzimuth,micsElevation,powerAtMics, maxIntensity, widthBoundry, accuracy )
%GENETICBEAM Summary of this function goes here
%   Detailed explanation goes here

    bestValues = [];
    
    % create an initial population
    I = rand(nInitial,1).*maxIntensity;
    W = rand(nInitial,1).*diff(widthBoundry) - widthBoundry(1);
    A = rand(nInitial,1).*360 - 180;
    E = rand(nInitial,1).*180 - 90;
    
    % initial population
    pop = [I,W,A,E];
    
    % compute fitness - consider changing arrayfun with matrix computation
    F = genComputeFitness( pop, micsAzimuth, micsElevation, powerAtMics );
    %F = arrayfun(@(i,w,a,e) genComputeFitness( i,w,a,e,micsAzimuth,micsElevation,powerAtMics),pop(:,1),pop(:,2),pop(:,3),pop(:,4));
    
    while min(F) > accuracy
        
        counter = counter + 1;
        if counter > maxIterations
            return
        end
        
        % rescue top specimans from oblivion
        p = 100 - min([nSurvivors / size(pop,1),1])*100;
        surv = pop(F<=prcntile(F,p),:);
        
        % mate and mutate
        pop = genMateAndMutate(survivors,mutationProbability,mutationFactor);
        %pop = cell2mat(cellfun(@(specimen) genMateAndMutate(specimen, surv, mutationProb, mutationFactor),num2cell(surv,2)));
    
        % compute fitness
        F = genComputeFitness( pop, micsAzimuth, micsElevation, powerAtMics );
        % F = arrayfun(@(i,w,a,e) genComputeFitness( i,w,a,e,micsAzimuth,micsE7levation,powerAtMics),pop(:,1),pop(:,2),pop(:,3),pop(:,4));
    end
    
    [bestAccuracy, bestInstance] = min(F);
    bestValues = pop(bestInstance,:);    

end


function F = genComputeFitness( pop, MA, ME, MP )
    
    nP = size(pop,1);
    nM = size(pop,2);

    IX  = log(pop(:,1))*ones(1,nM);
    WX  = 2.*(pop(:,2)*ones(1,nM)).^2;
    AX  = pop(:,3)*ones(1,nM);
    EX  = pop(:,4)*ones(1,nM);
    MAX = ones(nP,1)*MA';
    MEX = ones(nP,1)*ME';
    MPX = ones(nP,1)*log(MP)';

    F  = norm( ((AX-MAX).^2 + (EX-MEX).^2).*IX./(2*W) + MPX );
        
end

function pop = genMateAndMutate(parents,mutationProbability,mutationFactor)
    % [I,W,A,E] = parents
    m = size(parents,1);
    for i =1:4
        B = parents(:,i)*ones(1,m);
        R = rand(m,m);
        D = B.*R + B'.*(1-R);
        % mutate
        D = (ceil(rand(m,m)-1+mutationProbability).*(rand(m,m)-0.5).*2.*mutationFactor + 1).*D;
        
        pop(:,i) = reshape(D,[m^2,1]);
    end
    pop = D;
end


%{
function [ fitness ] = genComputeFitness( i,w,a,e,micsAzimuth,micsElevation,powerAtMics )
%GENCOMPUTEFITNESS Compute fitness by computing log gaussian impacts vs.
%log measured impacts on microphones

    alpha = log(i)/(2*w^2);
    fitness = norm(((micsAzimuth-a).^2 + (micsElevation-e).^2).*alpha+log(powerAtMics));
    
end

function [family] = genMateAndMutate(specimen, surv, mutationProb, mutationFactor)
    family = cellfun(@(spouse) genMateMutateKid(specimen,spouse,mutationProb,mutationFactor),num2cell(surv,2));
end

function kid = genMateMutateKid(papa1,papa2,mutationProb,mutationFactor)
    r = rand(1);
    kid = r*papa1 + (1-r)*papa2;
    for i = 1:4
        if rand(1) < mutationProb
            kid(i) = kid(i) + (rand(1)*2 - 1)*mutationFactor;
        end
    end
    
end
%}
