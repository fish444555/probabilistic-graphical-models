function test_temp


%% OptimizeMEU part 1 
% this part cannot pass the test set, but pass the submit task
% this part did not think about the relation between parents and child
% Copyright (C) Daphne Koller, Stanford University, 2012

%function [MEU OptimalDecisionRule] = OptimizeMEU( I )

  % Inputs: An influence diagram I with a single decision node and a single utility node.
  %         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
  %              the child variable = D.var(1)
  %         I.DecisionFactors = factor for the decision node.
  %         I.UtilityFactors = list of factors representing conditional utilities.
  % Return value: the maximum expected utility of I and an optimal decision rule 
  % (represented again as a factor) that yields that expected utility.
  
  % We assume I has a single decision node.
  % You may assume that there is a unique optimal decision.
  D = I.DecisionFactors(1);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % YOUR CODE HERE...
  % 
  % Some other information that might be useful for some implementations
  % (note that there are multiple ways to implement this):
  % 1.  It is probably easiest to think of two cases - D has parents and D 
  %     has no parents.
  % 2.  You may find the Matlab/Octave function setdiff useful.
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
  
%   ass = IndexToAssignment(1:prod(I.UtilityFactors.card), I.UtilityFactors.card);
  EUF = CalculateExpectedUtilityFactor( I );
  if(length(I.DecisionFactors)==1) % did not have parent
      ass = IndexToAssignment(1:2^length(I.DecisionFactors.val), 2*ones(1,length(I.DecisionFactors.val)));
%       ass = IndexToAssignment(1:2^length(I.DecisionFactors.val), 2*ones(1,length(I.DecisionFactors.val)));
      ass = ass-1;
      t_val = [];
      for i = 1:size(ass,1)
          if(sum(ass(i,:)==0))==(sum(ass(i,:)==1))
              t_val = [t_val;ass(i,:)];
          end
      end
      val = zeros(size(t_val,1),1);
      for i = 1:size(t_val,1)
          val(i) = sum(EUF.val.*t_val(i,:));
      end
      
      [MEU temp] = max(val);
      I.DecisionFactors.var = sort(I.DecisionFactors.var);
      I.DecisionFactors.val = t_val(temp,:);
      OptimalDecisionRule = I.DecisionFactors;
  else % have parent
      ass = IndexToAssignment(1:2^length(I.DecisionFactors.val), 2*ones(1,length(I.DecisionFactors.val)));
end
%% OptimizeMEU part 1 end



%% %% OptimizeMEU part 2
% this part pass all the test set , but fail to pass the submit set
% different from the first part, this past think about the relation 
% between parents and child

% Copyright (C) Daphne Koller, Stanford University, 2012

% function [MEU OptimalDecisionRule] = OptimizeMEU( I )

% Inputs: An influence diagram I with a single decision node and a single utility node.
%         I.RandomFactors = list of factors for each random variable.  These are CPDs, with
%              the child variable = D.var(1)
%         I.DecisionFactors = factor for the decision node.
%         I.UtilityFactors = list of factors representing conditional utilities.
% Return value: the maximum expected utility of I and an optimal decision rule
% (represented again as a factor) that yields that expected utility.

% We assume I has a single decision node.
% You may assume that there is a unique optimal decision.
D = I.DecisionFactors(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% YOUR CODE HERE...
%
% Some other information that might be useful for some implementations
% (note that there are multiple ways to implement this):
% 1.  It is probably easiest to think of two cases - D has parents and D
%     has no parents.
% 2.  You may find the Matlab/Octave function setdiff useful.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%   ass = IndexToAssignment(1:prod(I.UtilityFactors.card), I.UtilityFactors.card);
EUF = CalculateExpectedUtilityFactor( I );
if(length(I.DecisionFactors.var)==1) % did not have parent
    ass = IndexToAssignment(1:prod(I.DecisionFactors.card), I.DecisionFactors.card);
    %       ass = IndexToAssignment(1:2^length(I.DecisionFactors.val), 2*ones(1,length(I.DecisionFactors.val)));
    %       ass = ass-1;
    tc_val = [];
    t_val = [];
    for i = 1:size(ass,1)
        for j = 1:size(ass,2)
            temp = [zeros(1,ass(i,j)-1),1];
            minu=I.UtilityFactors.card(j)-size(temp,2);
            if( minu>0 )
                temp = [temp zeros(1,minu)];
            end
            tc_val = [tc_val temp];
            
        end
        
        t_val = [t_val;tc_val];
        tc_val = [];
        %           if(sum(ass(i,:)==0))==(sum(ass(i,:)==1))
        %               t_val = [t_val;ass(i,:)];
        %           end
    end
    val = zeros(size(t_val,1),1);
    for i = 1:size(t_val,1)
        val(i) = sum(EUF.val.*t_val(i,:));
    end
    
    [MEU temp] = max(val);
    I.DecisionFactors.var = sort(I.DecisionFactors.var);
    I.DecisionFactors.val = t_val(temp,:);
    OptimalDecisionRule = I.DecisionFactors;
else % have parent
    %       ass = IndexToAssignment(1:2^length(I.DecisionFactors.val), 2*ones(1,length(I.DecisionFactors.val)));
    ass = IndexToAssignment(1:prod(I.DecisionFactors.card), I.DecisionFactors.card);
    t_arr = zeros(1,size(EUF.val,2));
    MEU = 0;
    for i = 1:I.DecisionFactors.card(1)
        idx = find(i==ass(:,1));
        t_EUF = zeros(1,size(EUF.val,2));
        t_EUF(idx) = EUF.val(idx);
%         v = GetValueOfAssignment(EUF, ass);
        
        [t_MEU temp] = max(t_EUF);
        MEU = t_MEU+MEU;
        t_arr(temp) = 1;
    end
    I.DecisionFactors.var = sort(I.DecisionFactors.var);
    I.DecisionFactors.val = t_arr;
    OptimalDecisionRule = I.DecisionFactors;
    
end
end
%% 