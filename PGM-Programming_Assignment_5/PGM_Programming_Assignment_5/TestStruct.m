function [i,j]= TestStruct(struct1,struct2)
% this function test whether two structs are equal, if equal
% return 1, overwise return 0. 

load('exampleIOPA5.mat');
thresh = 1.0e-6;
find = 0;% find the num>thresh
if(size(struct1)~=size(struct2))
    find = 1;
    fprintf('size do not equal');
    result = 0;
end
m = size(struct1,1);
n = size(struct1,2);
for i = 1:m
    for j = 1:n
        %     result = struct1(j).val-struct1(j).val;
        result = isequal(struct1(i,j).val,struct2(i,j).val);
        %     if(abs(result)>thresh)
        if(result==0)            
            return;
        end
    end
end
tb = 1;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
return;
