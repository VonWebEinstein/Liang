function [ F ] = generate1Fenmu( data )
%%����1�����ķ�ĸ
%   �����ڸ���һλ��������ʽ
%   F��NX2����

%��������
if iscell(data)
    m=0;
    for i=1:length(data)
        if isempty(data{i})
            continue
        end
        m=max(m,max(data{i}));
    end
else
    m=max(0,max(data));
end

F=[(1:m)', zeros(m,1)];

end

