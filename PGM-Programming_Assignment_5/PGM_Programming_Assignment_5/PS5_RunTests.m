function PS5_RunTests()

clear;

constTOL = 1e-6;

load('exampleIOPA5.mat');


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
            
            for i = 1:length(exampleOUTPUT.t1)
                [ii,j] = NaiveGetNextClusters(exampleINPUT.t1a1, exampleINPUT.t1a2{i});
                result = isequal(exampleOUTPUT.t1{i}, [ii,j]);
            end
        case 2
            P = CreateClusterGraph(exampleINPUT.t2a1, exampleINPUT.t2a2);
            result = isequal(P, exampleOUTPUT.t2);
        case 3
            for i = 1:length(exampleINPUT.t3a1)
                converged = CheckConvergence(exampleINPUT.t3a1{i}, exampleINPUT.t3a2{i});
                result = isequal(exampleOUTPUT.t3{i}, converged);
            end
        case 4
            [P MESSAGES] = ClusterGraphCalibrate(exampleINPUT.t4a1,0);
            save('tp','P');
            result = (isequal(exampleOUTPUT.t4o2, MESSAGES)) && (isequal(exampleOUTPUT.t4o1, P));
        case 5
            B = ComputeApproxMarginalsBP(exampleINPUT.t5a1, exampleINPUT.t5a2);
            result = isequal(exampleOUTPUT.t5, B);
        case 6
            tic;
            LogBS = BlockLogDistribution(exampleINPUT.t6a1, exampleINPUT.t6a2,...
                exampleINPUT.t6a3, exampleINPUT.t6a4);
            result = isequal(exampleOUTPUT.t6, LogBS);
            toc;
        case 7
            display('GibbsTrans')
            randi('seed',1);
            result = 1;
            for iter = 1:10
%                 display(['iter ', num2str(iter),')'])
                A = GibbsTrans(exampleINPUT.t7a1{iter}, ...
                    exampleINPUT.t7a2{iter}, exampleINPUT.t7a3{iter});
%                 display(['Output:   ', num2str(A)])
%                 display(['Expected: ', num2str(exampleOUTPUT.t7{iter})])
%                 display(' ')
                result = result && isequal(A, exampleOUTPUT.t7{iter});
            end
        case 8
            display('MCMCInference')
            exampleINPUT.t8a4{2} = 'MHGibbs';
            result = 1;
            randi('seed',1);
            for iter = 1:2
%                 display(['iter ', num2str(iter),')'])
                [M, all_samples] = MCMCInference(exampleINPUT.t8a1{iter},...
                    exampleINPUT.t8a2{iter}, exampleINPUT.t8a3{iter}, ...
                    exampleINPUT.t8a4{iter}, exampleINPUT.t8a5{iter}, ...
                    exampleINPUT.t8a6{iter}, exampleINPUT.t8a7{iter}, ...
                    exampleINPUT.t8a8{iter});
                result = result && isequal(M, exampleOUTPUT.t8o1{1,iter}) && ...
                    isequal(all_samples, exampleOUTPUT.t8o2{iter});
            end
        case 9
            tic;
            display('MHUniformTrans')
            randi('seed',1);
            result = 1;
            for iter = 1:10
                A = MHUniformTrans(exampleINPUT.t9a1{iter}, ...
                    exampleINPUT.t9a2{iter}, exampleINPUT.t9a3{iter});
                if isequal(A, exampleOUTPUT.t9{iter})
                    display(['iter ', num2str(iter),') ok'])
                else
                    display(['iter ', num2str(iter),') x'])
                    result = 0;
                end
            end
            toc;
        case 10
            display('MHSWTrans (Variant 1)')
            randi('seed',1);
            result = 1;
            for iter = 1:10
                A = MHSWTrans(exampleINPUT.t10a1{iter}, ...
                    exampleINPUT.t10a2{iter}, exampleINPUT.t10a3{iter}, ...
                    exampleINPUT.t10a4{iter});
                if isequal(A, exampleOUTPUT.t10{iter})
                    display(['iter ', num2str(iter),') ok'])
                else
                    display(['iter ', num2str(iter),') x'])
                    result = 0;
                end
            end
        case 11
            display('MHSWTrans (Variant 2)')
            randi('seed',1);
            result = 1;
            for iter = 1:20
                A = MHSWTrans(exampleINPUT.t11a1{iter}, ...
                    exampleINPUT.t11a2{iter}, exampleINPUT.t11a3{iter}, ...
                    exampleINPUT.t11a4{iter});
                if isequal(A, exampleOUTPUT.t11{iter})
                    display(['iter ', num2str(iter),') ok'])
                else
                    display(['iter ', num2str(iter),') x'])
                    result = 0;
                end
            end
        case 12
            display('MCMCInference (part 2)')
            result = 1;
            randi('seed',1);
%             randi('seed',26288942);
            for iter = 1:2 % check the comments for a working solution for 2nd iteration
                [M, all_samples] = MCMCInference(exampleINPUT.t12a1{iter},...
                    exampleINPUT.t12a2{iter}, exampleINPUT.t12a3{iter}, ...
                    exampleINPUT.t12a4{iter}, exampleINPUT.t12a5{iter}, ...
                    exampleINPUT.t12a6{iter}, exampleINPUT.t12a7{iter}, ...
                    exampleINPUT.t12a8{iter});
                if isequal(M, exampleOUTPUT.t12o1{iter}) && ...
                        isequal(all_samples, exampleOUTPUT.t12o2{iter}),
                    display(['iter ', num2str(iter),') ok'])
                else
                    display(['iter ', num2str(iter),') x'])
                    result = 0;
                end
                randi('seed',26288942);
            end
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
partNames = { 'NaiveGetNextClusters', ...
    'CreateClusterGraph', ...
    'CheckConvergence', ...
    'ClusterGraphCalibrate', ...
    'ComputeApproxMarginalsBP', ...
    'BlockLogDistribution',...
    'GibbsTrans',...
    'MCMCInference Part I',...
    'MHUniformTrans',...
    'MHSWTrans version 1',...
    'MHSWTrans version 2',...
    'MCMCInference Part 2'
    };
end

function srcs = sources()
% Separated by part
srcs = { { 'NaiveGetNextClusters.m' }, ...
    { 'CreateClusterGraph.m' }, ...
    { 'CheckConvergence.m' }, ...
    { 'ClusterGraphCalibrate.m' }, ...
    { 'ComputeApproxMarginalsBP.m' }, ...
    { 'BlockLogDistribution.m' }, ...
    { 'GibbsTrans.m' }, ...
    { 'MCMCInference.m' },...
    { 'MHUniformTrans.m' },...
    { 'MHSWTrans.m' },...
    { 'MHSWTrans.m' },...
    { 'MCMCInference.m' }
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
