function factors = ChooseTopSimilarityFactors (allFactors, F)
% This function chooses the similarity factors with the highest similarity
% out of all the possibilities.
%
% Input:
%   allFactors: An array of all the similarity factors.
%   F: The number of factors to select.
%
% Output:
%   factors: The F factors out of allFactors for which the similarity score
%     is highest.
%
% Hint: Recall that the similarity score for two images will be in every
%   factor table entry (for those two images' factor) where they are
%   assigned the same character value.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

% If there are fewer than F factors total, just return all of them.
if (length(allFactors) <= F)
    factors = allFactors;
    return;
end

% Your code here:
% factors = allFactors; %%% REMOVE THIS LINE
n = length(allFactors);
K = allFactors(1).card(1);
indx = IndexToAssignment(1:K*K, [K K]);
% factor.val = ones(K*K,1);
% factor.val(find(indx(:,1)==indx(:,2))) = ImageSimilarity(images(i).img,images(j).img);
temp = zeros(n,1);
for i = 1:n
    temp(i,1) = sum(allFactors(i).val(indx(:,1)==indx(:,2)));
    % = ImageSimilarity(images(i).img,images(j).img);
end
[temp ind]= sort(temp,'descend');
factors = repmat(struct('var', [], 'card', [], 'val', []), F, 1);
for i = 1:F
    factors(F+1-i) = allFactors(ind(i));
end
end

