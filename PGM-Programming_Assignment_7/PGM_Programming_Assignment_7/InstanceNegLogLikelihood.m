% function [nll, grad] = InstanceNegLogLikelihood(X, y, theta, modelParams)
% returns the negative log-likelihood and its gradient, given a CRF with parameters theta,
% on data (X, y).
%
% Inputs:
% X            Data.                           (numCharacters x numImageFeatures matrix)
%              X(:,1) is all ones, i.e., it encodes the intercept/bias term.
% y            Data labels.                    (numCharacters x 1 vector)
% theta        CRF weights/parameters.         (numParams x 1 vector)
%              These are shared among the various singleton / pairwise features.
% modelParams  Struct with three fields:
%   .numHiddenStates     in our case, set to 26 (26 possible characters)
%   .numObservedStates   in our case, set to 2  (each pixel is either on or off)
%   .lambda              the regularization parameter lambda
%
% Outputs:
% nll          Negative log-likelihood of the data.    (scalar)
% grad         Gradient of nll with respect to theta   (numParams x 1 vector)
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

function [nll, grad] = InstanceNegLogLikelihood(X, y, theta, modelParams)

% featureSet is a struct with two fields:
%    .numParams - the number of parameters in the CRF (this is not numImageFeatures
%                 nor numFeatures, because of parameter sharing)
%    .features  - an array comprising the features in the CRF.
%
% Each feature is a binary indicator variable, represented by a struct
% with three fields:
%    .var          - a vector containing the variables in the scope of this feature
%    .assignment   - the assignment that this indicator variable corresponds to
%    .paramIdx     - the index in theta that this feature corresponds to
%
% For example, if we have:
%
%   feature = struct('var', [2 3], 'assignment', [5 6], 'paramIdx', 8);
%
% then feature is an indicator function over X_2 and X_3, which takes on a value of 1
% if X_2 = 5 and X_3 = 6 (which would be 'e' and 'f'), and 0 otherwise.
% Its contribution to the log-likelihood would be theta(8) if it's 1, and 0 otherwise.
%
% If you're interested in the implementation details of CRFs,
% feel free to read through GenerateAllFeatures.m and the functions it calls!
% For the purposes of this assignment, though, you don't
% have to understand how this code works. (It's complicated.)

featureSet = GenerateAllFeatures(X, modelParams);

% Use the featureSet to calculate nll and grad.
% This is the main part of the assignment, and it is very tricky - be careful!
% You might want to code up your own numerical gradient checker to make sure
% your answers are correct.
%
% Hint: you can use CliqueTreeCalibrate to calculate logZ effectively.
%       We have halfway-modified CliqueTreeCalibrate; complete our implementation
%       if you want to use it to compute logZ.

nll = 0;
grad = zeros(size(theta));
%%%
% Your code here:
%% others
%Build Factorss
%init
FeatureCounts = zeros(size(theta));
numCharacters = length(y);
for i=1:numCharacters - 1
    F(i) = struct ('var', [i], 'card', [26], 'val', zeros(1,26));
    FF(i) = struct ('var', [i,i+1], 'card', [26,26], 'val', zeros(1,26*26));
end
F(numCharacters) = struct ('var', [numCharacters], 'card', [26], 'val', zeros(1,26));
Factors = [F FF];
for i=1:length(featureSet.features)
    %FeatureCount
    if any(y(featureSet.features(i).var) ~= featureSet.features(i).assignment) == 0 %match
        FeatureCounts(featureSet.features(i).paramIdx) = 1;
    end
    FactorIdx = FindFactor(Factors, featureSet.features(i).var);
    idx = AssignmentToIndex(featureSet.features(i).assignment, Factors(FactorIdx).card);
    Factors(FactorIdx).val(idx) = Factors(FactorIdx).val(idx) + theta(featureSet.features(i).paramIdx);
    
    % if (length(featureSet.features(i).var) == 1) % single
    % idx = AssignmentToIndex(featureSet.features(i).assignment, F(featureSet.features(i).var).card);
    % F(featureSet.features(i).var).val(idx) = F(featureSet.features(i).var).val(idx) + theta(featureSet.features(i).paramIdx);
    % F(featureSet.features(i).var)
    % tmpFactor = struct ('var', featureSet.features(i).var, 'card', [26], 'val', zeros(1,26));
    % tmpFactor = SetValueOfAssignment(tmpFactor, featureSet.features(i).assignment, theta(featureSet.features(i).paramIdx));
    % F(featureSet.features(i).var) = FactorSum(F(featureSet.features(i).var),tmpFactor);
    % end
    % if (length(featureSet.features(i).var) == 2)
    % idx = AssignmentToIndex(featureSet.features(i).assignment, FF(featureSet.features(i).var(1)).card);
    % FF(featureSet.features(i).var(1)).val(idx) = FF(featureSet.features(i).var(1)).val(idx) + theta(featureSet.features(i).paramIdx);
    % tmpFactor = struct ('var', featureSet.features(i).var, 'card', [26,26], 'val', zeros(1,26*26));
    % tmpFactor = SetValueOfAssignment(tmpFactor, featureSet.features(i).assignment, theta(featureSet.features(i).paramIdx));
    % FF(featureSet.features(i).var(1)) = FactorSum(FF(featureSet.features(i).var(1)),tmpFactor);
    
    % end
end
WeightedFeatureCounts = FeatureCounts .* theta;
RegularizationCost = sum(theta .^2) * modelParams.lambda / 2 ;
RegularizationGradient = theta * modelParams.lambda;

for i=1:length(Factors)
    Factors(i).val = exp(Factors(i).val);
end
P = CreateCliqueTree(Factors);
[CT, logZ] = CliqueTreeCalibrate(P, 0);

% ModelFeatureCounts
ModelFeatureCounts = zeros(size(theta));
for i = 1:length(Factors)
    for x = 1:length(CT.cliqueList)
        if length(intersect(CT.cliqueList(x).var, Factors(i).var)) == length(Factors(i).var)
            V = setdiff( CT.cliqueList(x).var, Factors(i).var);
            Factors(i) = FactorMarginalization(CT.cliqueList(x), V);
            s = sum(Factors(i).val);
            Factors(i).val = Factors(i).val ./ s;
            break;
        end
    end
end
for i=1:length(featureSet.features)
    FactorIdx = FindFactor(Factors, featureSet.features(i).var);
    idx = AssignmentToIndex(featureSet.features(i).assignment, Factors(FactorIdx).card);
    ModelFeatureCounts(featureSet.features(i).paramIdx) = ModelFeatureCounts(featureSet.features(i).paramIdx) + Factors(FactorIdx).val(idx);
end
nll = logZ - sum(WeightedFeatureCounts) + RegularizationCost;
grad = ModelFeatureCounts - FeatureCounts + RegularizationGradient;
end

function idx = FindFactor(Factors, var)
for i=1:length(Factors)
    if length(Factors(i).var) == length(var)
        if length(Factors(i).var) == length(intersect(Factors(i).var,var))
            idx = i;
            break;
        end
    end
end
%% others end

end
