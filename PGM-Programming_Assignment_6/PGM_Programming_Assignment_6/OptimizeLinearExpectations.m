% Copyright (C) Daphne Koller, Stanford University, 2012

function [MEU OptimalDecisionRule] = OptimizeLinearExpectations( I )
% Inputs: An influence diagram I with a single decision node and one or more utility nodes.
%         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
%              the child variable = D.var(1)
%         I.DecisionFactors = factor for the decision node.
%         I.UtilityFactors = list of factors representing conditional utilities.
% Return value: the maximum expected utility of I and an optimal decision rule
% (represented again as a factor) that yields that expected utility.
% You may assume that there is a unique optimal decision.
%
% This is similar to OptimizeMEU except that we will have to account for
% multiple utility factors.  We will do this by calculating the expected
% utility factors and combining them, then optimizing with respect to that
% combined expected utility factor.
MEU = [];
OptimalDecisionRule = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% YOUR CODE HERE
%
% A decision rule for D assigns, for each joint assignment to D's parents,
% probability 1 to the best option from the EUF for that joint assignment
% to D's parents, and 0 otherwise.  Note that when D has no parents, it is
% a degenerate case we can handle separately for convenience.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
flag = zeros(1,length(I.UtilityFactors));
tmax = inf;
tmark = 0;
count = 1;
for count = 1:length(I.UtilityFactors)
    for i = 1:length(I.UtilityFactors)
        if( (flag(i)==0)&&(tmax>length(I.UtilityFactors(i).var)) )
            tmax = length(I.UtilityFactors(i).var);
            tmark = i;
        end        
    end
    temp_I = I;
    temp_I.UtilityFactors = I.UtilityFactors(tmark);
    if(count==1)
        [MEU OptimalDecisionRule] = OptimizeMEU( temp_I );
    else
        temp_I.DecisionFactors.val = OptimalDecisionRule.val;
        tEU = SimpleCalcExpectedUtility(temp_I);
        MEU = MEU+tEU;
    end
    flag(tmark) = 1;
    tmax = inf;        
end
end
