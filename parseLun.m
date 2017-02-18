function []=parseLun( handles)
%parse bicycle���г�
%��ѯĿ¼
%http://kdreams.jp/index.php?kcd=&yyfm=2012&mmfm=10&ddfm=06&yyto=2014&mmto=06&ddto=06&gr=&ac=Result_List&sd=&page=1
 extraldata=importdata([pwd,'\extraldata\݆\regexp.txt']);
%����
% race=importdata([pwd, '\��ِ�Y��\݆\00_���Ј���.txt']);
race=handles.matchname;
set(handles.text_updateStatus,'string','');
pause(0.01);
allRace={};
%�ѱ������ݵĿ�ʼ�����ںͽ��������� �� ����
for i=1:length(race)
    %û�����������ɿ��ļ�
    dlmwrite([pwd '\��ِ�Y��\݆\' race{i} '.txt'],[] ,'-append','delimiter', ' ', 'newline','pc');
    tmp=importdata([pwd '\��ِ�Y��\݆\' race{i} '.txt']);
    %���ļ�����ȡ�����α��
    ii=str2double(race{i}(1:2));
    %�����������ŵ�ӳ���
    %allRace{n}=name_n
    
    allRace{ii}=race{i}(4:end);
    %���ļ�������Ϊ��
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
%   startdate , lastdate, ���ݵ���������
todayvec=datevec(today);
% todayvec=[2014 7 31 0 0 0];
lastdayvec=datevec(ld);
listsiteAll=extraldata{1};
%   ��ʼ ���� �� �ա���������ֹ���� �� �ա���ҳ��
%��ѯҪ���µ����б���
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
    set(handles.text_updateStatus,'string','Ո��ԇ��z��W�j�B��');
    pause(0.01);
end
%��������
N=regexp(list,extraldata{2},'tokens');
N=str2double(N{1}{1});
%ҳ��
pages=ceil(N/15);
%�����ȡÿһҳ
for pageloop=-(-pages:-1)
    %�������ֻ��һҳ���ͽ�����һҳ
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
            set(handles.text_updateStatus,'string','Ո��ԇ��z��W�j�B��');
            pause(0.01);
        end
    end
    racelist=parseTableFromHTML( curpage, '.*', 'match' );
    racedate={};
    racename={};
    racesite={};
    for raceN=1:size(racelist,1)-1
        %����е����ڣ�����������ַ
        tmp=regexp(racelist{raceN+1,1}{1}, extraldata{3},'match');
        racedate{raceN}=[tmp{1}, tmp{2}, tmp{3}];  %string
        tmp=regexp(racelist{raceN+1,2}{1}, extraldata{4},'tokens');
        racename{raceN}=tmp{1}{1};
        tmp=regexp(racelist{raceN+1,4}{1}, extraldata{5},'tokens');
        racesite{raceN}=decell(tmp);
        % ; �滻Ϊ &
        if ~isempty(racesite{raceN})
            racesite{raceN}=strrep(racesite{raceN},';','&');
        end
    end
    %��ȡҳ���µ����б���
    %�����ȡ
    for raceofPage=-(-length(racedate):-1)
        curdate=str2double(racedate{raceofPage});%20140103
        curdatevec=datevec(datenum(racedate{raceofPage}, 'yyyymmdd'));
        %���ر��
        Nmatch=find(cellisequal(allRace, racename(raceofPage)));
        %�ļ���
        filename=sprintf('%02d_%s', Nmatch, allRace{Nmatch});
        fname=[pwd '\��ِ�Y��\݆\' filename '.txt'];
        %��ʾ
%         disp(sprintf('%d/%02d/%02d��%s', curdatevec(1),curdatevec(2),curdatevec(3),filename));
        set(handles.text_updateStatus,'string',sprintf('%d/%02d/%02d��%s', curdatevec(1),curdatevec(2),curdatevec(3),filename));
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
            set(handles.text_updateStatus,'string','Ո��ԇ��z��W�j�B��');
            pause(0.01);
        end
        
        %tables
        tables=regexpi(singleRace,'<table.*?/table>','match');
        outdata1=[];
        outdata2=[];
        outdata3=[];
        %tablesWithNonData û�б��������R���Ϊ0
        tablesWithNonData=[];
        for i_table=1:length(tables)
            %ɸѡ�����ȹ�С�ı��
            if length(tables{i_table})<300
                tablesWithNonData=[tablesWithNonData;0];
                continue
            end
            %�������ı�����
            if ~isempty(regexpi(tables{i_table}, '>1��<','match'))
                continue
            end
            %�н���ģ�R���Ϊ1
            tablesWithNonData=[tablesWithNonData;1];
            dataOfTable = parseTableFromHTML( tables{i_table}, '.*', 'match' );
            %2���B-��������(2,3)
            tmp=regexpi(dataOfTable{2,3}{1},'>(\d)-(\d)<', 'tokens');
            if isempty(tmp)
                outdata1=[outdata1;0 0];
            else
                outdata1=[outdata1;str2double(tmp{1}{1}) str2double(tmp{1}{2}) ];
            end
            %3�B���� ����(2,11)
            tmp=regexpi(dataOfTable{2,11}{1},'>(\d)-(\d)-(\d)<', 'tokens');
            if isempty(tmp)
                outdata2=[outdata2;0 0 0];
            else
                outdata2=[outdata2;str2double(tmp{1}{1}) str2double(tmp{1}{2}) str2double(tmp{1}{3})];
            end
        end
        
        %nR
        tmp=regexpi(singleRace,'">(\d*)R��','tokens');
        for i=1:length(tmp)
            outdata3(i)=str2double(tmp{i}{1});
        end
        %ȥ��û�н����R���
        outdata3=outdata3(logical(tablesWithNonData))';
        
%         singleResult=regexp(singleRace,extraldata{6},'tokens');
%         %ת����ֵ
%         data=[];
%         for rloop=1:length(singleResult)
%             data=[data; str2double(singleResult{rloop}{1}), str2double(singleResult{rloop}{2}), str2double(singleResult{rloop}{3})];
%         end
        %�������
        data=[outdata3 outdata2 outdata1];
        data=[repmat(curdate,size(data,1),1),data];
        %���µĵ�һ�죬������Ҫ�Ƚϵı���
        if  ld==lastdate(Nmatch)&&datenum(num2str(curdate), 'yyyymmdd')==ld
            %�û������һ�������
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
            %fp = fopen([pwd '\��ِ�Y��\ͧ\' filename], 'wt');
            %fprintf(fp, '%d  %d  %d  %d', writedata);
            %fclose(fp);
        end
    end
end



end
