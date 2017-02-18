[sourcefile, status] =urlread(sprintf('http://888.qq.com/info/chart/fc3d/index.php?op=fb&from=2015000&to=2015999'));

if ~status
    
    error('读取错误\n')
    
end

%获取日期

expr1='<td align="center">(\d\d\d\d-\d\d-\d\d)</td>';

[datefile, date_tokens]= regexp(sourcefile, expr1, 'match', 'tokens');

date = cell(size(date_tokens));

for idx = 1:length(date_tokens)
    
    date{idx} = date_tokens{idx}{1}; 
    
end



%%获取3D的三位数字

expr2='<td class="chartBall01" width=18>(\d)</td>';

[datafile, data_tokens] = regexp(sourcefile, expr2, 'match', 'tokens');

data = zeros(size(data_tokens));

for idx = 1:length(data_tokens)
    
    data(idx) = str2double(data_tokens{idx}{1});
    
end



data1=reshape(data,3,length(data)/3)';

%%%数据存储外部文件

fprintf('完成！\n')