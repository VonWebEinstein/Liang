function [ n ] = publicPoints( a,b )
%ͳ������ͼ�ι����������
%   a,bΪ������ŵļ���
c=zeros(size(b));
for i=1:length(a)
    c=c+~(b-a(i));
end
n=sum(c);
end

