function phenotypeFactor = tconstructSigmoidPhenotypeFactor(alleleWeights, geneCopyVarOneList, geneCopyVarTwoList, phenotypeVar)
phenotypeFactor = struct('var', [], 'card', [], 'val', []);
%% 1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% phenotypeFactor.var = [phenotypeVar, geneCopyVarOneList', geneCopyVarTwoList'];
% phenotypeFactor.card = zeros(1, 1+length(alleleWeights)*length(geneCopyVarOneList));
% phenotypeFactor.card(1) = 2;
% 
% for (i=1:length(alleleWeights))
%   phenotypeFactor.card(i+1) = length(alleleWeights{i});
%   phenotypeFactor.card(i+1+length(alleleWeights)) = length(alleleWeights{i});
% end
% 
% phenotypeFactor.val = zeros(1, prod(phenotypeFactor.card));
% 
% 
% g1NumAlleles = length(alleleWeights{1});
% g2NumAlleles = length(alleleWeights{2});
% 
% for g2c2=1:g2NumAlleles
%     for g1c2=1:g1NumAlleles
%         for g2c1=1:g2NumAlleles
%             for g1c1=1:g1NumAlleles
%                 idx = 2*(g1c1-1+(g2c1-1)*g1NumAlleles+(g1c2-1)*g1NumAlleles*g2NumAlleles+...
%                     (g2c2-1)*g1NumAlleles*g1NumAlleles*g2NumAlleles)+1;
%                 f = alleleWeights{1}(g1c1)+alleleWeights{2}(g2c1)+...
%                     alleleWeights{1}(g1c2)+alleleWeights{2}(g2c2);
%                 phenotypeFactor.val(idx) = computeSigmoid(f);
%                 phenotypeFactor.val(idx+1) = 1 - computeSigmoid(f);
%             end
%         end
%     end
% end
%% 1end

%% 2
% Fill in phenotypeFactor.var.  This should be a 1-D row vector.
numGenes = length(geneCopyVarOneList);
numAlleles = 2;%columns(alleleWeights{1});
phenotypeFactor.var = [phenotypeVar,reshape(geneCopyVarOneList,1,numGenes),reshape(geneCopyVarTwoList,1,numGenes)];
% Fill in phenotypeFactor.card.  This should be a 1-D row vector.
phenotypeFactor.card = [2 repmat(numAlleles,1, numGenes*2)];

phenotypeFactor.val = zeros(1, prod(phenotypeFactor.card));
% Replace the zeros in phentoypeFactor.val with the correct values.
A = IndexToAssignment([1:length(phenotypeFactor.val)],phenotypeFactor.card);
gv1 = A(:,2:numGenes+1); 
gv2 = A(:,numGenes+2:numGenes*2+1);
for i=1:length(phenotypeFactor.val),
	%A(i,1) is pheno; A(i,2:numGenes+1) is geneVar1; A(i,numGenes+2:numGenes*2+1) is geneVar2; 
	z = 0;
	for g = 1:numGenes,
		x1 = alleleWeights{g}(gv1(i,g));
		x2 = alleleWeights{g}(gv2(i,g));
		z = z + x1 + x2;
	end
	if A(i,1) == 1,
		phenotypeFactor.val(i) = computeSigmoid(z);
	else
		phenotypeFactor.val(i) = 1 - computeSigmoid(z);
	end
end
%% 2end
tb =1;