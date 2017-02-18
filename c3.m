function [D, result, ratio,matchitem,N] = c3(data,p ,A,FZ)
%3着
%data为m·3矩阵
%结果result,m·5矩阵
%比值ratio为列向量
%matchitem为比较项，所有出现的项，为m·3矩阵
% p=1,有序，p=0，无序,p=2,扩联


[m, ~]=size(data);
if p==1
else
    data=sort(data,2);
end
% valuemax=max(max(data));
% yuansu=unique(data);


% if p==2
%     matchitem=unique([data(:,[1 2]);data(:,[1 3]);data(:,[2 3])],'rows');
% else
%     matchitem=unique(data,'rows');
% end
% if re==1
%     if p==0||p==1
%     matchitem=matchitem(~((matchitem(:,1)==matchitem(:,2)&matchitem(:,1)~=5)...
%         |(matchitem(:,1)==matchitem(:,3)&matchitem(:,1)~=5)|...
%         (matchitem(:,3)==matchitem(:,2)&matchitem(:,2)~=5)),:);
%     else
%         matchitem=matchitem(~((matchitem(:,1)==matchitem(:,2))&(matchitem(:,1)~=5)),:);
%     end
% end
matchitem=A(:,1:end-1);
[item,~]=size(matchitem);
result=zeros(item,2);
ratio=zeros(item,1);
N=zeros(item,1);
D=cell(item,1);

for i=1:item   %遍历matchitem的所有项
    if p==2
        index=find((data(:,1)==matchitem(i,1)& data(:,2)==matchitem(i,2))...
                    |(data(:,1)==matchitem(i,1)& data(:,3)==matchitem(i,2))...
                    |(data(:,2)==matchitem(i,1)& data(:,3)==matchitem(i,2)));

    else
        index=find(data(:,1)==matchitem(i,1)&data(:,2)==matchitem(i,2)&data(:,3)==matchitem(i,3));
    end
    
    
    D{i}=diff(index);
    Dmax=A(i,end);
%     Dmax=max(D{i});
    shengyu=m-max(index);
    if isempty(D{i})
        result(i,1)=m;
        result(i,2)=A(i,end);
    else
        result(i,:)=[ shengyu Dmax];
        ratio(i)=shengyu/Dmax;
        N(i)=length(index);
    end
end


tf=(ratio>=FZ)&(A(:,end)>0);
result=round(result(tf,:));
ratio=ratio(tf,:);
matchitem=matchitem(tf,:);
N=N(tf,:);
D=D(tf);
end

