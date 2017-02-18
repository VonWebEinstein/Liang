function []=parseLun( handles)
%parse bicycle自行车
%查询目录
%http://kdreams.jp/index.php?kcd=&yyfm=2012&mmfm=10&ddfm=06&yyto=2014&mmto=06&ddto=06&gr=&ac=Result_List&sd=&page=1
 extraldata=importdata([pwd,'\extraldata\輪\regexp.txt']);
%场地
% race=importdata([pwd, '\比賽結果\輪\00_所有場地.txt']);
race=handles.matchname;
set(handles.text_updateStatus,'string','');
pause(0.01);
allRace={};
%已保存数据的开始的日期和结束的日期 ， 天数
for i=1:length(race)
    %没有数据则生成空文件
    dlmwrite([pwd '\比賽結果\輪\' race{i} '.txt'],[] ,'-append','delimiter', ' ', 'newline','pc');
    tmp=importdata([pwd '\比賽結果\輪\' race{i} '.txt']);
    %从文件名中取出场次编号
    ii=str2double(race{i}(1:2));
    %场地名称与编号的映射表
    %allRace{n}=name_n
    
    allRace{ii}=race{i}(4:end);
    %空文件日期置为零
    if isempty(tmp)
        startdate(ii)=0;
        lastdate(ii)=0;
    else
        startdate(ii)=tmp(1,1);
        startdate(ii)=datenum(num2str(startdate(ii)), 'yyyymmdd');
        lastdate(ii)=tmp(end,1);
        lastdate(ii)=datenum(num2str(lastdate(ii)), 'yyyymmdd');
    end
    sd=min(startdate);
    ld=max(lastdate);
end



%   date is vector of date yyyy mm dd ...
%   function write data to txt with no output variable
%   startdate , lastdate, 数据的起终日期
todayvec=datevec(today);
% todayvec=[2014 7 31 0 0 0];
lastdayvec=datevec(ld);
listsiteAll=extraldata{1};
%   起始 ：年 月 日————终止：年 月 日——页数
%查询要更新的所有比赛
listsite=sprintf(listsiteAll, lastdayvec(1), lastdayvec(2), lastdayvec(3), todayvec(1), todayvec(2), todayvec(3), 1);
for i=1:3
    [list, status]=urlread(listsite);
    if status
        break;
    else
        pause(10);
    end
end
if ~status
    set(handles.text_updateStatus,'string','請重試或檢查網絡連接');
    pause(0.01);
end
%比赛数量
N=regexp(list,extraldata{2},'tokens');
N=str2double(N{1}{1});
%页数
pages=ceil(N/15);
%逆序读取每一页
for pageloop=-(-pages:-1)
    %若果结果只有一页，就解析这一页
    if pages==1
        curpage=list;
    else
        for i=1:3
            [curpage, status]=urlread(sprintf(listsiteAll, lastdayvec(1), lastdayvec(2), lastdayvec(3), todayvec(1), todayvec(2), todayvec(3), pageloop));
            if status
                break;
            else
                pause(10);
            end
        end
        if ~status
            set(handles.text_updateStatus,'string','請重試或檢查網絡連接');
            pause(0.01);
        end
    end
    racelist=parseTableFromHTML( curpage, '.*', 'match' );
    racedate={};
    racename={};
    racesite={};
    for raceN=1:size(racelist,1)-1
        %结果中的日期，赛场名，地址
        tmp=regexp(racelist{raceN+1,1}{1}, extraldata{3},'match');
        racedate{raceN}=[tmp{1}, tmp{2}, tmp{3}];  %string
        tmp=regexp(racelist{raceN+1,2}{1}, extraldata{4},'tokens');
        racename{raceN}=tmp{1}{1};
        tmp=regexp(racelist{raceN+1,4}{1}, extraldata{5},'tokens');
        racesite{raceN}=decell(tmp);
        % ; 替换为 &
        if ~isempty(racesite{raceN})
            racesite{raceN}=strrep(racesite{raceN},';','&');
        end
    end
    %读取页面下的所有比赛
    %逆序读取
    for raceofPage=-(-length(racedate):-1)
        curdate=str2double(racedate{raceofPage});%20140103
        curdatevec=datevec(datenum(racedate{raceofPage}, 'yyyymmdd'));
        %场地编号
        Nmatch=find(cellisequal(allRace, racename(raceofPage)));
        %文件名
        filename=sprintf('%02d_%s', Nmatch, allRace{Nmatch});
        fname=[pwd '\比賽結果\輪\' filename '.txt'];
        %显示
%         disp(sprintf('%d/%02d/%02d—%s', curdatevec(1),curdatevec(2),curdatevec(3),filename));
        set(handles.text_updateStatus,'string',sprintf('%d/%02d/%02d—%s', curdatevec(1),curdatevec(2),curdatevec(3),filename));
        pause(0.01)
        if isempty(racesite{raceofPage})
            continue
        end
        
        for i=1:3
            [singleRace,status]=urlread(racesite{raceofPage});
            if status
                break;
            else
                pause(10);
            end
        end
        if ~status
            set(handles.text_updateStatus,'string','請重試或檢查網絡連接');
            pause(0.01);
        end
        
        %tables
        tables=regexpi(singleRace,'<table.*?/table>','match');
        outdata1=[];
        outdata2=[];
        outdata3=[];
        %tablesWithNonData 没有比赛结果的R标记为0
        tablesWithNonData=[];
        for i_table=1:length(tables)
            %筛选掉长度过小的表格
            if length(tables{i_table})<300
                tablesWithNonData=[tablesWithNonData;0];
                continue
            end
            %结果上面的表格忽略
            if ~isempty(regexpi(tables{i_table}, '>1着<','match'))
                continue
            end
            %有结果的，R标记为1
            tablesWithNonData=[tablesWithNonData;1];
            dataOfTable = parseTableFromHTML( tables{i_table}, '.*', 'match' );
            %2枠連-单，坐标(2,3)
            tmp=regexpi(dataOfTable{2,3}{1},'>(\d)-(\d)<', 'tokens');
            if isempty(tmp)
                outdata1=[outdata1;0 0];
            else
                outdata1=[outdata1;str2double(tmp{1}{1}) str2double(tmp{1}{2}) ];
            end
            %3連单， 坐标(2,11)
            tmp=regexpi(dataOfTable{2,11}{1},'>(\d)-(\d)-(\d)<', 'tokens');
            if isempty(tmp)
                outdata2=[outdata2;0 0 0];
            else
                outdata2=[outdata2;str2double(tmp{1}{1}) str2double(tmp{1}{2}) str2double(tmp{1}{3})];
            end
        end
        
        %nR
        tmp=regexpi(singleRace,'">(\d*)R（','tokens');
        for i=1:length(tmp)
            outdata3(i)=str2double(tmp{i}{1});
        end
        %去掉没有结果的R序号
        outdata3=outdata3(logical(tablesWithNonData))';
        
%         singleResult=regexp(singleRace,extraldata{6},'tokens');
%         %转成数值
%         data=[];
%         for rloop=1:length(singleResult)
%             data=[data; str2double(singleResult{rloop}{1}), str2double(singleResult{rloop}{2}), str2double(singleResult{rloop}{3})];
%         end
        %添加日期
        data=[outdata3 outdata2 outdata1];
        data=[repmat(curdate,size(data,1),1),data];
        %更新的第一天，且是需要比较的比赛
        if  ld==lastdate(Nmatch)&&datenum(num2str(curdate), 'yyyymmdd')==ld
            %置换掉最后一天的数据
            oridata=importdata(fname);
            tf=oridata(:,1)==curdate;
            if isequal(oridata(tf,:), data)
                continue
            else
                writedata=[oridata(~(tf),:); data];
                fp = fopen(fname, 'wt');
                fprintf(fp, '%d %d %d %d %d %d %d\n', writedata');
                fclose(fp);
            end
        else
            dlmwrite(fname, data,'precision','%d' ,'-append','delimiter', ' ', 'newline','pc');
            %fp = fopen([pwd '\比賽結果\艇\' filename], 'wt');
            %fprintf(fp, '%d  %d  %d  %d', writedata);
            %fclose(fp);
        end
    end
end



end
