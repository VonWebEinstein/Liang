%从图形数三角形个数
function tranCounts=countTra()
lines={[1 2 8],[1 3 7 9],[1 4 6 10],[1 5 11],[2 3 4 5],[5 6 7 8],[8 9 10 11]};
base={[1 2 3],[1 3 4],[1 4 5],[2 3 7 8],[3 4 6 7],[4 5 6],[8 7 9],[7 6 10 9],[6 5 11 10]};
%遍历所有组合
%几个基本图形
n=1;
status=[];
for baseN=1:length(base)
    allCombination=nchoosek(1:length(base), baseN);
    %每种组合
    for ci=1:size(allCombination,1)
        %基本图形的集合
        eachCombiantion=base(allCombination(ci,:));
        %递归，化简，至不能化简
        eachCombiantion=reduceBase(eachCombiantion,lines);
        if length(eachCombiantion)==1&&length(eachCombiantion{1})==3
            status(n)=1;
        else
            status(n)=0;
        end
        n=n+1;
    end
end
tranCounts=sum(status);
end


function [ n ] = publicPoints( a,b )
%统计两个图形公共点的数量
%   a,b为顶点序号的集合
c=zeros(size(b));
for i=1:length(a)
    c=c+~(b-a(i));
end
n=sum(c);
end


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


