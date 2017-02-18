function [ F ] = generate1Fenmu( data )
%%产生1个数的分母
%   适用于各种一位数的人气式
%   F是NX2矩阵

%求最大的数
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

