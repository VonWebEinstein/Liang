function [ R ] = sortXX(XX)
% 单独R与所有R的结果分开
XX1=[];XX2=[];
for i=2:size(XX,1)
    if isempty(strfind(XX{i,1},'R'))
        XX1=[XX1;XX(i,:)];%所有R
    else
        XX2=[XX2;XX(i,:)];%单独R
    end
end
    R=[XX(1,:);sort_1(XX1);sort_1(XX2)];
end
function [ R ] = sort_1( XX )
%把结果按照matchitem排序
%   XX是细胞矩阵，matchitem是字符串构成的细胞

m=[]; %存放matchitem
m1=[]; m2=[]; %数字式，人气式
R=[]; %结果，与XX格式相同
R1=[]; %数字式
R2=[]; %人气式
for i=1:size(XX,1)
    if isempty(strfind(XX{i,2}, '人気'))
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


