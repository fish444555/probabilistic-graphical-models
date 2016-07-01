function phenotypeFactor = constructSigmoidPhenotypeFactor(alleleWeights, geneCopyVarOneList, geneCopyVarTwoList, phenotypeVar)
% This function takes a cell array of alleles' weights and constructs a 
% factor expressing a sigmoid CPD.
%
% You can assume that there are only 2 genes involved in the CPD.
%
% In the factor, for each gene, each allele assignment maps to the allele
% whose weight is at the corresponding location.  For example, for gene 1,
% allele assignment 1 maps to the allele whose weight is at
% alleleWeights{1}(1) (same as w_1^1), allele assignment 2 maps to the
% allele whose weight is at alleleWeights{1}(2) (same as w_2^1),....  
% 
% You may assume that there are 2 possible phenotypes.
% For the phenotypes, assignment 1 maps to having the physical trait, and
% assignment 2 maps to not having the physical trait.
%
% THE VARIABLE TO THE LEFT OF THE CONDITIONING BAR MUST BE THE FIRST
% VARIABLE IN THE .var FIELD FOR GRADING PURPOSES
%
% Input:
%   alleleWeights: Cell array of weights, where each entry is an 1 x n 
%   of weights for the alleles for a gene (n is the number of alleles for
%   the gene)
%   geneCopyVarOneList: m x 1 vector (m is the number of genes) of variable 
%   numbers that are the variable numbers for each of the first parent's 
%   copy of each gene (numbers in this list go in the .var part of the
%   factor)
%   geneCopyVarTwoList: m x 1 vector (m is the number of genes) of variable 
%   numbers that are the variable numbers for each of the second parent's 
%   copy of each gene (numbers in this list go in the .var part of the
%   factor) -- Note that both copies of each gene are from the same person,
%   but each copy originally came from a different parent
%   phenotypeVar: Variable number corresponding to the variable for the 
%   phenotype (goes in the .var part of the factor)
%
% Output:
%   phenotypeFactor: Factor in which the values are the probabilities of 
%   having each phenotype for each allele combination (note that this is 
%   the FULL CPD with no evidence observed)

phenotypeFactor = struct('var', [], 'card', [], 'val', []);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INSERT YOUR CODE HERE
% Note that computeSigmoid.m will be useful for this function.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  

% Fill in phenotypeFactor.var.  This should be a 1-D row vector.
% Fill in phenotypeFactor.card.  This should be a 1-D row vector.
temp1 = geneCopyVarOneList(:)';
temp2 = geneCopyVarTwoList(:)';
phenotypeFactor.var = [phenotypeVar temp1 temp2];
numAlleles = length(phenotypeFactor.var);
phenotypeFactor.card(1) = 2;
for i = 1:numAlleles-1-length(temp2)
    phenotypeFactor.card = [phenotypeFactor.card length(temp1)];
end
for i = numAlleles-length(temp2):numAlleles-1
    phenotypeFactor.card = [phenotypeFactor.card length(temp2)];
end
phenotypeFactor.val = zeros(1, prod(phenotypeFactor.card));
assignments = IndexToAssignment(1:length(phenotypeFactor.val),phenotypeFactor.card);
temp1 = alleleWeights{1};
temp2 = alleleWeights{2};
assignments = assignments(:,2:end);
for i = 1:2:length(phenotypeFactor.val)-1
    phenotypeFactor.val(1,i) = computeSigmoid(temp1(1)*((assignments(i,1)==1)+...
        (assignments(i,3)==1))+temp1(2)*((assignments(i,1)==2)+(assignments(i,3)==2))...
        +temp2(1)*((assignments(i,2)==1)+(assignments(i,4)==1))+temp2(2)*...
        ((assignments(i,2)==2)+(assignments(i,4)==2)));
    phenotypeFactor.val(1,i+1) = 1-phenotypeFactor.val(1,i);
end
% Replace the zeros in phentoypeFactor.val with the correct values.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%