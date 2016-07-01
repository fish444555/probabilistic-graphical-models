% MHUNIFORMTRANS
%
%  MCMC Metropolis-Hastings transition function that
%  utilizes the uniform proposal distribution.
%  A - The current joint assignment.  This should be
%      updated to be the next assignment
%  G - The network
%  F - List of all factors
%
% Copyright (C) Daphne Koller, Stanford University, 2012

function A = MHUniformTrans(A, G, F)

% Draw proposed new state from uniform distribution
A_prop = ceil(rand(1, length(A)) .* G.card);

p_acceptance = 0.0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
% Compute acceptance probability
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% notice 
% https://class.coursera.org/pgm-2012-002/forum/thread?thread_id=1010

% https://github.com/tomtung/pgm-class/blob/master/PGM_Programming_Assignment_5/MHUniformTrans.m
% the side above runs correct

% why i was wrong because i did not renormal the log result
%% part 1 has some error 
% time 0,14
% A1 = [A_prop;A];%x'->x
% A2 = [A;A_prop];%x->x'
% logx1 = 0.0;
% logx2 = 0.0;
% 
% 
% for j = 1:length(A)
%     idx = G.var2factors{j};
%     FTemp = F(idx);
%     for k = 1:length(idx);
%         logx2 = logx2+log(GetValueOfAssignment(FTemp(k), A2(:,FTemp(k).var)));
%         logx1 = logx1+log(GetValueOfAssignment(FTemp(k), A1(:,FTemp(k).var)));
%     end
%     temp1(j) = logx1(2);
%     temp2(j) = logx2(2);
%     
%     
% end
% 
% p_acceptance = min(1,(exp(temp1*A_prop'))/(exp(temp2*A')));
%% part1 end



%% part2 time 0.09
t11 = 0.0;
t22 = 0.0;
for j = 1:length(A)
    idx = G.var2factors{j};
    FTemp = F(idx);    
    t11  = t11+LogProbOfJointAssignment(FTemp, A_prop);
    t22  = t22+LogProbOfJointAssignment(FTemp, A);
    t33 = exp(t11-t22);
%     t33 = exp(t11)/exp(t22);
end

p_acceptance = min(1,t33);
%% part2 end


%% others time 0.06
% logAcc = LogProbOfJointAssignment(F, A_prop) - LogProbOfJointAssignment(F, A);
% p_acceptance  = min(exp(logAcc), 1);
%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Accept or reject proposal
if rand() < p_acceptance
    % disp('Accepted');
    A = A_prop;
end


