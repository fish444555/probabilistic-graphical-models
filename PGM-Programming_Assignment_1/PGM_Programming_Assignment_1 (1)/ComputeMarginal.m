%ComputeMarginal Computes the marginal over a set of given variables
%   M = ComputeMarginal(V, F, E) computes the marginal over variables V
%   in the distribution induced by the set of factors F, given evidence E
%
%   M is a factor containing the marginal over variables V
%   V is a vector containing the variables in the marginal e.g. [1 2 3] for
%     X_1, X_2 and X_3.
%   F is a vector of factors (struct array) containing the factors 
%     defining the distribution
%   E is an N-by-2 matrix, each row being a variable/value pair. 
%     Variables are in the first column and values are in the second column.
%     If there is no evidence, pass in the empty matrix [] for E.


function M = ComputeMarginal(V, F, E)

% Check for empty factor list
if (numel(F) == 0)
      warning('Warning: empty factor list');
      M = struct('var', [], 'card', [], 'val', []);      
      return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE:
% M should be a factor
% Remember to renormalize the entries of M!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% M = ObserveEvidence(F, E);
% for i = 1:2:numel(M)%renormalize
%     for j = 1:2:size(M(i).val,2)
%         if(sum(M(i).val(j)+M(i).val(j+1))~=1)        
%             sumf = sum(M(i).val(j)+M(i).val(j+1));
%             M(i).val(j) = M(i).val(j)/sumf;
%             M(i).val(j+1) = M(i).val(j+1)/sumf;
%         end
%     end
% end

% for i = 1:numel(M)%renormalize    
%     for j = 1:2:size(M(i).val,2)
%         idx = find(M(i).var(j))
%         assignments = IndexToAssignment(1:length(M(i).val), M(i).card(j));
%         if(sum(M(i).val(j)+M(i).val(j+1))~=1)        
%             sumf = sum(M(i).val(j)+M(i).val(j+1));
%             M(i).val(j) = M(i).val(j)/sumf;
%             M(i).val(j+1) = M(i).val(j+1)/sumf;
%         end
%     end
% end

for i = 1:size(E, 1),% almost copy the function of ObserveEvidence, the only
    % different is that this function has normalize
    v = E(i, 1); % variable
    x = E(i, 2); % value

    % Check validity of evidence
    if (x == 0),
        warning(['Evidence not set for variable ', int2str(v)]);    
        continue;
    end;

    for j = 1:length(F),
		  % Does factor contain variable?
        indx = find(F(j).var == v);

        if (~isempty(indx)),
        
		  	   % Check validity of evidence
            if (x > F(j).card(indx) || x < 0 ),
                error(['Invalid evidence, X_', int2str(v), ' = ', int2str(x)]);
            end;

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % YOUR CODE HERE
            % Adjust the factor F(j) to account for observed evidence
            % Hint: You might find it helpful to use IndexToAssignment
            %       and SetValueOfAssignment
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            assignments = IndexToAssignment(1:length(F(j).val), F(j).card);
            I = find(assignments(:,indx)~=x);
            for k = 1:size(I,1)
                F(j).val(I(k)) = 0;
            end
            I2 = find(assignments(:,indx)==x);
%             for k = 1:size(I2,1)
%                 F(j).val(I2(k)) = 0;
sumf = sum(F(j).val(I2(:)));
                if( sumf~=1 && sumf~=0 )
%                     sumf = sum(M(i).val(j)+M(i).val(j+1));
                    F(j).val(I2(k)) = F(j).val(I2(k))/sumf;
%                     M(i).val(j+1) = M(i).val(j+1)/sumf;
                end
%             end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

				% Check validity of evidence / resulting factor
            if (all(F(j).val == 0)),
                warning(['Factor ', int2str(j), ' makes variable assignment impossible']);
            end;

        end;
    end;
end;
M = F;

Joint = ComputeJointDistribution(M);
temp = setdiff(Joint.var,V);
for i = 1:size(temp,2)
    Joint = FactorMarginalization(Joint, temp(1,i));
end
M = Joint;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
