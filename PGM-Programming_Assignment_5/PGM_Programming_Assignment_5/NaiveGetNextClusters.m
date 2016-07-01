%NAIVEGETNEXTCLUSTERS Takes in a node adjacency matrix and returns the indices
%   of the nodes between which the m+1th message should be passed.
%
%   Output [i j]
%     i = the origin of the m+1th message
%     j = the destination of the m+1th message
%
%   This method should iterate over the messages in increasing order where
%   messages are sorted in ascending ordered by their destination index and 
%   ties are broken based on the origin index. (note: this differs from PA4's
%   ordering)
%
%   Thus, if m is 0, [i j] will be the pair of clusters with the lowest j value
%   and (of those pairs over this j) lowest i value as this is the 'first'
%   element in our ordering. (this difference is because matlab is 1-indexed)
%
% Copyright (C) Daphne Koller, Stanford University, 2012

function [i j] = NaiveGetNextClusters(P, m)

    i = size(P.clusterList,1);
    j = size(P.clusterList,1);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % YOUR CODE HERE
    % Find the indices between which to pass a cluster
    % The 'find' function may be useful
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
%     explain idea
%     m is the m-1th message. So if you want to know from wich 
%     cluster to which cluster the m-1th message will be sent, 
%     you call this function. Remember, since this is LBP, m 
%     can be as large as you want, only you decide when you want 
%     to stop the process of message passing. So the first 
%     message will be passed from cluster i to cluster j 
%     where the values for i and j you get by calling this 
%     function with m=0. The second message will be passed 
%     from cluster i to cluster j where the values for i 
%     and j you get by calling this function with m=1, etc.
%                                   Willem SchaapCOMMUNITY TA

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% mine passed 3 but failed in 4
%     edge_num = sum(sum(P.edges~=0))/2;
%     sequence = cell(1,edge_num);    
%     n = size(P.edges,1);
%     k = 1;
%     for i = 1:n
%         for j = i+1:n
%             if(P.edges(i,j)~=0)
%                 sequence{k} = [j,i];
%                 k = k+1;
%             end
%         end
%     end
%     seq_n = length(sequence);
%     tseq_n = mod(m,seq_n);
%     temp = sequence{tseq_n+1};
%     i = temp(1);
%     j = temp(2);
    %% mine
    
    %% others 
    [myedgex,myedgey] = find(P.edges);
    myTempEdge = [myedgex,myedgey];
    myTempEdge = sortrows(myTempEdge,[2,1]);
    count_T    = size(myTempEdge,1);
    index      = mod(m,count_T) + 1;
    i          = myTempEdge(index,1);
    j          = myTempEdge(index,2);
    %% others
end

