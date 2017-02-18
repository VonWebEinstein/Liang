function searchRecord( handles )
%�ڼ�¼�в�ѯ�ƶ�����Ŀ
%   Detailed explanation goes here
if ~handles.loaded
    allData=loadBoadData(handles);
end
handles.loaded=1;

matchNameNO=get(handles.popupmenu1,'Value');
matchName=handles.matchname{matchNameNO};


%ָ���ĳ���
data=allData{matchNameNO};

searchNO=handles.searchNO;
%������λ
searchNO=[searchNO zeros(1,3-length(searchNO))];
p=get(handles.popupmenu2,'Value');
%���ط�ĸ
fenmustr={'A1','B112','B012','C1','C0','B2'};
for i=1:length(fenmustr)
    fenmuOri{i}=importdata([pwd '\history\ͧ\3�B�g\' fenmustr{i} '.txt']);
end
cols={[1],[1 2],[1 2],[1 2 3],[1 2 3],[1 2]};

%�����
table={};
queryDate=handles.queryDate;
styleList={[1 2 4],[2 4],[3 4],[4],[4 5],[4 6]};
%���������ݱ��е�λ�ã���fenmustr��˳��
rewardLocation=[6 9 10 11 12 13];
%������¼�ֱ�Ҫ��ʾ��Щ���������
rewardToDisplay={[1],[1 2],[3],[1:6],[3 5],[6]};
for date=1:length(queryDate)%����Ҫ��ѯ������
    dataBydate=data(data(:,1)==queryDate(date),:);
    %��ȡ����date֮ǰ�����ݼ���ʣ�ೡ��
    previousdata=data(data(:,1)<queryDate(date),:);
    if isempty(dataBydate)
        continue
    end
    for i=1:length(fenmustr)%����6�־������ͣ�����Ҫ��
        if ~ismember(i,styleList{p})
            continue
        end
        record=searchByStyle(dataBydate,searchNO,fenmustr{i});
        
        
        for j=1:size(record,1)%���������Ͳ鵽�ļ�¼
            %��䵥����¼�ĵ�Ԫ��
            singlRecord={};
            
            singlRecord{1}=record(j,1);%����
            singlRecord{2}=matchName;%����
            singlRecord{3}=handles.matchStyle{i};%��������
            singlRecord{4}=num2str(searchNO(cols{i}));%����
            %��䵥����¼�Ľ���
            for k=1:length(fenmustr)
                if ~ismember(k,rewardToDisplay{i})
                    singlRecord{4+k}='';
                    continue
                end
                %ʣ����
                d=findLast(previousdata,searchNO,fenmustr{k});
                %��ismember �����õ���ʣ�ೡ�ζ�1
                if ~(k==1)
                    d=d-1;
                end
                %��ĸ
                [~,index]=ismember(searchNO(cols{k}),fenmuOri{k}(:,1:end-1),'rows');
                fenmu=fenmuOri{k}(index,end);
                singlRecord{4+k}=sprintf('%dR%d=%0.2f',record(j,2),record(j,rewardLocation(k)),(record(j,2)+d)/fenmu);
            end
            table=[table;singlRecord];
            
        end
    end
    
end
%����ѯ�Ľ����ӵ�����ĩβ
Data=get(handles.uitable,'Data');
if isempty(table)
    set(handles.text_updateStatus,'String','û�н��');
else
    set(handles.uitable,'Data',[Data; table]);
    set(handles.text_updateStatus,'String','�������');
end
pause(0.01);
end
%����������Ѱ����ڹ���
function record =searchByStyle(data,searchNO,style)
switch style
    case 'A1'
        record=data(data(:,3)==searchNO(1),:);
    case 'B112'
        record=data(ismember(data(:,3:4),searchNO(1:2),'rows'),:);
    case 'B012'
        record=data(ismember(sort(data(:,[3 4]),2),searchNO(1:2),'rows'),:);
    case 'C1'
        record=data(ismember(data(:,3:5),searchNO(1:3),'rows'),:);
    case 'C0'
        record=data(ismember(sort(data(:,3:5),2),searchNO(1:3),'rows'),:);
    case 'B2'
        tmp=sort(data(:,3:5),2);
        record=data(ismember(tmp(:,[1 2]),searchNO(1:2),'rows')|ismember(tmp(:,[1 3]),searchNO([1 3]),'rows')|ismember(tmp(:,2:3),searchNO(2:3),'rows'),:);
end
end
function d =findLast(data,searchNO,style)
switch style
    case 'A1'
        d=size(data,1)-find(data(:,3)==searchNO(1),1,'last');
    case 'B112'
        [~,d]=ismember(searchNO(1:2),data(-1*(-end:-1),3:4),'rows');
    case 'B012'
        [~,d]=ismember(searchNO(1:2),sort(data(-1*(-end:-1),3:4),2),'rows');
        %         d=find(sort(data(:,[3 4]),2)==searchNO([1 2]),1,'last');
    case 'C1'
        [~,d]=ismember(searchNO(1:3),data(-1*(-end:-1),3:5),'rows');
    case 'C0'
        [~,d]=ismember(searchNO(1:3),sort(data(-1*(-end:-1),3:5),2),'rows');
    case 'B2'
        tmp=sort(data(-1*(-end:-1),3:5),2);
        dd=[ismember(searchNO(1:2),tmp(:,1:2),'rows'), ismember(searchNO([1 3]),tmp(:,[1 3]),'rows'), ismember(searchNO(2:3),tmp(:,2:3),'rows')];
        [~,d]=min(dd(dd>0));
end
end