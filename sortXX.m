function [ R ] = sortXX(XX)
% ����R������R�Ľ���ֿ�
XX1=[];XX2=[];
for i=2:size(XX,1)
    if isempty(strfind(XX{i,1},'R'))
        XX1=[XX1;XX(i,:)];%����R
    else
        XX2=[XX2;XX(i,:)];%����R
    end
end
    R=[XX(1,:);sort_1(XX1);sort_1(XX2)];
end
function [ R ] = sort_1( XX )
%�ѽ������matchitem����
%   XX��ϸ������matchitem���ַ������ɵ�ϸ��

m=[]; %���matchitem
m1=[]; m2=[]; %����ʽ������ʽ
R=[]; %�������XX��ʽ��ͬ
R1=[]; %����ʽ
R2=[]; %����ʽ
for i=1:size(XX,1)
    if isempty(strfind(XX{i,2}, '�˚�'))
        R1=[R1;XX(i,:)];
        mt=str2num(XX{i,3});
        m1=[m1;[mt zeros(1,3-length(mt))]];
    else
        R2=[R2;XX(i,:)];
        m2=[m2; str2num(XX{i,3})];
    end
end

[~,index]=sortrows(m1);
R1=R1(index,:);
[~,index]=sortrows(m2);
R2=R2(index,:);
R=[R1;R2];
end


