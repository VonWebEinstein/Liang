function [  ] = parseZhongHorse(handles)
% parse zhong horse中馬
%   http://keiba.yahoo.co.jp/race/result/1504010101/

%比賽結果列表，按月 http://keiba.yahoo.co.jp/schedule/list/2015/?month=1
%比賽結果
extraldata=importdata([pwd,'\extraldata\中馬\regexp.txt']);
%场地
set(handles.text_updateStatus,'string','');
pause(0.01);
% race=importdata([pwd, '\比賽結果\中馬\00_所有場地.txt']);
race=handles.matchname;
%已保存数据的开始的日期和结束的日期 ， 天数
for i=1:length(race)
    %没有数据则生成空文件
    dlmwrite([pwd '\比賽結果\中馬\' race{i} '.txt'],[] ,'-append','delimiter', ' ', 'newline','pc');
    tmp=importdata([pwd '\比賽結果\中馬\' race{i} '.txt']);
    %从文件名中取出场次编号
    ii=str2double(race{i}(1:2));
    %空文件更新日期置为零
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
tmp=[];
%是否是更新的第一天
isfirstday=1;

lastdatevec=datevec(ld);
todayvec=datevec(floor(now));
%按年、月、场次、赛次 读取数据
for yearloop=lastdatevec(1):todayvec(1)
    %更新月份的起止
    if yearloop==todayvec(1)
        endmonth=todayvec(2);
    else
        endmonth=12;
    end
    if lastdatevec(1)==yearloop
        startmonth=lastdatevec(2);
    else
        startmonth=1;
    end
    
    for monthloop=startmonth:endmonth
        for i=1:3
            [matchlist, status]=urlread(sprintf(extraldata{2},yearloop,monthloop));
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
        
        %获取有比赛的日期
        days=regexpi(matchlist, extraldata{3}, 'tokens');
        %转成数字
        daytmp=[];
        for i=1:length(days)
            daytmp(i)=str2double(days{i}{1});
        end
        days=daytmp;
        %获取相应比賽結果的地址
        urls=regexpi(matchlist,extraldata{4}, 'tokens');
        %更新日期的起止
        if yearloop==todayvec(1)&&monthloop==todayvec(2)
            endday=todayvec(3);
        else
            endday=31;
        end
        if lastdatevec(1)==yearloop&&lastdatevec(2)==monthloop
            startday=lastdatevec(3);
        else
            startday=1;
        end
        %筛选出要更新的日期
        daystmp=days>=startday&days<=endday;
        days=days(daystmp);
        urls=urls(daystmp);
        %按天更新,  dayloop
        for dayi=1:length(days)
            dayloop=days(dayi);
            curdate=yearloop*10000+monthloop*100+dayloop;
            %获取场地，第16，17 个字符
            matchplace= str2double(urls{dayi}{1}([16 17]));
            %按场次更新
            %若是只更新当天结果，可先读取时间判断更新那些场次，待完善
            urls{dayi}{1}(end-2:end)='';
            urls{dayi}{1}=[urls{dayi}{1} '%02d'];
            dataofday=[];
            
            for nR=1:12
                if nR>1&&~ismember(nR, Nrace)
                    continue
                end
%                 disp([num2str(yearloop) '/' num2str(monthloop) '/' num2str(dayloop) '—' race{matchplace} '-' num2str(nR) 'R']);
                set(handles.text_updateStatus,'string',[num2str(yearloop) '/' num2str(monthloop) '/' num2str(dayloop) '—' race{matchplace} '-' num2str(nR) 'R']);
                pause(0.01)
                resultofnR_tmp={};
                for i=1:3
                    [resultofnR, status]=urlread([extraldata{1} sprintf(urls{dayi}{1}, nR)]);
                    table=regexpi(resultofnR, extraldata{5}, 'match');
                    if status&&length(table)>=4
                        break;
                    else
                        resultofnR_tmp{i}=resultofnR;
                        pause(10);
                    end
                end
                %如果三次的读取的结果相同，表格数还是小于4，那是比赛取消了，continue
                if i==3&&length(table)<4&&status&&(length(resultofnR_tmp{1})==length(resultofnR_tmp{2})||...
                        length(resultofnR_tmp{1})==length(resultofnR_tmp{3}))
                    continue
                end
                if ~status
                    set(handles.text_updateStatus,'string','請重試或檢查網絡連接');
                    pause(0.01);
                end
                
                
                
%                 table=regexpi(resultofnR, '<table.*?/table>', 'match');
                %比赛不一定是12场,缺少的也有可能是中间的场次
                %读取页面上1R 2R......12R等数字，确定有哪些场次
                if nR==1
                    nrace=regexpi(table{1}, '>(\d+?)R<','tokens');
                    Nrace=[];
                    for nofnR=1:length(nrace)-1
                        Nrace(nofnR)=str2double(nrace{nofnR}{1});
                    end
                end
                %提取表格，要第2,3,4个表
                dataoftable=parseTableFromHTML( table{2}, extraldata{6} ,'tokens');
                dataoftable1={[] []};
                for i=1:length(dataoftable(:,1))
                    if strcmp('枠連',decell(dataoftable{i}))
                        dataoftable1{1}=decell(dataoftable{i,4});
                    elseif strcmp('馬連',decell(dataoftable{i}))
                        dataoftable1{2}=decell(dataoftable{i,4});
                    end
                end
                dataoftable=parseTableFromHTML( table{3}, extraldata{6} ,'tokens');
                dataoftable2={[] [] [] [] [] []};
                %三个ワイド,2,3,4，只取前三个
                %馬单，3連复，3連单，只取第一个
                madan=0;liandan=0;lianfu=0;
                klf=2;
                for i=1:length(dataoftable(:,1))
                    if strcmp('馬単',decell(dataoftable{i,1}))
                        if madan>0
                            continue
                        end
                        dataoftable2{1}=decell(dataoftable{i,4});
                        madan=madan+1;
                    elseif strcmp('ワイド',decell(dataoftable{i,1}))
                        if klf>4
                            continue
                        end
                        dataoftable2{klf}=decell(dataoftable{i,4});
                        klf=klf+1;
                    elseif strcmp('3連複',decell(dataoftable{i,1}))
                        if lianfu>0
                            continue
                        end
                        dataoftable2{5}=decell(dataoftable{i,4});
                        lianfu=lianfu+1;
                    elseif strcmp('3連単',decell(dataoftable{i,1}))
                        if liandan>0
                            continue
                        end
                        dataoftable2{6}=decell(dataoftable{i,4});
                        liandan=liandan+1;
                    end
                end
                dataoftable=parseTableFromHTML( table{4}, extraldata{7} ,'match');
                dataoftable3=[dataoftable(2:4,2)' dataoftable(2:4,3)' dataoftable(2:4,13)'];
                %结果合并成一行
                tmp=[dataoftable3 dataoftable1 dataoftable2];
                %转成数值
                dataofnR=[];
                for i=1:length(tmp)
                    tmp2=decell(tmp{i});
                    if isempty(tmp2)
                        dataofnR(i)=0;
                    else
                        dataofnR(i)=str2double(tmp2);
                    end
                end
                dataofday=[dataofday; curdate dataofnR];
            end
            %写入当天的数据到txt
            filename=[pwd '\比賽結果\中馬\' race{matchplace} '.txt'];
            % 检查最后一天的数据是否完整
            if isfirstday&&(lastdate(matchplace)==datenum([yearloop,monthloop,dayloop,0,0,0]))
                oridata=importdata(filename);
                %检查最后一天数据是否完整
                tf=oridata(:,1)==curdate;
                if isequal(oridata(tf,:), dataofday)
                    continue
                else
                    dataofday=[oridata(~tf,:); dataofday];
                    fp = fopen(filename, 'wt');
                    fprintf(fp, '%d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d %d\n', dataofday');
                    fclose(fp);
                end
            else
                dlmwrite(filename, dataofday,'precision','%d' ,'-append','delimiter', ' ', 'newline','pc');
            end
            
        end
        %清除更新第一天的标记
        isfirstday=0;
    end
end
end


