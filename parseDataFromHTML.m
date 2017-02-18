function [   ] = parseDataFromHTML( date , startdate, lastdate, isfirstday, handles)
%parse all tables of boat from http://app.boatrace.jp/race/pay/?day=20150506
%   date is vector of date yyyy mm dd ...
%   function write data to txt with no output variable
%   startdate , lastdate, 数据的起终日期

%extraldata=importdata([pwd,'\extraldata\艇\其他.txt']);
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
    disp('请重试或检查网络连接')
end

% count table number
mexp='<table>(.*?)</table>';
table=regexp(sourcefile, mexp, 'match');
for i=1:length(table)
    %几R,结果，场地名称
    [ outdata ] = parseTableFromHTML( table{i} , ...
        'src="/race/img/txt_th_(\d*)r\.gif"|src="/race/img/num_(\d*)\.gif"|<img\ssrc="/race/img/place_(\d*)\.gif"\sclass="rollOver"\swidth="42"\sheight="14"\salt="(.*?)"','tokens');
    %取包含数据的单元格
    outdata=outdata([1,3:end], [1, 2:3:end]);
    for j=2:size(outdata,2)
        if isempty(decell(outdata{1,j}))
            continue
        else
            %将数据转成数值格式
            writedata=[];
            
            for d1=2:size(outdata,1)
                oneDay=[];%一天的结果
                for d2=1:length(outdata{d1,j})
                    oneDay=[oneDay str2double(outdata{d1,j}{d2}{1})];
                end
                %有的结果只有两个数字,后面补0
                if mod(d2,3)>0
                    oneDay=[oneDay, zeros(1,3-mod(d2,3))];
%                     for d3=1:(3-mod(d2,3))
%                         writedata(end+1)=0;
%                     end
                end
                %若这天有多组结果，重复前面的及R
                if length(oneDay)>3
                    oneDay=reshape(oneDay,3,[])';
                end
                %加上R标记
                oneDay=[str2double(outdata{d1, 1}{1})*ones(size(oneDay,1),1) oneDay];
                
                writedata=[writedata; oneDay];
            end
            %添加日期
            writedata=[ repmat(curdate,size(writedata,1),1) writedata];
            %补上4个0，人气
            writedata=[writedata, zeros(size(writedata,1),4)];
            %保存结果的文件名，参数可选
            filename=sprintf('%s_%s.txt', outdata{1,j}{1}{1}, outdata{1,j}{1}{2});
            filename=[pwd '\比賽結果\艇\' filename];
            %检查最后一天的数据是否完整
            if  isfirstday && (datenum(date)==lastdate(str2double(decell(outdata{1,j}{1}))))
                %置换掉最后一天的数据
                oridata=importdata(filename);
                %追加后面的场次，还是替换掉原来的结果（当且仅当最后一天数据有误）
                dataOfLastDay=oridata(oridata(:,1)==curdate, :);
                
                if isequal(writedata(1:size(dataOfLastDay,1),:), dataOfLastDay) %追加后面的结果
                    if size(dataOfLastDay,1)<size(writedata,1)
                        dlmwrite(filename, writedata(size(dataOfLastDay,1)+1:end, :),'precision','%d' ,'-append','delimiter', ' ', 'newline','pc');
                    end
                else %更改最后一天的结果                    
                    writedata=[oridata(~(oridata(:,1)==curdate),:); writedata];
                    fp = fopen(filename, 'wt');
                    fprintf(fp, '%d %d %d %d %d %d %d %d %d\n', writedata');
                    fclose(fp);
                end
            else
                dlmwrite(filename, writedata,'precision','%d' ,'-append','delimiter', ' ', 'newline','pc');
                %fp = fopen([pwd '\比赛结果\艇\' filename], 'wt');
                %fprintf(fp, '%d  %d  %d  %d', writedata);
                %fclose(fp);
            end
        end
    end
end
end


