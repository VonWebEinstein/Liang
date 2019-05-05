function []=parseboat(handles )
%parse boat
% 比赛结果一览 http://app.boatrace.jp/race/pay/?day=20160805
% 详细结果一览 http://app.boatrace.jp/race/?day=20160805
% 单场详细结果 http://app.boatrace.jp/race/14_20160802.php?day=20160805&jyo=14&rno=11&type=result
% 网站数据从20030717开始

set(handles.text_updateStatus,'String','正在更新數據，暫勿執行其他操作');
pause(0.01);

% extraldata=importdata([pwd,'\extraldata\艇\regexp.txt']);
%场地

% race=importdata([pwd, '\比賽結果\艇\00_所有場地.txt']);
race=handles.matchname;

%已更新到第几场
updated = [];

olddata = cell(length(race),1);

%已保存数据的开始的日期和结束的日期 ， 天数
for i=1:length(race)
    %没有数据则生成空文件
    dlmwrite([pwd '\比賽結果\艇\' race{i} '.txt'],[] ,'-append','delimiter', ' ', 'newline','pc');
    tmp=importdata([pwd '\比賽結果\艇\' race{i} '.txt']);
    olddata{i} = tmp;
    
    %从文件名中取出场次编号
    ii=str2double(race{i}(1:2));
    %空文件日期置为初始日期
    if isempty(tmp)
        updated(ii)=0;
        startdate(ii)=datenum('20090401','yyyymmdd');
        lastdate(ii)=datenum('20090401','yyyymmdd');
    else
        updated(ii)=tmp(end,2);
        startdate(ii)=tmp(1,1);
        startdate(ii)=datenum(num2str(startdate(ii)), 'yyyymmdd');
        lastdate(ii)=tmp(end,1);
        lastdate(ii)=datenum(num2str(lastdate(ii)), 'yyyymmdd');
    end
    sd=min(startdate);
    ld=max(lastdate);
end

%最后一天（所有场地）的数据更新到第几场
updated=updated.*(lastdate>=ld);

%后面是组合，不更新
race=race(1:24);

% isfirstday 是否是本次更新的第一天
% 仅对更新的第一天做数据的检查
isfirstday=1;
for daynum=ld:today
    date=datevec(daynum);
    day=sum([10000 100 1].*date(1:3));
    %加入更新日期的参数，替换掉最后一天可能不完全的数据
    %     sim_parseDataFromHTML( date , extraldata{1}, extraldata(2:end), startdate, lastdate, isfirstday, handles);
    %     parseDataFromHTML( date, startdate, lastdate, isfirstday, handles);
%     list_url=sprintf('http://app.boatrace.jp/race/?day=%d',day);
    list_url=sprintf('http://www.boatrace.jp/owpc/pc/race/index?hd=%d',day);
    [urls, placeNos]= getResultList(list_url);
    
    % 每个场地
    for i_race=1:length(urls)
        
        % 结果出到第几局了
        s = regexp(urls{i_race}, 'rno=(\d*)&', 'tokens');
        newestR = str2num(s{1}{1});
        
        % 检查 newestR 是否真的是1
        if newestR == 1 
            if isempty(regexp(urlread(sprintf('http://www.boatrace.jp/owpc/pc/race/raceresult?rno=1&jcd=%02d&hd=%d', ...
                placeNos(i_race), ...
                day)), ...
                '３連単', 'match'))
                newestR = 0;
            end
        end
        
        % 从第几局开始更新
        if isfirstday
            startR = updated(placeNos(i_race)) + 1;
        else
            startR = 1;
        end
        
        res = [];
        for i_R = startR:newestR
            message=sprintf('%d/%02d/%02d-%s-%02dR',date(1), date(2), date(3), ...
               handles.matchname{placeNos(i_race)}, i_R);
            set(handles.text_updateStatus,'string',message);
            pause(0.001);
            
            % url of specified match (R)
            urlR = sprintf('http://www.boatrace.jp/owpc/pc/race/raceresult?rno=%d&jcd=%02d&hd=%d', ...
                i_R, placeNos(i_race), day);
            resR = parseSingleMatch(urlR);
            if isempty(resR)
                continue
            end
            
            res = [res; day, i_R, resR];
        end
        
        if isempty(res)
            continue
        end
        
        % 保存当前场地的所有比赛
        filePath=[pwd '\比賽結果\艇\' race{placeNos(i_race)} '.txt'];
%         if ~isempty(olddata{placeNos(i_race)}) && isfirstday
%             checkAndFixFile(filePath, res ,size(res,2));
%         else
%             addFile(filePath, res);
%         end
        
        addFile(filePath, res);
        
    end
    
    % 第二天去掉首日的标记
    isfirstday = 0;
end


end
    
    
%     for i_race=1:size(list,1)
%         placeNO=str2double(list{i_race,1}{1});
%         % 检查第一天最后一场是否完整
%         filePath=[pwd '\比賽結果\艇\' race{placeNO} '.txt'];
%         if isfirstday&&updated(placeNO)>0
%             message=sprintf('%d/%02d/%02d-%s_%s-%02dR',date(1), date(2), date(3),list{i_race,1}{1},list{i_race,1}{2},updated(placeNO));
%             set(handles.text_updateStatus,'string',message);
%             pause(0.01);
% 			data_current=parseSingleMatch(list{i_race,updated(placeNO)+1},message);
% 			if isempty(data_current)
% 				continue
% 			end
%             mat=[day updated(placeNO) data_current];
%             checkAndFixFile( filePath, mat ,size(mat,2));
%             
%         end
%         %更新剩余场次
%         mat=[];
%         %不是更新的第一天就不用检查，更新从第一场开始
%         if isfirstday
%             startR=updated(placeNO)+1;
%         else
%             startR=1;
%         end
%         for i_R=startR:toUpdate(i_race)
%             message=sprintf('%d/%02d/%02d-%s_%s-%02dR',date(1), date(2), date(3),list{i_race,1}{1},list{i_race,1}{2},i_R);
%             set(handles.text_updateStatus,'string',message);
%             pause(0.01);
%             if isempty(list{i_race,i_R+1})
%                 continue
%             end
%             m=parseSingleMatch(list{i_race,i_R+1},message);
%             if isempty(m)
%                 continue
%             end
%             mat=[mat; day i_R m];
%         end
%         addFile( filePath,mat);
%     end
%     
%     isfirstday=0;
%     
% end
% % toc
% end

function [urls, placeNos]= getResultList(url)
% url='http://app.boatrace.jp/race/?day=20160813';
for i=1:3
    [sourcefile, status]=urlread(url);
    if status
        break
    end
end


% 20190417 updated
% 抓取每天的所有比赛，返回每场比赛的完整 url 和 场地号


urls = regexp(sourcefile, 'href="(\S*?)">結果<', 'tokens');
placeNos = zeros(size(urls));
for i=1:length(urls)
    urls{i} = ['www.boatrace.jp', urls{i}{1}];
    
    s = regexp(urls{i}, 'jcd=(\d*)&', 'tokens');
    placeNos(i) = str2num(s{1}{1});

end



% mexp='<table.*?</table>';
% table=regexp(sourcefile, mexp, 'match');
% if isempty(table)&&status
%     table=[]; toUpdate=[];
%     return
% end
% table= parseTableFromHTML( table{1}, '.*', 'match' );
% table= table(2:end,[1 6:17]);
% fieldname=[];
% 
% % 已经出了几场成绩
% toUpdate=zeros(size(table,1),1);
% for i=1:size(table,1)
%     % 取出第一列，场地
%     fieldname=regexp(table{i,1}{1},'src="/shared/img/place_(\d*)\.gif"\s*class="rollOver"\swidth="42"\sheight="14"\salt="(.*?)"','tokens');
%     if ~isempty(fieldname)
%         table{i,1}=fieldname{1};
%     end
%     % 取出详细结果的地址
%     href=[];
%     for j=2:size(table,2)
%         href=regexp(table{i,j}{1},'href="(.*?)"\sclass="result">結果','tokens');
%         if ~isempty(href)
%             href=['http://app.boatrace.jp' decell(href)];
%         end
%         table{i,j}=href;
%         if ~isempty(href)
%             toUpdate(i)=j-1;
%         end
%     end
% end
end

function result= parseSingleMatch(url)
% 读取船的单场比赛详细结果

% url='http://app.boatrace.jp/race/14_20160802.php?day=20160805&jyo=14&rno=11&type=result';
button='重試';
status=0;
while (strcmp(button,'重試')&&~status)
    for i=1:3
        [str, status]=urlread(url);
        if status
            break
        end
    end
    if ~status
        button = questdlg(['讀取失敗'],'title','重試','跳過','跳過');
    end
end
if strcmp(button,'跳過')
    result=[];
    return
end

% 比赛停止则跳过
if ~isempty(regexp(str, 'レース中止', 'match'))
    result = [];
    return
end

mexp='<table.*?</table>';
tables=regexp(str, mexp, 'match');

% 一般table{4}是想要的，但有意外
whichtable=4;
if length(tables) ~= 7
    for whichtable = 1:length(tables)
        if ~isempty(regexp(tables{whichtable}, '3連単', 'match'))
            break
        end
    end
end

table= parseTableFromHTML(tables{whichtable}, '&yen;([,\d]*)<', 'tokens' );
% 数据记录顺序
% 日期 场次 结果(3位) 单胜1  复胜1   复胜2 二连胜单12 二连胜复12 三连胜单 三连胜复 扩联复12 扩联复13 扩联复23
% .1....2....3.4.5....6.....7.....8......9.........10.......11........12......13......14......15
% 在网页表格中的坐标..(15,3).(17,3).(18,3).(6,3).....(8,3).....(2,3)...(4,3).. (10,3)..(11,3)..(12,3)

%奖金的横坐标
t=[15, 17, 18, 6, 8 ,2, 4, 10, 11, 12];
reward=zeros(1,length(t));
for i=1:length(reward)
    if isempty(table{t(i),3})
        reward(i)=0;
    else
        reward(i)=str2double(table{t(i),3}{1}{1});
    end
end

% 三联单，从结果所在的表里提取排名
result=regexp(tables{whichtable},'(\d)">\1<','tokens');
% 取前三名
f=@(x) str2double(result{x}{1});
result=arrayfun(f,1:length(result));
if length(result)>=3
    result=result(1:3);
else
    result=[result zeros(1,3-length(result))];
end

% 合并结果
result=[result reward];

end
