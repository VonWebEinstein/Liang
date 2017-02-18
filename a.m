

function [result]=a(data,A)

matchitem=A(:,1:end-1);
[item,~]=size(matchitem);
result=A;

for i=1:item
    Dmax=max([max(diff(find(data==matchitem(i)))),A(i,end)]);
    result(i,end)=Dmax;
    
end

end
 