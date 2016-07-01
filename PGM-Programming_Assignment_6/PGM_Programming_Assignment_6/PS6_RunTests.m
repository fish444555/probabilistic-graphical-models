function PS5_RunTests()

clear;

constTOL = 1e-6;

if (~exist('TS','var') || true)
  %% This is based on TestCases to make it all more testable.

  TS = repmat(struct('I', [], 'allDs', [], 'allEU', [], 'EUF', []), 1, 3);

  %% Test case 1.
  I.RandomFactors = struct('var', [1], 'card', [2], 'val', [0.7, 0.3]);
  I.DecisionFactors = struct('var', [2], 'card', [2], 'val', [1 0]);
  I.UtilityFactors = struct('var', [1, 2], 'card', [2, 2], 'val', [10, 1, 5, 1]);

  TS(1).I = I;
  TS(1).allDs = [1 0; 0 1];
  TS(1).EUF = struct('var', [2], 'card', [2], 'val', [7.3 3.8]);
  TS(1).allEU = [7.3 3.8];
  TS(1).MEU = 7.3;
  TS(1).OptDR = struct('var', [2], 'card', [2], 'val', [1 0]);

  %% Test case 2.
  I.RandomFactors = ...
      [struct('var', [1], 'card', [2], 'val', [0.7, 0.3]), ...
       CPDFromFactor(struct('var', [3,1,2], 'card', [2,2,2], 'val', [4 4 1 1 1 1 4 4]), 3)];
  I.DecisionFactors = struct('var', [2], 'card', [2], 'val', [1 0]);
  I.UtilityFactors = struct('var', [2,3], 'card', [2, 2], 'val', [10, 1, 5, 1]);

  TS(2).I = I;
  TS(2).allDs = [1 0; 0 1];
  TS(2).EUF = struct('var', [2], 'card', [2], 'val', [7.5 1.0]);
  TS(2).allEU = [7.5 1.0];
  TS(2).MEU = 7.5;
  TS(2).OptDR = struct('var', [2], 'card', [2], 'val', [1 0]);

  %% Test case 3.
  I.RandomFactors = ...
      [struct('var', [1], 'card', [2], 'val', [0.7, 0.3]), ...
       CPDFromFactor(struct('var', [3,1,2], 'card', [2,2,2], 'val', [4 4 1 1 1 1 4 4]), 3)];
  I.DecisionFactors = struct('var', [2,1], 'card', [2,2], 'val', [1,0,0,1]);
  I.UtilityFactors = struct('var', [2,3], 'card', [2, 2], 'val', [10, 1, 5, 1]);

  TS(3).I = I;
  TS(3).allDs = [1 1 0 0; 1 0 0 1; 0 1 1 0; 0 0 1 1];
%   TS(3).allDs = [1 0 1 0; 1 0 0 1; 0 1 1 0; 0 1 0 1];
  TS(3).EUF = struct('var', [1,2], 'card', [2 2], 'val', [5.25 2.25 0.7 0.3]);
  TS(3).allEU = [7.5 5.55 2.95 1.0];
  TS(3).MEU = 7.5;
  TS(3).OptDR = struct('var', [1,2], 'card', [2,2], 'val', [1,1,0,0]);

  %% Test case 4.
  I.RandomFactors = ...
      [struct('var', [1], 'card', [2], 'val', [0.7, 0.3]), ...
       CPDFromFactor(struct('var', [3,1,2], 'card', [2,2,2], 'val', [4 4 1 1 1 1 4 4]), 3)];
  I.DecisionFactors = struct('var', [2,1], 'card', [2,2], 'val', [1,0,0,1]);
  I.UtilityFactors = ...
      [struct('var', [2,3], 'card', [2, 2], 'val', [10, 1, 5, 1]), ...
       struct('var', [2], 'card', [2], 'val', [1, 10])];

  T4.I = I;
  T4.MEU = 11;
  T4.OptDR = struct('var', [1,2], 'card', [2,2], 'val', [0,0,1,1]);

end




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
            disp('Test for SimpleCalcExpectedUtility:');
            for t = 1:length(TS)
                T = TS(t);
                for d = 1:size(T.allDs, 1)
                    T.I.DecisionFactors.val = T.allDs(d, :);
                    EU = SimpleCalcExpectedUtility(T.I);
                    assert(abs(EU - T.allEU(d)) < 1e-6, 'EU(%d) for Test Case %d is incorrect!', d, t);
                end
                disp(['    Test Case ', num2str(t), ': passed!']);
            end
            result = 1;
            
        case 2
            disp('Test for CalculateExpectedUtilityFactor:');
            for t = 1:length(TS)
                T = TS(t);
                EUF = CalculateExpectedUtilityFactor(T.I);
                assert(isequal(EUF, T.EUF), 'EUF for Test Case %d is incorrect!', t);
                disp(['    Test Case ', num2str(t), ': passed!']);
            end
            result = 1;
        case 3
            disp('Test for OptimizeMEU:');
            for t = 1:length(TS)
                T = TS(t);
                [meu optdr] = OptimizeMEU(T.I);
                assert(isequal(meu, T.MEU), 'MEU for Test Case %d is incorrect!', t);
                assert(isequal(optdr, T.OptDR), 'OptDR for Test Case %d is incorrect!', t);
                disp(['    Test Case ', num2str(t), ': passed!']);
            end
            result = 1;
        case 4
            disp('Test for OptimizeWithJointUtility:');
            [meu optdr] = OptimizeWithJointUtility(T4.I);
            assert(isequal(meu, T4.MEU), 'Test Case 4: MEU is incorrect!');
            assert(isequal(optdr, T4.OptDR), 'Test Case 4: OptDR is incorrect!');
            disp('    Test Case 4: passed!');
            %% Also, see if it works with single utility:
            for t = 1:length(TS)
                T = TS(t);
                [meu optdr] = OptimizeWithJointUtility(T.I);
                assert(isequal(meu, T.MEU), 'Test Case %d: MEU is incorrect!', t);
                assert(isequal(optdr, T.OptDR), 'Test Case %d: OptDR is incorrect!', t);
                disp(['    Test Case ', num2str(t), ': passed!']);
            end
            result = 1;
        case 5
            disp('Test for OptimizeLinearExpectations:');
            [meu optdr] = OptimizeLinearExpectations(T4.I);
            assert(isequal(meu, T4.MEU), 'Test Case 4: MEU is incorrect!');
            assert(isequal(optdr, T4.OptDR), 'Test Case 4: OptDR is incorrect!');
            disp('    Test Case 4: passed!');
            %% Also, see if it works with single utility:
            for t = 1:length(TS)
                T = TS(t);
                [meu optdr] = OptimizeLinearExpectations(T.I);
                assert(isequal(meu, T.MEU), 'Test Case %d: MEU is incorrect!', t);
                assert(isequal(optdr, T.OptDR), 'Test Case %d: OptDR is incorrect!', t);
                disp(['    Test Case ', num2str(t), ': passed!']);
            end
            result = 1;
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
partNames = { 'SimpleCalcExpectedUtility', ...
    'CalculateExpectedUtilityFactor', ...
    'OptimizeMEU', ...
    'OptimizeWithJointUtility', ...
    'OptimizeLinearExpectations'
    };
end

function srcs = sources()
% Separated by part
srcs = { { 'SimpleCalcExpectedUtility.m' }, ...
    { 'CalculateExpectedUtilityFactor.m' }, ...
    { 'OptimizeMEU.m' }, ...
    { 'OptimizeWithJointUtility.m' }, ...
    { 'OptimizeLinearExpectations.m' }    
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
