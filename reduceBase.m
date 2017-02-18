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

