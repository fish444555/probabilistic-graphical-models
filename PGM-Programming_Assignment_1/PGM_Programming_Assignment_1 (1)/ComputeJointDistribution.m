%ComputeJointDistribution Computes the joint distribution defined by a set
% of given factors
%
%   Joint = ComputeJointDistribution(F) computes the joint distribution
%   defined by a set of given factors
%
%   Joint is a factor that encapsulates the joint distribution given by F
%   F is a vector of factors (struct array) containing the factors 
%     defining the distribution
%

function Joint = ComputeJointDistribution(F)

  % Check for empty factor list
  if (numel(F) == 0)
      warning('Error: empty factor list');
      Joint = struct('var', [], 'card', [], 'val', []);      
      return;
  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE:
% Compute the joint distribution defined by F
% You may assume that you are given legal CPDs so no input checking is required.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 
% % temp_var = [1:numel(F)];
% % temp_card = [];
% % for i = 1:numel(F)
% %     temp_card = [2 temp_card];
% % end
% temp_card = F(1).card;
% temp_var = F(1).var;
% temp_val = F(1).val;
% 
% for i = 1:numel(F)-1
%     v = F(i).var(end);    
%     tvr = unique(cat(2,F(i).var,F(i+1).var));    
%     same_ele = size(cat(2,F(i).var,F(i+1).var))-tvr;
%     tc = [];
%     for j = 1:size(tvr,2)
%         tc = [2 tc];
%     end
%     tvl = zeros(1,prod(tc));
%     indx = find(F(i+1).var == v);
%     assignments = IndexToAssignment(1:length(temp_val), temp_card);
%     assignments2 = IndexToAssignment(1:length(F(i+1).val), F(i+1).card);    
%     assignments3 = IndexToAssignment(1:length(tvl), tc);
%     I = find(assignments2(:,indx)==1);
% %     tvl = 
%     
%     for k = 1:size(tvl,2)
%         for m = 1:length(F(i+1).val)
%             if(assignments(m,:)==assignments3(k,2:end))
%                 break;
%             end
%         end
%         for n = 1:length(F(i+1).val)
%             if(assignments2(n,:)==assignments3(k,1:end-1))
%                 break;
%             end
%         end
%         tvl(k) = temp_val(m)*F(i+1).val(n);
% %         tvl(k) = temp_val(m)*F(i+1).val(k);
% %         tvl(k) = temp_val(find(assignments(1:end,:)==assignments3(k,2:end)))*F(i+1).val(k);
%     end
% %     indxB = AssignmentToIndex(assignments(:, mapB), B.card);
%     temp_val = tvl; 
%     temp_card = tc;
%     temp_var = tvr;
% %     temp_val = F(i).
temp_card = F(1).card;
temp_var = F(1).var;
temp_val = F(1).val;
Joint = struct('var', temp_var, 'card', temp_card, 'val', temp_val); % Returns empty factor. Change this.
for i = 1:numel(F)-1
    Joint = FactorProduct(Joint, F(i+1));
end
% Joint = struct('var', temp_var, 'card', temp_card, 'val', temp_val); % Returns empty factor. Change this.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

