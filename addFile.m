function addFile( fileStr,mat)
%��txt�ļ�ĩβ����mat
%   fileStrλ�ļ�·����matֻ�������־���

dlmwrite(fileStr, mat,'precision','%d' ,'-append','delimiter', ' ', 'newline','pc');

end

