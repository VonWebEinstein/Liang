function [result] = c(data,p ,A)
if p==1
else
    data=sort(data,2);
end
matchitem=A(:,1:end-1);
[item,~]=size(matchitem);

result=A;

for i=1:item   %遍历matchitem的所有项
    if p==2
        index=find((data(:,1)==matchitem(i,1)& data(:,2)==matchitem(i,2))...
            |(data(:,1)==matchitem(i,1)& data(:,3)==matchitem(i,2))...
            |(data(:,2)==matchitem(i,1)& data(:,3)==matchitem(i,2)));
    else
        index=find(data(:,1)==matchitem(i,1)&data(:,2)==matchitem(i,2)&data(:,3)==matchitem(i,3));
    end
    Dmax=max([max(diff(index)),A(i,end)]);
    
    result(i,end)=Dmax;

end

