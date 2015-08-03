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
    F = arrayfun(@(i,w,a,e) genComputeFitness( i,w,a,e,micsAzimuth,micsElevation,powerAtMics),pop(:,1),pop(:,2),pop(:,3),pop(:,4));
    
    while min(F) > accuracy
        
        counter = counter + 1;
        if counter > maxIterations
            return
        end
        
        % rescue top specimans from oblivion
        p = 100 - min([nSurvivors / size(pop,1),1])*100;
        surv = pop(F<=prcntile(F,p),:);
        
        % mate and mutate
        pop = cell2mat(cellfun(@(specimen) genMateAndMutate(specimen, surv, mutationProb, mutationFactor),num2cell(surv,2)));
    
        % compute fitness
        F = arrayfun(@(i,w,a,e) genComputeFitness( i,w,a,e,micsAzimuth,micsElevation,powerAtMics),pop(:,1),pop(:,2),pop(:,3),pop(:,4));
    end
    
    [bestAccuracy, bestInstance] = min(F);
    bestValues = pop(bestInstance,:);    

end

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