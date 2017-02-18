function [   ] = parseDataFromHTML( date , startdate, lastdate, isfirstday, handles)
%parse all tables of boat from http://app.boatrace.jp/race/pay/?day=20150506
%   date is vector of date yyyy mm dd ...
%   function write data to txt with no output variable
%   startdate , lastdate, ���ݵ���������

%extraldata=importdata([pwd,'\extraldata\ͧ\����.txt']);
website='http://app.boatrace.jp/race/pay/?day=%d%02d%02d';
website=sprintf(website, date(1),date(2),date(3));
curdate=date(1)*10000+date(2)*100+date(3);
set(handles.text_updateStatus,'string',sprintf('%d/%02d/%02d',date(1), date(2), date(3)));
pause(0.01);
for i=1:3
    [sourcefile, status] =urlread(website);
    if status
        break;
    end
end
if ~status
    disp('�����Ի�����������')
end

% count table number
mexp='<table>(.*?)</table>';
table=regexp(sourcefile, mexp, 'match');
for i=1:length(table)
    %��R,�������������
    [ outdata ] = parseTableFromHTML( table{i} , ...
        'src="/race/img/txt_th_(\d*)r\.gif"|src="/race/img/num_(\d*)\.gif"|<img\ssrc="/race/img/place_(\d*)\.gif"\sclass="rollOver"\swidth="42"\sheight="14"\salt="(.*?)"','tokens');
    %ȡ�������ݵĵ�Ԫ��
    outdata=outdata([1,3:end], [1, 2:3:end]);
    for j=2:size(outdata,2)
        if isempty(decell(outdata{1,j}))
            continue
        else
            %������ת����ֵ��ʽ
            writedata=[];
            
            for d1=2:size(outdata,1)
                oneDay=[];%һ��Ľ��
                for d2=1:length(outdata{d1,j})
                    oneDay=[oneDay str2double(outdata{d1,j}{d2}{1})];
                end
                %�еĽ��ֻ����������,���油0
                if mod(d2,3)>0
                    oneDay=[oneDay, zeros(1,3-mod(d2,3))];
%                     for d3=1:(3-mod(d2,3))
%                         writedata(end+1)=0;
%                     end
                end
                %�������ж��������ظ�ǰ��ļ�R
                if length(oneDay)>3
                    oneDay=reshape(oneDay,3,[])';
                end
                %����R���
                oneDay=[str2double(outdata{d1, 1}{1})*ones(size(oneDay,1),1) oneDay];
                
                writedata=[writedata; oneDay];
            end
            %�������
            writedata=[ repmat(curdate,size(writedata,1),1) writedata];
            %����4��0������
            writedata=[writedata, zeros(size(writedata,1),4)];
            %���������ļ�����������ѡ
            filename=sprintf('%s_%s.txt', outdata{1,j}{1}{1}, outdata{1,j}{1}{2});
            filename=[pwd '\��ِ�Y��\ͧ\' filename];
            %������һ��������Ƿ�����
            if  isfirstday && (datenum(date)==lastdate(str2double(decell(outdata{1,j}{1}))))
                %�û������һ�������
                oridata=importdata(filename);
                %׷�Ӻ���ĳ��Σ������滻��ԭ���Ľ�������ҽ������һ����������
                dataOfLastDay=oridata(oridata(:,1)==curdate, :);
                
                if isequal(writedata(1:size(dataOfLastDay,1),:), dataOfLastDay) %׷�Ӻ���Ľ��
                    if size(dataOfLastDay,1)<size(writedata,1)
                        dlmwrite(filename, writedata(size(dataOfLastDay,1)+1:end, :),'precision','%d' ,'-append','delimiter', ' ', 'newline','pc');
                    end
                else %�������һ��Ľ��                    
                    writedata=[oridata(~(oridata(:,1)==curdate),:); writedata];
                    fp = fopen(filename, 'wt');
                    fprintf(fp, '%d %d %d %d %d %d %d %d %d\n', writedata');
                    fclose(fp);
                end
            else
                dlmwrite(filename, writedata,'precision','%d' ,'-append','delimiter', ' ', 'newline','pc');
                %fp = fopen([pwd '\�������\ͧ\' filename], 'wt');
                %fprintf(fp, '%d  %d  %d  %d', writedata);
                %fclose(fp);
            end
        end
    end
end
end


