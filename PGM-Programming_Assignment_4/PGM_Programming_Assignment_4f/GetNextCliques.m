%GETNEXTCLIQUES Find a pair of cliques ready for message passing
%   [i, j] = GETNEXTCLIQUES(P, messages) finds ready cliques in a given
%   clique tree, P, and a matrix of current messages. Returns indices i and j
%   such that clique i is ready to transmit a message to clique j.
%
%   We are doing clique tree message passing, so
%   do not return (i,j) if clique i has already passed a message to clique j.
%
%	 messages is a n x n matrix of passed messages, where messages(i,j)
% 	 represents the message going from clique i to clique j.
%   This matrix is initialized in CliqueTreeCalibrate as such:
%      MESSAGES = repmat(struct('var', [], 'card', [], 'val', []), N, N);
%
%   If more than one message is ready to be transmitted, return
%   the pair (i,j) that is numerically smallest. If you use an outer
%   for loop over i and an inner for loop over j, breaking when you find a
%   ready pair of cliques, you will get the right answer.
%
%   If no such cliques exist, returns i = j = 0.
%
%   See also CLIQUETREECALIBRATE
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function [i, j] = GetNextCliques(P, messages)
% initialization
% you should set them to the correct values in your code
i = 0;
j = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%% my1
%average time 0.002502
% n = size(messages,1);
% for i = 1:n
%     for j = 1:n
%         if( (P.edges(i,j)==1) && (isempty(messages(i,j).var)) )
%             flag = 0;
%             idx = setdiff(find(P.edges(:,i)==1),j);
%             for k = 1:length(idx)
%                 if(isempty(messages(idx(k),i).var))
%                     flag = 1;
%                     break;
%                 end
%             end
%             if(flag==0)
%                 return;
%             end
%         end
%     end
% end
% i = 0;
% j = 0;
% return;
%% my1 end


%% my2
%much faster than above
n = size(messages,1);
for j = 1:n %the order of loop is different from above
    for i = 1:n
        if( (P.edges(i,j)==1) && (isempty(messages(i,j).var)) )
            flag = 0;
            idx = setdiff(find(P.edges(:,i)==1),j);
            for k = 1:length(idx)
                if(isempty(messages(idx(k),i).var))
                    flag = 1;
                    break;
                end
            end
            if(flag==0)
                return;
            end
        end
    end
end
i = 0;
j = 0;
return;
%% my2 end