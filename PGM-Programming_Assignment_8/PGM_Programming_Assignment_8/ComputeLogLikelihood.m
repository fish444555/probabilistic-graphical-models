function loglikelihood = ComputeLogLikelihood(P, G, dataset)
% returns the (natural) log-likelihood of data given the model and graph structure
%
% Inputs:
% P: struct array parameters (explained in PA description)
% G: graph structure and parameterization (explained in PA description)
%
%    NOTICE that G could be either 10x2 (same graph shared by all classes)
%    or 10x2x2 (each class has its own graph). your code should compute
%    the log-likelihood using the right graph.
%
% dataset: N x 10 x 3, N poses represented by 10 parts in (y, x, alpha)
%
% Output:
% loglikelihood: log-likelihood of the data (scalar)
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

N = size(dataset,1); % number of examples
K = length(P.c); % number of classes

loglikelihood = 0;
% You should compute the log likelihood of data as in eq. (12) and (13)
% in the PA description
% Hint: Use lognormpdf instead of log(normpdf) to prevent underflow.
%       You may use log(sum(exp(logProb))) to do addition in the original
%       space, sum(Prob).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% mine
% % i have not idea
% p = zeros(1,3);
% for k = 1:K
%     for i = 1:size(G,2)
%         for j = 1:3
%             if(i==1)
%                 temp = P.clg(1,i);
%                 if(j==1)% P(O(1)|c=k)
%                     p(1,j) = p(1,j)+sum(normpdf(dataset(:,i,j),temp.mu_y(k),temp.sigma_y(k)))...
%                         -log(P.c(k));
%                 elseif(j==2)
%                     p(2,j) = p(2,j)+sum(normpdf(dataset(:,i,j),temp.mu_x(k),temp.sigma_x(k)))...
%                         -log(P.c(k));
%                 else
%                     p(3,j) = p(3,j)+sum(normpdf(dataset(:,i,j),temp.mu_theta(k),temp.sigma_theta(k)))...
%                         -log(P.c(k));
%                 end
%             else% P(O(i)|c=k,Op(i))
%                 temp1 = P.clg(1,i);
%                 temp2 = P.clg(1,G(i,2));
%                 if(j==1)
%                     p(1,j) = p(1,j)+sum(normpdf(dataset(:,i,j),temp.mu_y(k),temp.sigma_y(k)))...
%                         +sum(normpdf(dataset(:,G(i,2),j),temp2.mu_y(k),temp2.sigma_y(k)))...
%                         -log(
%                     P.c(k));
%                 end
% % tg =1;
%             end
%         end
%     end
% end
%
%
% end
%
%
% function p = condition_p(k,i)
% % compute P(O(i)|c=k,Op(i))
% % P(O(i)|c=k,Op(i)) = P(O(i),c=k,Op(i))/P(c=k,Op(i))
%
%
%
% FactorProduct
% end
%% mine end

%% others
% % PK = log(P.c);
% for n=1:N
%     PK = log(P.c);
%     for k=1:K
%         if ndims(G) == 2
%             Gk = G;
%         else %ndims(G) == 3
%             Gk = G(:,:,k);
%         end
%         for i=1:10
%             if Gk(i,1) == 0 % G(i; 1) = 0 indicates that body part i only has the class variable as its parent
%                 Py = lognormpdf(dataset(n,i,1), P.clg(i).mu_y(k), P.clg(i).sigma_y(k));
%                 Px = lognormpdf(dataset(n,i,2), P.clg(i).mu_x(k), P.clg(i).sigma_x(k));
%                 Pa = lognormpdf(dataset(n,i,3), P.clg(i).mu_angle(k), P.clg(i).sigma_angle(k));
%                 PK(k) = PK(k) + Py + Px + Pa;
%             else %G(i; 1) = 1 indicates that body part i has, besides the class variable, another parentG(i; 2)
%                 Dp = [1 reshape(dataset(n, Gk(i,2), :),1,3)]';
%                 Py = lognormpdf(dataset(n,i,1), P.clg(i).theta(k,1:4) * Dp, P.clg(i).sigma_y(k));
%                 Px = lognormpdf(dataset(n,i,2), P.clg(i).theta(k,5:8) * Dp, P.clg(i).sigma_x(k));
%                 Pa = lognormpdf(dataset(n,i,3), P.clg(i).theta(k,9:12) * Dp, P.clg(i).sigma_angle(k));
%                 PK(k) = PK(k) + Py + Px + Pa;
%             end;
%         end
%     end
%     loglikelihood = loglikelihood + log(sum(exp(PK)));
% end
%% other end



%% after reference 
for n = 1:N
    LogP = log(P.c);
    for k = 1:K        
        if(ndims(G)==2)% G could be 10x2
            GT = G;
        else% G could be 10x2x2
            GT = G(:,:,k);
        end
        for i = 1:10
            if(GT(i,1)==0)% the root body which only have the parents of C
                Py = lognormpdf(dataset(n,i,1),P.clg(i).mu_y(k),P.clg(i).sigma_y(k));
                Px = lognormpdf(dataset(n,i,2),P.clg(i).mu_x(k),P.clg(i).sigma_x(k));
                Pa = lognormpdf(dataset(n,i,3),P.clg(i).mu_angle(k),P.clg(i).sigma_angle(k));
                LogP(k) = LogP(k)+Py+Px+Pa;
            else
                Temp = [1 reshape(dataset(n,GT(i,2),:),1,3)]';% not only have the parents of C,but also another body which in G(i,2)
                Py = lognormpdf(dataset(n,i,1),P.clg(i).theta(k,1:4)*Temp,P.clg(i).sigma_y(k));
                Px = lognormpdf(dataset(n,i,2),P.clg(i).theta(k,5:8)*Temp,P.clg(i).sigma_x(k));
                Pa = lognormpdf(dataset(n,i,3),P.clg(i).theta(k,9:12)*Temp,P.clg(i).sigma_angle(k));
                LogP(k) = LogP(k)+Py+Px+Pa;
            end
        end        
    end
    loglikelihood = loglikelihood+log(sum(exp(LogP)));
end
%% after reference end