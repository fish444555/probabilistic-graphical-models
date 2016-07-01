function PS2_RunTests()

    clear;

    constTOL = 1e-6;

    load('PA3Data.mat');
    load('PA3Models.mat');
    load('PA3TestCases.mat');
    load('PA3SampleCases.mat');
    
    
    partNames = validParts();
    partId = promptPart();

    len = length(partNames);
    partNamesAlligned = char( partNames );
    
    resultAll = 1;
    
    for i = 1:len
        if ( partId ~= (len+1) && partId ~= i )
            continue;
        end
    
        switch i
        case 1 
            factors = ComputeSingletonFactors (Part1SampleImagesInput, imageModel);
            result = isequal(Part1SampleFactorsOutput, factors);
        case 2 
            factors = ComputePairwiseFactors (Part2SampleImagesInput, pairwiseModel, imageModel.K);
            result = isequal(Part2SampleFactorsOutput, factors);
        case 3 
            factors = ComputeTripletFactors (Part3SampleImagesInput, tripletList, imageModel.K);
            result = isequal(Part3SampleFactorsOutput, factors);
        case 4 
            factor = ComputeSimilarityFactor (Part4SampleImagesInput, imageModel.K, 1, 2);
            result = isequal(Part4SampleFactorOutput, factor);
            
        case 5 
            factors = ComputeAllSimilarityFactors (Part5SampleImagesInput, imageModel.K);
            result = isequal(Part5SampleFactorsOutput, factors);
        case 6 
            factors = ChooseTopSimilarityFactors (Part6SampleFactorsInput, 2);
            result = isequal(Part6SampleFactorsOutput, factors);
%         case 7 
%             Output.t7 = constructDecoupledGeneticNetwork(TestInput.t7i1, TestInput.t7i2, TestInput.t7i3);
%             result = isEqualTol(TestOutput.t7e1, Output.t7, constTOL);
%         case 8 % ConstructSigmoidPhenotypeFactor
%             % Example 1 (from sampleGeneticNetworks.m)
%             Output.t8 = constructSigmoidPhenotypeFactor(TestInput.t8i1, ...
%                 TestInput.t8i2, TestInput.t8i3, TestInput.t8i4);
% 
%             result = isEqualTol(TestOutput.t8e1, Output.t8, constTOL);
        end % switch
        
        fprintf( [num2str(i), ')', char(9), partNamesAlligned(i,:), '  -----  '] );
        display_result(result);
        
        resultAll = resultAll && result;
    end % for

if resultAll
    fprintf('\nALL CODE IS CORRECT!\n\n')
else
    fprintf('\nSOME CODE IS INCORRECT!\n\n')
end

end % end function 'PS2_RunTests'

function display_result(result)
    if result
        fprintf('Correct answer!\n')
    else
        fprintf('Incorrect answer!\n')
    end
end


function id = homework_id() 
  id = '2';
end

function [partNames] = validParts()
  partNames = { 'ComputeSingletonFactors', ...
                'ComputePairwiseFactors', ...
                'ComputeTripletFactors', ...
                'ComputeSimilarityFactor', ...
                'ComputeAllSimilarityFactors', ...
                'ChooseTopSimilarityFactors'                
              };
end

function srcs = sources()
  % Separated by part
  srcs = { { 'ComputeSingletonFactors.m' }, ...
           { 'ComputePairwiseFactors.m' }, ...
           { 'ComputeTripletFactors.m' }, ...
           { 'ComputeSimilarityFactor.m' }, ...
           { 'ComputeAllSimilarityFactors.m' }, ...
           { 'ChooseTopSimilarityFactors.m' }
         };
end

function ret = isValidPartId(partId)
  partNames = validParts();
  ret = (~isempty(partId)) && (partId >= 1) && (partId <= numel(partNames) + 1);
end

function partId = promptPart()
  fprintf('== Select which part(s) to test:\n', ...
          homework_id());
  partNames = validParts();
  srcFiles = sources();
  for i = 1:numel(partNames)
    fprintf('==   %d) %s [', i, partNames{i});
    fprintf(' %s ', srcFiles{i}{:});
    fprintf(']\n');
  end
  fprintf('==   %d) All of the above \n==\nEnter your choice [1-%d]: ', ...
          numel(partNames) + 1, numel(partNames) + 1);
  selPart = input('', 's');
  partId = str2num(selPart);
  if ~isValidPartId(partId)
    partId = -1;
  end
  
  fprintf('\n\n');
end

function res = isEqualTol(argument1, argument2, toleranceInput)
  res = comparedata(argument1, argument2, [], ...
                struct('displaycontextprogress', 0, 'NumericTolerance', toleranceInput));
end
