function [ F ] = generate2Fenmu( data )
%%����2�����ķ�ĸ
%   �����ڶ�������������
%   F�� n X 3����

if iscell(data)
    tmp=[];
    for i=1:length(data)
        tmp=[tmp;data{i}];
    end
    data=tmp;
    clear tmp;
end

B1=sortrows(unique(data(:,[1 2]),'rows'));
B1=B1(B1(:,1)>0,:);
B1=[B1, zeros(size(B1,1),1)];

B0=unique(sort(B1(:,[1 2]),2),'rows');
B0=B0(B0(:,1)>0,:);
B0=[B0, zeros(size(B0,1),1)];

F={B1,B0};

end

