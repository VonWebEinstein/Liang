function []=parseboat(handles )
%parse boat
% �������һ�� http://app.boatrace.jp/race/pay/?day=20160805
% ��ϸ���һ�� http://app.boatrace.jp/race/?day=20160805
% ������ϸ��� http://app.boatrace.jp/race/14_20160802.php?day=20160805&jyo=14&rno=11&type=result
% ��վ���ݴ�20030717��ʼ

set(handles.text_updateStatus,'String','���ڸ�����������������������');
pause(0.01);

% extraldata=importdata([pwd,'\extraldata\ͧ\regexp.txt']);
%����

% race=importdata([pwd, '\��ِ�Y��\ͧ\00_���Ј���.txt']);
race=handles.matchname;

%�Ѹ��µ��ڼ���
updated = [];

olddata = cell(length(race),1);

%�ѱ������ݵĿ�ʼ�����ںͽ��������� �� ����
for i=1:length(race)
    %û�����������ɿ��ļ�
    dlmwrite([pwd '\��ِ�Y��\ͧ\' race{i} '.txt'],[] ,'-append','delimiter', ' ', 'newline','pc');
    tmp=importdata([pwd '\��ِ�Y��\ͧ\' race{i} '.txt']);
    olddata{i} = tmp;
    
    %���ļ�����ȡ�����α��
    ii=str2double(race{i}(1:2));
    %���ļ�������Ϊ��ʼ����
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

%���һ�죨���г��أ������ݸ��µ��ڼ���
updated=updated.*(lastdate>=ld);

%��������ϣ�������
race=race(1:24);

% isfirstday �Ƿ��Ǳ��θ��µĵ�һ��
% ���Ը��µĵ�һ�������ݵļ��
isfirstday=1;
for daynum=ld:today
    date=datevec(daynum);
    day=sum([10000 100 1].*date(1:3));
    %����������ڵĲ������滻�����һ����ܲ���ȫ������
    %     sim_parseDataFromHTML( date , extraldata{1}, extraldata(2:end), startdate, lastdate, isfirstday, handles);
    %     parseDataFromHTML( date, startdate, lastdate, isfirstday, handles);
%     list_url=sprintf('http://app.boatrace.jp/race/?day=%d',day);
    list_url=sprintf('http://www.boatrace.jp/owpc/pc/race/index?hd=%d',day);
    [urls, placeNos]= getResultList(list_url);
    
    % ÿ������
    for i_race=1:length(urls)
        
        % ��������ڼ�����
        s = regexp(urls{i_race}, 'rno=(\d*)&', 'tokens');
        newestR = str2num(s{1}{1});
        
        % ��� newestR �Ƿ������1
        if newestR == 1 
            if isempty(regexp(urlread(sprintf('http://www.boatrace.jp/owpc/pc/race/raceresult?rno=1&jcd=%02d&hd=%d', ...
                placeNos(i_race), ...
                day)), ...
                '���B�g', 'match'))
                newestR = 0;
            end
        end
        
        % �ӵڼ��ֿ�ʼ����
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
        
        % ���浱ǰ���ص����б���
        filePath=[pwd '\��ِ�Y��\ͧ\' race{placeNos(i_race)} '.txt'];
%         if ~isempty(olddata{placeNos(i_race)}) && isfirstday
%             checkAndFixFile(filePath, res ,size(res,2));
%         else
%             addFile(filePath, res);
%         end
        
        addFile(filePath, res);
        
    end
    
    % �ڶ���ȥ�����յı��
    isfirstday = 0;
end


end
    
    
%     for i_race=1:size(list,1)
%         placeNO=str2double(list{i_race,1}{1});
%         % ����һ�����һ���Ƿ�����
%         filePath=[pwd '\��ِ�Y��\ͧ\' race{placeNO} '.txt'];
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
%         %����ʣ�ೡ��
%         mat=[];
%         %���Ǹ��µĵ�һ��Ͳ��ü�飬���´ӵ�һ����ʼ
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
% ץȡÿ������б���������ÿ������������ url �� ���غ�


urls = regexp(sourcefile, 'href="(\S*?)">�Y��<', 'tokens');
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
% % �Ѿ����˼����ɼ�
% toUpdate=zeros(size(table,1),1);
% for i=1:size(table,1)
%     % ȡ����һ�У�����
%     fieldname=regexp(table{i,1}{1},'src="/shared/img/place_(\d*)\.gif"\s*class="rollOver"\swidth="42"\sheight="14"\salt="(.*?)"','tokens');
%     if ~isempty(fieldname)
%         table{i,1}=fieldname{1};
%     end
%     % ȡ����ϸ����ĵ�ַ
%     href=[];
%     for j=2:size(table,2)
%         href=regexp(table{i,j}{1},'href="(.*?)"\sclass="result">�Y��','tokens');
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
% ��ȡ���ĵ���������ϸ���

% url='http://app.boatrace.jp/race/14_20160802.php?day=20160805&jyo=14&rno=11&type=result';
button='��ԇ';
status=0;
while (strcmp(button,'��ԇ')&&~status)
    for i=1:3
        [str, status]=urlread(url);
        if status
            break
        end
    end
    if ~status
        button = questdlg(['�xȡʧ��'],'title','��ԇ','���^','���^');
    end
end
if strcmp(button,'���^')
    result=[];
    return
end

% ����ֹͣ������
if ~isempty(regexp(str, '��`����ֹ', 'match'))
    result = [];
    return
end

mexp='<table.*?</table>';
tables=regexp(str, mexp, 'match');

% һ��table{4}����Ҫ�ģ���������
whichtable=4;
if length(tables) ~= 7
    for whichtable = 1:length(tables)
        if ~isempty(regexp(tables{whichtable}, '3�B�g', 'match'))
            break
        end
    end
end

table= parseTableFromHTML(tables{whichtable}, '&yen;([,\d]*)<', 'tokens' );
% ���ݼ�¼˳��
% ���� ���� ���(3λ) ��ʤ1  ��ʤ1   ��ʤ2 ����ʤ��12 ����ʤ��12 ����ʤ�� ����ʤ�� ������12 ������13 ������23
% .1....2....3.4.5....6.....7.....8......9.........10.......11........12......13......14......15
% ����ҳ����е�����..(15,3).(17,3).(18,3).(6,3).....(8,3).....(2,3)...(4,3).. (10,3)..(11,3)..(12,3)

%����ĺ�����
t=[15, 17, 18, 6, 8 ,2, 4, 10, 11, 12];
reward=zeros(1,length(t));
for i=1:length(reward)
    if isempty(table{t(i),3})
        reward(i)=0;
    else
        reward(i)=str2double(table{t(i),3}{1}{1});
    end
end

% ���������ӽ�����ڵı�����ȡ����
result=regexp(tables{whichtable},'(\d)">\1<','tokens');
% ȡǰ����
f=@(x) str2double(result{x}{1});
result=arrayfun(f,1:length(result));
if length(result)>=3
    result=result(1:3);
else
    result=[result zeros(1,3-length(result))];
end

% �ϲ����
result=[result reward];

end
