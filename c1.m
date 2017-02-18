

function [D,result,ratio,matchitem,N]=c1(data,A,FZ)
%单着分析
%data为列向量，matchitem为行向量，比较项
%result保留项和最大距离Dmax，余数yushu

[m, ~]=size(data);
matchitem=A(:,1:end-1);

        
item=max(size(matchitem));
N=zeros(item,1);
result=zeros(item,2);
ratio=zeros(item,1);
D=cell(item,1);
for i=1:item
    
    index=find(data==matchitem(i));
    D{i}=diff(index);
    Dmax=A(i,end);
%     Dmax=max(max(D{i}),A(i,end));
    %     Dmax=max(D{i});
    shengyu=m-max(index);
    if isempty(index)
        result(i,1)=m;
         result(i,2)=A(i,end);
    else
        result(i,:)=[shengyu Dmax];
        ratio(i)=shengyu/Dmax;
        N(i)=length(index);
    end
end
tf=(ratio>=FZ) & (A(:,end)>0);
D=D(tf);
result=round(result(tf,:));
ratio=ratio(tf,:);
matchitem=matchitem(tf,:);
N=N(tf,:);

end
