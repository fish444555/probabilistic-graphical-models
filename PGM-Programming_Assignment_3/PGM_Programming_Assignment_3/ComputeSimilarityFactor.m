function factor = ComputeSimilarityFactor (images, K, i, j)
% This function computes the similarity factor between two character images
% in one word --- which characters is given by indices i and j (a
% description of how the factor should be computed is given below).
%
% Input:
%   images: A struct array of character images from one word.
%   K: The alphabet size.
%   i,j: The scope of that factor. That is, you should construct a factor
%     between characters i and j in the images array.
%
% Output:
%   factor: The similarity factor between these two characters. For any
%     assignment C_i != C_j, the factor value should be one. For any
%     assignment C_i == C_j, the factor value should be
%     ImageSimilarity(I_i, I_j) --- ie, the computed value given by
%     ImageSimilarity.m on the two images.
%
% Copyright (C) Daphne Koller, Stanford University, 2012


%% Notice
% You could use find in octave to compare to columns for equality. 
% IndexToAssignment can come in handy as well 

% "Darin" from our previous 
% course explained this nicely as follows "The idea behind 
% ComputeSimilarityFactor is to compare two images with indices i and j 
% using ImageSimilarity and to reward or penalize assigning image i and 
% image j to the same character based on image similarity. So the factor 
% matrix that is the output of the function is a scale factor applied to 
% all possible assignments of image i and image j to characters, so if the 
% assignments of image i and image j are to different characters the score 
% is unchanged, but if the assignment is the same the score is scaled by 
% the image similarity, regardless of which character is assigned to both 
% images. Therefore all you need to have as inputs are the images and the 
% indices, not the ImageModel"

% Some had some confusion and posted later that "in the explanation for 
% function, the indices i and j in C_i != C_j are not the same as the 
% input variables i and j."

%% notice end

%% i think
% Maybe when the C_i == C_j, the characters go to themselves, not matter
% what the characters are, so when they have C_i == C_j, the must compute
% the Similar.
%%

factor = struct('var', [], 'card', [], 'val', []);
% Your code here:
factor.var = [i j];
factor.card = [K K];
indx = IndexToAssignment(1:K*K, [K K]);
factor.val = ones(K*K,1);
% factor.val(find(indx(:,1)==indx(:,2))) = ImageSimilarity(images(i).img,images(j).img);
factor.val(indx(:,1)==indx(:,2)) = ImageSimilarity(images(i).img,images(j).img);

end

