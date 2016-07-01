% File: RecognizeActions.m
%
% Copyright (C) Daphne Koller, Stanford Univerity, 2012

function [accuracy, predicted_labels] = RecognizeActions(datasetTrain, datasetTest, G, maxIter)

% INPUTS
% datasetTrain: dataset for training models, see PA for details
% datasetTest: dataset for testing models, see PA for details
% G: graph parameterization as explained in PA decription
% maxIter: max number of iterations to run for EM

% OUTPUTS
% accuracy: recognition accuracy, defined as (#correctly classified examples / #total examples)
% predicted_labels: N x 1 vector with the predicted labels for each of the
% instances in datasetTest, with N being the number of unknown test instances


% Train a model for each action
% Note that all actions share the same graph parameterization and number of max iterations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load PA9SampleCases
% temp_logh = -inf;
for i = 1:length(datasetTrain)% for each datasetTrain, train P, use 
    % different P in TestSet, get the biggest likelyhood
    P(i) = EM_HMM(datasetTrain(i).actionData,...
        datasetTrain(i).poseData, G, datasetTrain(i).InitialClassProb, datasetTrain(i).InitialPairProb, maxIter);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Classify each of the instances in datasetTrain
% Compute and return the predicted labels and accuracy
% Accuracy is defined as (#correctly classified examples / #total examples)
% Note that all actions share the same graph parameterization

accuracy = 0;
predicted_labels = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N = size(datasetTest.poseData, 1);
AN = size(datasetTrain, 2);% action number
K = size(datasetTrain, 2);
logEmissionProb = zeros(N,K,AN);
for an = 1:AN
    for n = 1:N
        for k = 1:K
            if(ndims(G)==2)
                GT = G;
            else
                GT = G(:,:,k);
            end
            for i = 1:10
                if(GT(i,1)==0)% only have one parent
                    Py = lognormpdf(datasetTest.poseData(n,i,1),P(an).clg(i).mu_y(k),P(an).clg(i).sigma_y(k));
                    Px = lognormpdf(datasetTest.poseData(n,i,2),P(an).clg(i).mu_x(k),P(an).clg(i).sigma_x(k));
                    Pa = lognormpdf(datasetTest.poseData(n,i,3),P(an).clg(i).mu_angle(k),P(an).clg(i).sigma_angle(k));
                    logEmissionProb(n,k,an) = logEmissionProb(n,k,an)+Py+Px+Pa;
                else
                    Temp = [1 reshape(datasetTest.poseData(n,GT(i,2),:),1,3)]';
                    Py = lognormpdf(datasetTest.poseData(n,i,1),P(an).clg(i).theta(k,1:4)*Temp,P(an).clg(i).sigma_y(k));
                    Px = lognormpdf(datasetTest.poseData(n,i,2),P(an).clg(i).theta(k,5:8)*Temp,P(an).clg(i).sigma_x(k));
                    Pa = lognormpdf(datasetTest.poseData(n,i,3),P(an).clg(i).theta(k,9:12)*Temp,P(an).clg(i).sigma_angle(k));
                    logEmissionProb(n,k,an) = logEmissionProb(n,k,an)+Py+Px+Pa;
                end
            end
        end
    end
end
temp_loglikelihood = zeros(K,length(datasetTest.actionData));
for an = 1:AN% action number
    for i = 1:length(datasetTest.actionData)
        F = repmat(struct('var',[],'card',[],'val',[]),...
            1+size(datasetTest.actionData(i).marg_ind,2)+...
            size(datasetTest.actionData(i).pair_ind,2),1);
        F(1).var = 1;
        F(1).card = K;
        F(1).val = log(P(an).c);
        
        for j = 1:size(datasetTest.actionData(i).marg_ind,2)% include marg_ind
            F(j+1).var = j;
            F(j+1).card = K;
            F(j+1).val = [logEmissionProb(datasetTest.actionData(i).marg_ind(j),:,an)];
        end
        j = j+1;
        temp = log(P(an).transMatrix(:));
        for jj = 1:size(datasetTest.actionData(i).pair_ind,2)% include pair_ind
            %             F(j+jj).var = [actionData(i).marg_ind(jj) actionData(i).marg_ind(jj+1)];
            F(j+jj).var = [jj jj+1];
            F(j+jj).card = [K K];
            F(j+jj).val = [temp'];
        end
        [M, PCalibrated] = ComputeExactMarginalsHMM(F);% get the infer result
        % compute the loglikelihood
        temp_loglikelihood(an,i) = temp_loglikelihood(an,i)+sum(logsumexp(PCalibrated.cliqueList(1).val));
        clear F;
    end
end

[~, idx]= max(temp_loglikelihood,[],1);
idx = idx';
if(exist('datasetTest.labels'))
    acc_num = sum(idx==datasetTest.labels);
    accuracy = acc_num/size(datasetTest.labels,1);
end
predicted_labels = ones(size(idx)).*idx;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
