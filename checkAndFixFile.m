function checkAndFixFile( fileStr, mat ,n)
%检查txt文件file的末尾是否和mat一致，不一致则修改该文件
%   fileStr位文件路径
%   每一行有n位数字

data=importdata(fileStr);
if isempty(mat)
    return
end
% dataOfLastDay=data(data(:,1)==date(end,1), :);
m=size(mat,1);
if isequal(mat, data((end-m+1):end,:)) 
else %更改最后一天的结果
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

