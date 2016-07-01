% CLUSTERGRAPHCALIBRATE Loopy belief propagation for cluster graph calibration.
%   P = CLUSTERGRAPHCALIBRATE(P, useSmart) calibrates a given cluster graph, G,
%   and set of of factors, F. The function returns the final potentials for
%   each cluster.
%   The cluster graph data structure has the following fields:
%   - .clusterList: a list of the cluster beliefs in this graph. These entries
%                   have the following subfields:
%     - .var:  indices of variables in the specified cluster
%     - .card: cardinality of variables in the specified cluster
%     - .val:  the cluster's beliefs about these variables
%   - .edges: A cluster adjacency matrix where edges(i,j)=1 implies clusters i
%             and j share an edge.
%
%   UseSmart is an indicator variable that tells us whether to use the Naive or Smart
%   implementation of GetNextClusters for our message ordering
%
%   See also FACTORPRODUCT, FACTORMARGINALIZATION
%
% Copyright (C) Daphne Koller, Stanford University, 2012

function [P MESSAGES] = ClusterGraphCalibrate(P,useSmartMP)

if(~exist('useSmartMP','var'))
    useSmartMP = 0;
end

N = length(P.clusterList);

MESSAGES = repmat(struct('var', [], 'card', [], 'val', []), N, N);
[edgeFromIndx, edgeToIndx] = find(P.edges ~= 0);
load('exampleIOPA5.mat');

for m = 1:length(edgeFromIndx),
    i = edgeFromIndx(m);
    j = edgeToIndx(m);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE
    %
    %
    %
    % Set the initial message values
    % MESSAGES(i,j) should be set to the initial value for the
    % message from cluster i to cluster j
    %
    % The matlab/octave functions 'intersect' and 'find' may
    % be useful here (for making your code faster)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%     part2
    DIFF = setdiff(P.clusterList(i).var,intersect(P.clusterList(i).var,P.clusterList(j).var));
    MESSAGES(i,j) = FactorMarginalization(P.clusterList(i), DIFF);
    MESSAGES(i,j).val = ones(1, length(MESSAGES(i,j).val)); % init as 1
    %% part2 end
    
    
    %% part3
    %      msg = struct('var', [], 'card', [], 'val', []);
    %     [msg.var, idxI, ~] = intersect(P.clusterList(i).var, P.clusterList(j).var);
    %     msg.card = P.clusterList(i).card(idxI);
    %     msg.val = ones(1, prod(msg.card));
    %
    %     MESSAGES(i,j) = msg;
    %% part3 end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end;



% perform loopy belief propagation
% tic;
iteration = 0;

lastMESSAGES = MESSAGES;
time1 = [];
time2 = [];
time3 = [];
while (1),
    iteration = iteration + 1;
    [i, j] = GetNextClusters(P, MESSAGES,lastMESSAGES, iteration, useSmartMP);
    prevMessage = MESSAGES(i,j);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE
    % We have already selected a message to pass, \delta_ij.
    % Compute the message from clique i to clique j and put it
    % in MESSAGES(i,j)
    % Finally, normalize the message to prevent overflow
    %
    % The function 'setdiff' may be useful to help you
    % obtain some speedup in this function
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% others
    C = P.clusterList(i);
    %Compute FactorProduct of i
    for x=1:N
        %         if( (length(MESSAGES(x,i).var)~=0) && (x ~= j) )
        if(~isempty(MESSAGES(x,i).var) && x ~= j)
            C = FactorProduct(C, MESSAGES(x,i));
        end
    end
    
    
    DIFF = setdiff(P.clusterList(i).var,MESSAGES(i,j).var);
    MESSAGES(i,j) = FactorMarginalization(C, DIFF);
    %Normalize
    SUM_MESSAGE = sum(MESSAGES(i,j).val);
    MESSAGES(i,j).val = MESSAGES(i,j).val ./SUM_MESSAGE;
    %%
    
    
    %% part3
%         Ci = P.clusterList(i);
%         for k=edgeFromIndx(edgeToIndx == i)
%             if k ~= j
%                 Ci = FactorProduct(Ci, MESSAGES(k, i));
%             end
%         end
%     
%         MESSAGES(i, j) = FactorMarginalization(Ci, ...
%             setdiff(Ci.var, MESSAGES(i, j).var));
%     
%         MESSAGES(i, j).val = MESSAGES(i, j).val / sum(MESSAGES(i, j).val);
    
    
%         For PA5 Quiz 1
        if i == 19 && j == 3 || i == 15 && j == 40 || i == 17 && j == 2
%             tic;
            tvar = MessageDelta(MESSAGES(i,j), prevMessage);
%             fprintf('iter=%d, i=%d j=%d delta=%f\n', iteration, i, j, tvar)
            if(i == 19)
                time1 = [time1 tvar];
            elseif(i == 15)
                time2 = [time2 tvar];
            else
                time3 = [time3 tvar];
            end
%             toc;
        end
%         toc;
        
    %% part3 end
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    if(useSmartMP==1)
        lastMESSAGES(i,j)=prevMessage;
    end
    
    % Check for convergence every m iterations
    if mod(iteration, length(edgeFromIndx)) == 0
        if (CheckConvergence(MESSAGES, lastMESSAGES))
            break;
        end
%         disp(['LBP Messages Passed: ', int2str(iteration), '...']);
        if(useSmartMP~=1)
            lastMESSAGES=MESSAGES;
        end
    end
    if(iteration>100000)
        break;
    end
end;
% toc;
disp(['Total number of messages passed: ', num2str(iteration)]);
% subplot(2,2,1);
% plot([1:iteration/length(time1):iteration],time1);
% subplot(2,2,2);
% plot([1:iteration/length(time2):iteration],time2);
% subplot(2,2,3);
% plot([1:iteration/length(time3):iteration],time3);


% Compute final potentials and place them in P
for m = 1:length(edgeFromIndx),
    j = edgeFromIndx(m);
    i = edgeToIndx(m);
    P.clusterList(i) = FactorProduct(P.clusterList(i), MESSAGES(j, i));
end


% Get the max difference between the marginal entries of 2 messages -------
function delta = MessageDelta(Mes1, Mes2)
delta = max(abs(Mes1.val - Mes2.val));
return;


