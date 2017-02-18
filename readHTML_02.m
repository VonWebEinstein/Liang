clc;
clear;
warning off;
for year = 2014:2014      %年份
    for season = 1:1      %季度
        fprintf('%d年%d季度的数据...', year, season)
        [sourcefile, status] = urlread(sprintf('http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_MarketHistory/stockid/000001/type/S.phtml?year=%d&season=%d', year));
        if ~status
            error('读取出错！\n')
        end
        expr1 = '\s+(\d\d\d\d-\d\d-\d\d)\s*';    %获取日期（'s'空格字符间的日期数据）
        [datefile, date_tokens]= regexp(sourcefile, expr1, 'match', 'tokens');   %返回正则表达式的两个关键字 'match'和 'tokens'
        date = cell(size(date_tokens));
        for idx = 1:length(date_tokens)
            date{idx} = date_tokens{idx}{1};    %date_token的每个元素都是1x1cell
        end
        expr2 = '<div align="center">(\d*\.?\d*)</div>'; %从源文件中获取目标数据
        [datafile, data_tokens] = regexp(sourcefile, expr2, 'match', 'tokens');
        data = zeros(size(data_tokens));
        for idx = 1:length(data_tokens)
            data(idx) = str2double(data_tokens{idx}{1});       %length(data_tokens)行 1列
        end
        
        data = reshape(data, 6, length(data)/6 )'; %重排 数据表格形式为6列，（length(data)/6）行）
        filename = sprintf('%d年',year);     %文件名
        pathname = [pwd '\data'];      %路径名
        if ~exist(pathname,'dir')
            mkdir(pathname);
        end
        fullfilepath = [pwd '\data\' filename];
        % 保存数据到Excel
        sheet = sprintf('第%d季度', season);     %工作表名称
        xlswrite(fullfilepath, date' , sheet);
        range = sprintf('B1:%s%d',char(double('B')+size(data,2)-1), size(data,1)); %从源文件中获取的目标数据的放置范围
        xlswrite(fullfilepath, data, sheet, range);
        fprintf('OK!\n')
    end
end
fprintf('全部完成！\n')