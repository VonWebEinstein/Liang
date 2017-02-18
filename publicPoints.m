function [ n ] = publicPoints( a,b )
%统计两个图形公共点的数量
%   a,b为顶点序号的集合
c=zeros(size(b));
for i=1:length(a)
    c=c+~(b-a(i));
end
n=sum(c);
end

