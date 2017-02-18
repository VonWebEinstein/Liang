function [ XX ] = dealwithOne( Cdata, handles )
%处理只有一位的人气式等
%   每个场地的相同类型的人气式数据存在Cdata

%读取分母
fenmuPath=[handles.hpath, handles.dstyle, '\'];

Matchitem=[];
Result=[];
Ratio=[];
name=[];
N=[];
D=[];
FZ= str2double(get(handles.edit2,'string'));

%重置分母还是读取分母
%只有计算所有R时才调用此函数
if get(handles.gFenmu,'value')&&isempty(handles.nRMark)
    [ A ] = generate1Fenmu( Cdata );
else
    A=load([fenmuPath,'A.txt']);
end
%计算所有比赛的分母，取最大值

if get(handles.checkbox_FenmuFromNewData,'value')
    for i=1:length(Cdata)
        %艇的组合项不计算分母
        if strcmp(handles.matchtoupdate, '艇') && i>24
            continue
        end
        
        Data=Cdata{i};
        if isempty(Data)
            continue;
        end
        A=a(Data,A);
    end
end

%更新分母
if  get(handles.updateFenmu,'value')&&isempty(handles.nRMark)%&&  handles.caculated
    disp('update fenmu1');
    filename=[fenmuPath, 'A.txt'];
    dlmwrite(filename, A, 'precision','%d', 'delimiter', ' ', 'newline','pc');
end

%计算
XX=[];
for i=1:length(handles.id2)
    
    Data=Cdata{handles.id2(i)};
    %比赛数据为空，跳出
    if isempty(Data)
        continue;
    end
    [D,result,ratio,matchitem,NN]=c1(Data,A,FZ);  %一着
    %计算结果为空，跳出
    if isempty(ratio)
        continue
    else
        Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
        Matchitem=[Matchitem;cellstr(num2str(matchitem))];
        name=[name;[repmat(handles.matchname(handles.id2(i)),length(ratio),1),repmat({handles.dstyle},length(ratio),1)]];
    end

end
%   輪和艇的结果场地后面标记nR
%   01_桐生-01R
if strcmp(handles.matchtoupdate,'輪')||strcmp(handles.matchtoupdate,'艇')
    if ~isempty(handles.nRMark)
        for i=1:size(name,1)
            name{i,1}=[name{i,1},'-',handles.nRMark];
        end
    end
end
XX=[XX;name,Matchitem,num2cell(Result),num2cell(roundn(Ratio,-3)),num2cell(N)];

