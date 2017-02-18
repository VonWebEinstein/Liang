function [ XX ] = dealwithTwo( Cdata, handles )
% 只用来处理輪的二枠単，二枠複
% 数据的最后两位，只计算二连单和二连复

Matchitem=[];
Result=[];
Ratio=[];
name=[];
N=[];
D=[];
FZ= str2double(get(handles.edit2,'string'));

%分母的路径
fenmuPath=[handles.hpath, handles.dstyle, '\'];

%若勾选重新生成分母。。。
%只有计算所有R时才调用此函数
if get(handles.gFenmu,'value')&&isempty(handles.nRMark)
    [ F ] = generate2Fenmu( Cdata );
    B1=F{1}; B0=F{2};
else
    %   读取分母
    B1=load([fenmuPath,'B1.txt']);
    B0=load([fenmuPath,'B0.txt']);
end
%tic

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
        B1 = b(Data(:,[1 2]),1,B1 );        
        B0 = b(Data(:,[1 2]),0,B0);        
    end
end
F={B1,B0};

%更新分母
if  get(handles.updateFenmu,'value')&&isempty(handles.nRMark)% && handles.caculated
    disp('update fenmu2');
    n1={'B1','B0'};
    for i=1:length(n1)
        filename=[fenmuPath, n1{i}, '.txt'];
        dlmwrite(filename, F{i}, 'precision','%d', 'delimiter', ' ', 'newline','pc');
    end
    
end

for i=1:length(handles.id2)
    
    Data=Cdata{handles.id2(i)};
    %比赛数据为空，跳出
    if isempty(Data)
        continue;
    end
    
    [D, result, ratio,matchitem,NN] = c2(Data(:,[1 2]),1,B1,FZ );%二連单
    if isempty(ratio)
    else
        Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
        Matchitem=[Matchitem;cellstr(num2str(matchitem))];
        name=[name;[repmat(handles.matchname(handles.id2(i)),length(ratio),1),repmat({'二枠単'},length(ratio),1)]];%即二连单
    end
    
    
    [D, result, ratio,matchitem,NN] = c2(Data(:,[1 2]),0,B0,FZ );%二连复
    if isempty(ratio)
    else
        Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
        Matchitem=[Matchitem;cellstr(num2str(matchitem))];
        name=[name;[repmat(handles.matchname(handles.id2(i)),length(ratio),1),repmat({'二枠複'},length(ratio),1)]];
    end
    
end

%   场地后面加上nR标记，只有艇和輪加
%   01_桐生-01R
if strcmp(handles.matchtoupdate,'輪')||strcmp(handles.matchtoupdate,'艇')
    if ~isempty(handles.nRMark)
        for i=1:size(name,1)
            name{i,1}=[name{i,1},'-',handles.nRMark];
        end
    end
end
%   场地后面加上handles.style, 01_桐生-01R-枠番
%   handles.dstyle空的话就不加
if ~isempty(handles.dstyle)
    for i=1:size(name,1)
        name{i,1}=[name{i,1},'-',handles.dstyle];
    end
end
XX=[name,Matchitem,num2cell(Result),num2cell(roundn(Ratio,-3)),num2cell(N)];

% XX=[{'競賽場','競賽類型','警報','剩余数','最大空格','比率','出現回数'};name,Matchitem,num2cell(Result),num2cell(Ratio),num2cell(N)];
%name Structure
%比赛场地 警报
%name1: 比赛场地； name2: 警报
    
end


