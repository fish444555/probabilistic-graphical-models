function result = tcompare(SampleOutput,ComputeResult)
selPart = input('', 's');
partId = str2num(selPart);
switch(partId)
m = length(SampleOutput);
n = length(ComputeResult);
result = 0;
if (m~=n)
    result = -1;    
end
for i = 1:n
    if( (result==0)&&((SampleOutput(i).var~=ComputeResult(i).var) ||...
            (SampleOutput(i).card~=ComputeResult(i).card) ||...
            any((SampleOutput(i).val==ComputeResult(i).val)==0)) )
        result = -1;
        break;
    end
end 
if(result==0)
    result = 1;
end
end