function PS2_RunTests()
    clear;
    constTOL = 1e-6;
    load('PA4Sample.mat');
%     load('PA3Models.mat');
%     load('PA3TestCases.mat');
%     load('PA3SampleCases.mat');
    
    
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
            P = ComputeInitialPotentials (InitPotential.INPUT);
            result = isequal(InitPotential.RESULT, P);
        case 2 
            tic;
            [ii, j] = GetNextCliques(GetNextC.INPUT1, GetNextC.INPUT2);
            toc;
            result = isequal(ii, GetNextC.RESULT1)&isequal(j, GetNextC.RESULT2);
        case 3 
            P = CliqueTreeCalibrate(SumProdCalibrate.INPUT, 0);
            result = isequal(SumProdCalibrate.RESULT, P);
        case 4 
            M = ComputeExactMarginalsBP(SixPersonPedigree, [], 0);            
            result = isequal(ExactMarginal.RESULT, M);            
        case 5 
            B = FactorMaxMarginalization(FactorMax.INPUT1, FactorMax.INPUT2);
            result = isequal(FactorMax.RESULT, B);
        case 6 
            P = CliqueTreeCalibrate(MaxSumCalibrate.INPUT, 1);
            result = isequal(MaxSumCalibrate.RESULT, P);
        case 7 
            M = ComputeExactMarginalsBP(MaxMarginals.INPUT, [], 1);
            result = isequal(MaxMarginals.RESULT, M);
        case 8 
            A = MaxDecoding( MaxDecoded.INPUT );
            result = isequal(MaxDecoded.RESULT, A);
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
  partNames = { 'ComputeInitialPotentials', ...
                'GetNextCliques', ...
                'CliqueTreeCalibrate (Sum-Prod)', ...
                'ComputeExactMarginalBP (Exact)', ...
                'FactorMaxMarginalization', ...
                'CliqueTreeCalibrate (Max-Sum)',...
                'ComputeExactMarginalBP (MAP)',...
                'MaxDecoding'
              };
end

function srcs = sources()
  % Separated by part
  srcs = { { 'ComputeInitialPotentials.m' }, ...
           { 'GetNextCliques.m' }, ...
           { 'CliqueTreeCalibrate.m' }, ...
           { 'ComputeExactMarginalBP.m' }, ...
           { 'FactorMaxMarginalization.m' }, ...
           { 'CliqueTreeCalibrate.m' }, ...
           { 'ComputeExactMarginalBP' }, ...
           { 'MaxDecoding' }
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
