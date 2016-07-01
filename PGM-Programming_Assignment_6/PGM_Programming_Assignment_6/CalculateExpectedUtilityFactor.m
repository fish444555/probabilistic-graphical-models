% Copyright (C) Daphne Koller, Stanford University, 2012

function EUF = CalculateExpectedUtilityFactor( I )

% Inputs: An influence diagram I with a single decision node and a single utility node.
%         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
%              the child variable = D.var(1)
%         I.DecisionFactors = factor for the decision node.
%         I.UtilityFactors = list of factors representing conditional utilities.
% Return value: A factor over the scope of the decision rule D from I that
% gives the conditional utility given each assignment for D.var
%
% Note - We assume I has a single decision node and utility node.
EUF = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% YOUR CODE HERE...
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

prod = I.RandomFactors(1);
for i = 2:length(I.RandomFactors)
    prod = FactorProduct(prod,I.RandomFactors(i));
end
prod = FactorProduct(prod,I.UtilityFactors);
elimi_var = [];
for i = 1:length(I.RandomFactors)
    elimi_var = [elimi_var I.RandomFactors(i).var]
end
elimi_var = setdiff(unique(elimi_var),I.DecisionFactors.var);
EUF = VariableElimination(prod, elimi_var);

end
