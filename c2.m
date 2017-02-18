function [D, result, ratio,matchitem,N] = c2(data,p,A,FZ )
%双着
%data为m·2矩阵
%结果result，为m·4矩阵
%matchitem为比较项，是所有出现的项，为m·2矩阵
% p=1,有序，p=其他，无序
[m, n]=size(data);
% valuemax=max(max(data));
% yuansu=unique(data);
matchitem=A(:,1:end-1);
% if p==1
% else
%     matchitem=unique(sort(matchitem,2),'rows');
% end
% if re==1
%     if p==1
%     matchitem=matchitem(~(matchitem(:,1)==matchitem(:,2)),:);
%     else
%         matchitem=matchitem(~((matchitem(:,1)==matchitem(:,2))&(matchitem(:,1)~=5)),:);
%     end
% else
%     if p==1
%         matchitem=matchitem(~(matchitem(:,1)==matchitem(:,2)),:);
%     end
% end
item=max(size(matchitem));

% if valuemax <10
%     datanew=data(:,1)*10+data(:,2);
%
%     matchitemnew=(matchitem(:,1)*10+matchitem(:,2))';
%
%     [ result, ratio ] = c1(datanew,matchitemnew );
% else
N=zeros(item,1);
result=zeros(item,2);
ratio=zeros(item,1);
D=cell(item,1);
for i=1:item   %遍历matchitem的所有项
    if p==1
        
        index=find(data(:,1)==matchitem(i,1)&data(:,2)==matchitem(i,2));
    else
        index=find(data(:,1).*data(:,2)==matchitem(i,1).*matchitem(i,2)&data(:,1)+data(:,2)==matchitem(i,1)+matchitem(i,2));
    end
    
    D{i}=diff(index);
  
    Dmax=A(i,end);
    shengyu=m-max(index);
    if isempty(D{i})
        result(i,1)=m;
         result(i,2)=A(i,end);
    else
        result(i,:)=[shengyu Dmax];
        ratio(i)=shengyu/Dmax;
        N(i)=length(index);
    end
end

tf=(ratio>=FZ)&(A(:,end)>0);

D=D(tf);
result=round(result(tf,:));
ratio=ratio(tf,:);
matchitem=matchitem(tf,:);
N=N(tf,:);
end

