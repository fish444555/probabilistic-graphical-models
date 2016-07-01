% Copyright (C) Daphne Koller, Stanford University, 2012

function EU = SimpleCalcExpectedUtility(I)

  % Inputs: An influence diagram, I (as described in the writeup).
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return Value: the expected utility of I
  % Given a fully instantiated influence diagram with a single utility node and decision node,
  % calculate and return the expected utility.  Note - assumes that the decision rule for the 
  % decision node is fully assigned.

  % In this function, we assume there is only one utility node.
  F = [I.RandomFactors I.DecisionFactors];
  U = I.UtilityFactors(1);
  EU = [];
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %% others
  Prod = I.RandomFactors(1);
  for i = 2:length(I.RandomFactors)
      Prod = FactorProduct(I.RandomFactors(i),Prod);
  end
  Prod = FactorProduct(Prod,I.UtilityFactors) ;
%   Prod = FactorProduct(Prod,I.DecisionFactors) ;
% Final = zeros(1,2);
elimi_var = [];
for i = 1:length(I.RandomFactors)
elimi_var = [elimi_var I.RandomFactors(i).var];
end
elimi_var = setdiff(unique(elimi_var),I.DecisionFactors.var);
% for i = 1:length(I.RandomFactors)

    Final = VariableElimination(Prod,elimi_var);
%     Final = Final+temp.val;
% end
  EU = sum(Final.val.*I.DecisionFactors.val);
%   EU  = max(Final.val);
  %% other end
 
  
  
end
