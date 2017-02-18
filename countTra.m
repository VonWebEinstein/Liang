%��ͼ���������θ���
function tranCounts=countTra()
lines={[1 2 8],[1 3 7 9],[1 4 6 10],[1 5 11],[2 3 4 5],[5 6 7 8],[8 9 10 11]};
base={[1 2 3],[1 3 4],[1 4 5],[2 3 7 8],[3 4 6 7],[4 5 6],[8 7 9],[7 6 10 9],[6 5 11 10]};
%�����������
%��������ͼ��
n=1;
status=[];
for baseN=1:length(base)
    allCombination=nchoosek(1:length(base), baseN);
    %ÿ�����
    for ci=1:size(allCombination,1)
        %����ͼ�εļ���
        eachCombiantion=base(allCombination(ci,:));
        %�ݹ飬���������ܻ���
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
%ͳ������ͼ�ι����������
%   a,bΪ������ŵļ���
c=zeros(size(b));
for i=1:length(a)
    c=c+~(b-a(i));
end
n=sum(c);
end


function [ c ] = reduceBase( a, lines)
%�ϲ�����ͼ�εļ���
%   ����������ֻʣһ�����޷��ϲ��κ�����

n=length(a);
for i=1:n-1
    for j=i+1:n
        if ~(publicPoints(a{i},a{j})==2)
            continue
        end
        
        %���ߵ�����
        points=unique([a{i} a{j}]);
        threepoints=nchoosek(points,3);
        %���������Ƿ��ߣ���¼�м��
        cpoint=[];
        for i3p=1:size(threepoints,1)
            %�������ߵ���
            for iol=1:length(lines)
                if all(ismember(threepoints(i3p,:), lines{iol}))
                    cpoint=[cpoint, threepoints(i3p,2)];
                    %��������ֹͣ��
                end
            end
        end
        %����͹����κϲ���һ��͹����Σ�����������
        if isempty(cpoint)
            continue
        else
            %���ֿɺϲ�
            newbase=setdiff(points, cpoint);
            a([i,j])=[];
            a{end+1}=newbase;
            %��������
            if length(a)==1
                c=a;
            else
                c=reduceBase(a,lines);
            end
            return
        end
    end
end
%û���κ������ɺϲ�ͼ��
c=a;

end


