%COMPUTEEXACTMARGINALSBP Runs exact inference and returns the marginals
%over all the variables (if isMax == 0) or the max-marginals (if isMax == 1).
%
%   M = COMPUTEEXACTMARGINALSBP(F, E, isMax) takes a list of factors F,
%   evidence E, and a flag isMax, runs exact inference and returns the
%   final marginals for the variables in the network. If isMax is 1, then
%   it runs exact MAP inference, otherwise exact inference (sum-prod).
%   It returns an array of size equal to the number of variables in the
%   network where M(i) represents the ith variable and M(i).val represents
%   the marginals of the ith variable.
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function M = ComputeExactMarginalsBP(F, E, isMax)

% initialization
% you should set it to the correct value in your code
M = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% Implement Exact and MAP Inference.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AV = [];
for x =1:length(F)
    AV = union(AV,F(x).var);
end
M = repmat(struct('var', [], 'card', [], 'val', []),length(AV),1);
CT = CreateCliqueTree(F, E);
if( isMax == 0 )
    CCT = CliqueTreeCalibrate(CT, 0);
else    
    CCT = CliqueTreeCalibrate(CT, 1);
end
for i = 1:length(AV)
    for x = 1:length(CCT.cliqueList)
        if( find(CCT.cliqueList(x).var == i) ~= 0 )
            if( isMax == 0 )
                V = setdiff( CCT.cliqueList(x).var, [i]);
                M(i) = FactorMarginalization(CCT.cliqueList(x), V);            
                M(i).val = M(i).val ./ sum(M(i).val);
            else
                V = setdiff( CCT.cliqueList(x).var, [i]);                
                M(i) = FactorMaxMarginalization(CCT.cliqueList(x), V);            
            end
            break;
        end
    end
end
end
