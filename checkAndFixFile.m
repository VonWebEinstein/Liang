function checkAndFixFile( fileStr, mat ,n)
%���txt�ļ�file��ĩβ�Ƿ��matһ�£���һ�����޸ĸ��ļ�
%   fileStrλ�ļ�·��
%   ÿһ����nλ����

data=importdata(fileStr);
if isempty(mat)
    return
end
% dataOfLastDay=data(data(:,1)==date(end,1), :);
m=size(mat,1);
if isequal(mat, data((end-m+1):end,:)) 
else %�������һ��Ľ��
    data((end-m+1):end,:)=mat;
    fp = fopen(fileStr, 'wt');
    str='';
    for i=1:n-1
        str=[str '%d '];
    end
    fprintf(fp, [str '%d\n'], data');
    fclose(fp);
end

end

