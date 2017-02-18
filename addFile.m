function addFile( fileStr,mat)
%向txt文件末尾增加mat
%   fileStr位文件路径，mat只能是数字矩阵

dlmwrite(fileStr, mat,'precision','%d' ,'-append','delimiter', ' ', 'newline','pc');

end

