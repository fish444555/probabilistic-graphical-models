%CREATECLUSTERGRAPH Takes in a list of factors and returns a Bethe cluster
%   graph. It also returns an assignment of factors to cliques.
%
%   C = CREATECLUSTERGRAPH(F) Takes a list of factors and creates a Bethe
%   cluster graph with nodes representing single variable clusters and
%   pairwise clusters. The value of the clusters should be initialized to 
%   the initial potential. 
%   It returns a cluster graph that has the following fields:
%   - .clusterList: a list of the cluster beliefs in this graph. These entries
%                   have the following subfields:
%     - .var:  indices of variables in the specified cluster
%     - .card: cardinality of variables in the specified cluster
%     - .val:  the cluster's beliefs about these variables
%   - .edges: A cluster adjacency matrix where edges(i,j)=1 implies clusters i
%             and j share an edge.
%  
%   NOTE: The index of the cluster for each factor should be the same within the
%   clusterList as it is within the initial list of factors.  Thus, the cluster
%   for factor F(i) should be found in P.clusterList(i) 
%
% Copyright (C) Daphne Koller, Stanford University, 2012

function P = CreateClusterGraph(F, Evidence)
P.clusterList = [];
P.edges = [];
for j = 1:length(Evidence),
    if (Evidence(j) > 0),
        F = ObserveEvidence(F, [j, Evidence(j)]);
    end;
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% mine
n = length(F);
P.clusterList = F;
P.edges = zeros(n,n);
for i = 1:n
    if(length(P.clusterList(i).var)~=1)
        for j = 1:length(P.clusterList(i).var)
            P.edges(i,P.clusterList(i).var(j)) = 1;
            P.edges(P.clusterList(i).var(j),i) = 1;
        end
    end
end
%%

%% others
% P.clusterList = F;
% Fsize = length(F);
% P.edges = zeros(Fsize,Fsize);
% for i=1:Fsize
%         Li = length(F(i).var);
%         for j=1:length(F)
%                 Lj = length(F(j).var);
%                 if i ~= j
%                         I = intersect(F(i).var, F(j).var);
%                         if (length(I) > 0) && ((Li == 1) || (Lj == 1))
%                                 P.edges(i,j) = 1;
%                                 P.edges(j,i) = 1;
%                         end
%                 end
%         end
% end
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

end