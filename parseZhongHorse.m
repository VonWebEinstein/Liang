function [  ] = parseZhongHorse(handles)
% parse zhong horse���R
%   http://keiba.yahoo.co.jp/race/result/1504010101/

%��ِ�Y���б����� http://keiba.yahoo.co.jp/schedule/list/2015/?month=1
%��ِ�Y��
extraldata=importdata([pwd,'\extraldata\���R\regexp.txt']);
%����
set(handles.text_updateStatus,'string','');
pause(0.01);
% race=importdata([pwd, '\��ِ�Y��\���R\00_���Ј���.txt']);
race=handles.matchname;
%�ѱ������ݵĿ�ʼ�����ںͽ��������� �� ����
for i=1:length(race)
    %û�����������ɿ��ļ�
    dlmwrite([pwd '\��ِ�Y��\���R\' race{i} '.txt'],[] ,'-append','delimiter', ' ', 'newline','pc');
    tmp=importdata([pwd '\��ِ�Y��\���R\' race{i} '.txt']);
    %���ļ�����ȡ�����α��
    ii=str2double(race{i}(1:2));
    %���ļ�����������Ϊ��
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
%�Ƿ��Ǹ��µĵ�һ��
isfirstday=1;

lastdatevec=datevec(ld);
todayvec=datevec(floor(now));
%���ꡢ�¡����Ρ����� ��ȡ����
for yearloop=lastdatevec(1):todayvec(1)
    %�����·ݵ���ֹ
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
            set(handles.text_updateStatus,'string','Ո��ԇ��z��W�j�B��');
            pause(0.01);
        end
        
        %��ȡ�б���������
        days=regexpi(matchlist, extraldata{3}, 'tokens');
        %ת������
        daytmp=[];
        for i=1:length(days)
            daytmp(i)=str2double(days{i}{1});
        end
        days=daytmp;
        %��ȡ��Ӧ��ِ�Y���ĵ�ַ
        urls=regexpi(matchlist,extraldata{4}, 'tokens');
        %�������ڵ���ֹ
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
        %ɸѡ��Ҫ���µ�����
        daystmp=days>=startday&days<=endday;
        days=days(daystmp);
        urls=urls(daystmp);
        %�������,  dayloop
        for dayi=1:length(days)
            dayloop=days(dayi);
            curdate=yearloop*10000+monthloop*100+dayloop;
            %��ȡ���أ���16��17 ���ַ�
            matchplace= str2double(urls{dayi}{1}([16 17]));
            %�����θ���
            %����ֻ���µ����������ȶ�ȡʱ���жϸ�����Щ���Σ�������
            urls{dayi}{1}(end-2:end)='';
            urls{dayi}{1}=[urls{dayi}{1} '%02d'];
            dataofday=[];
            
            for nR=1:12
                if nR>1&&~ismember(nR, Nrace)
                    continue
                end
%                 disp([num2str(yearloop) '/' num2str(monthloop) '/' num2str(dayloop) '��' race{matchplace} '-' num2str(nR) 'R']);
                set(handles.text_updateStatus,'string',[num2str(yearloop) '/' num2str(monthloop) '/' num2str(dayloop) '��' race{matchplace} '-' num2str(nR) 'R']);
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
                %������εĶ�ȡ�Ľ����ͬ�����������С��4�����Ǳ���ȡ���ˣ�continue
                if i==3&&length(table)<4&&status&&(length(resultofnR_tmp{1})==length(resultofnR_tmp{2})||...
                        length(resultofnR_tmp{1})==length(resultofnR_tmp{3}))
                    continue
                end
                if ~status
                    set(handles.text_updateStatus,'string','Ո��ԇ��z��W�j�B��');
                    pause(0.01);
                end
                
                
                
%                 table=regexpi(resultofnR, '<table.*?/table>', 'match');
                %������һ����12��,ȱ�ٵ�Ҳ�п������м�ĳ���
                %��ȡҳ����1R 2R......12R�����֣�ȷ������Щ����
                if nR==1
                    nrace=regexpi(table{1}, '>(\d+?)R<','tokens');
                    Nrace=[];
                    for nofnR=1:length(nrace)-1
                        Nrace(nofnR)=str2double(nrace{nofnR}{1});
                    end
                end
                %��ȡ���Ҫ��2,3,4����
                dataoftable=parseTableFromHTML( table{2}, extraldata{6} ,'tokens');
                dataoftable1={[] []};
                for i=1:length(dataoftable(:,1))
                    if strcmp('���B',decell(dataoftable{i}))
                        dataoftable1{1}=decell(dataoftable{i,4});
                    elseif strcmp('�R�B',decell(dataoftable{i}))
                        dataoftable1{2}=decell(dataoftable{i,4});
                    end
                end
                dataoftable=parseTableFromHTML( table{3}, extraldata{6} ,'tokens');
                dataoftable2={[] [] [] [] [] []};
                %�����磻��,2,3,4��ֻȡǰ����
                %�R����3�B����3�B����ֻȡ��һ��
                madan=0;liandan=0;lianfu=0;
                klf=2;
                for i=1:length(dataoftable(:,1))
                    if strcmp('�R�g',decell(dataoftable{i,1}))
                        if madan>0
                            continue
                        end
                        dataoftable2{1}=decell(dataoftable{i,4});
                        madan=madan+1;
                    elseif strcmp('�磻��',decell(dataoftable{i,1}))
                        if klf>4
                            continue
                        end
                        dataoftable2{klf}=decell(dataoftable{i,4});
                        klf=klf+1;
                    elseif strcmp('3�B�}',decell(dataoftable{i,1}))
                        if lianfu>0
                            continue
                        end
                        dataoftable2{5}=decell(dataoftable{i,4});
                        lianfu=lianfu+1;
                    elseif strcmp('3�B�g',decell(dataoftable{i,1}))
                        if liandan>0
                            continue
                        end
                        dataoftable2{6}=decell(dataoftable{i,4});
                        liandan=liandan+1;
                    end
                end
                dataoftable=parseTableFromHTML( table{4}, extraldata{7} ,'match');
                dataoftable3=[dataoftable(2:4,2)' dataoftable(2:4,3)' dataoftable(2:4,13)'];
                %����ϲ���һ��
                tmp=[dataoftable3 dataoftable1 dataoftable2];
                %ת����ֵ
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
            %д�뵱������ݵ�txt
            filename=[pwd '\��ِ�Y��\���R\' race{matchplace} '.txt'];
            % ������һ��������Ƿ�����
            if isfirstday&&(lastdate(matchplace)==datenum([yearloop,monthloop,dayloop,0,0,0]))
                oridata=importdata(filename);
                %������һ�������Ƿ�����
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
        %������µ�һ��ı��
        isfirstday=0;
    end
end
end


