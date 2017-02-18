clc;
clear;
warning off;
for year = 2014:2014      %���
    for season = 1:1      %����
        fprintf('%d��%d���ȵ�����...', year, season)
        [sourcefile, status] = urlread(sprintf('http://vip.stock.finance.sina.com.cn/corp/go.php/vMS_MarketHistory/stockid/000001/type/S.phtml?year=%d&season=%d', year));
        if ~status
            error('��ȡ����\n')
        end
        expr1 = '\s+(\d\d\d\d-\d\d-\d\d)\s*';    %��ȡ���ڣ�'s'�ո��ַ�����������ݣ�
        [datefile, date_tokens]= regexp(sourcefile, expr1, 'match', 'tokens');   %����������ʽ�������ؼ��� 'match'�� 'tokens'
        date = cell(size(date_tokens));
        for idx = 1:length(date_tokens)
            date{idx} = date_tokens{idx}{1};    %date_token��ÿ��Ԫ�ض���1x1cell
        end
        expr2 = '<div align="center">(\d*\.?\d*)</div>'; %��Դ�ļ��л�ȡĿ������
        [datafile, data_tokens] = regexp(sourcefile, expr2, 'match', 'tokens');
        data = zeros(size(data_tokens));
        for idx = 1:length(data_tokens)
            data(idx) = str2double(data_tokens{idx}{1});       %length(data_tokens)�� 1��
        end
        
        data = reshape(data, 6, length(data)/6 )'; %���� ���ݱ����ʽΪ6�У���length(data)/6���У�
        filename = sprintf('%d��',year);     %�ļ���
        pathname = [pwd '\data'];      %·����
        if ~exist(pathname,'dir')
            mkdir(pathname);
        end
        fullfilepath = [pwd '\data\' filename];
        % �������ݵ�Excel
        sheet = sprintf('��%d����', season);     %����������
        xlswrite(fullfilepath, date' , sheet);
        range = sprintf('B1:%s%d',char(double('B')+size(data,2)-1), size(data,1)); %��Դ�ļ��л�ȡ��Ŀ�����ݵķ��÷�Χ
        xlswrite(fullfilepath, data, sheet, range);
        fprintf('OK!\n')
    end
end
fprintf('ȫ����ɣ�\n')