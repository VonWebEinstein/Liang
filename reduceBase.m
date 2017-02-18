function [ c ] = reduceBase( a, lines)
%合并基本图形的集合
%   结束条件：只剩一个或无法合并任何两个

n=length(a);
for i=1:n-1
    for j=i+1:n
        if ~(publicPoints(a{i},a{j})==2)
            continue
        end
        
        %求共线点组数
        points=unique([a{i} a{j}]);
        threepoints=nchoosek(points,3);
        %查找三点是否共线，记录中间点
        cpoint=[];
        for i3p=1:size(threepoints,1)
            %遍历共线点组
            for iol=1:length(lines)
                if all(ismember(threepoints(i3p,:), lines{iol}))
                    cpoint=[cpoint, threepoints(i3p,2)];
                    %发现两组停止？
                end
            end
        end
        %两个凸多边形合并成一个凸多边形，边数不增加
        if isempty(cpoint)
            continue
        else
            %发现可合并
            newbase=setdiff(points, cpoint);
            a([i,j])=[];
            a{end+1}=newbase;
            %返回条件
            if length(a)==1
                c=a;
            else
                c=reduceBase(a,lines);
            end
            return
        end
    end
end
%没有任何两个可合并图形
c=a;


end

