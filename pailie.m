function [output,q]=pailie(n,m)
%排列生成算法。生成从1到n个数中选m个数的所有组合。
%n----待选集个数。
%m----排列个数。
y=1:m;
output=y;
q=1;
while any(y~=n:-1:n-m+1)
    flag=1;
    y(m)=y(m)+1;
    for j=m:-1:1
        if y(j)>n && j>=2
           y(j)=1;
           y(j-1)=y(j-1)+1;
        end
    end
        for i=1:m-1
            for k=i+1:m
                if y(i)==y(k)
                   flag=0;
                   break;
                end
            end
        end
    if flag==1
          output=[output;y];
            q=q+1;
    end
end
