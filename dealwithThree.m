function [ XX ] = dealwithThree( Cdata, handles )
%处理三个数字
%   每个赛场的数据存在元胞Cdata中
%   handles：gui句柄和全局变量

Matchitem=[];
Result=[];
Ratio=[];
name=[];
N=[];
D=[];
FZ= str2double(get(handles.edit2,'string'));
% handles.image_on=get(handles.checkbox3,'value');
% if handles.image_on
%     mkdir(handles.outpath1,[datestr(now,29),'図像-',handles.outname1])
%     impath=[handles.outpath1,datestr(now,29),'図像-',handles.outname1,'\'];
%     h_fig= figure();
%     % set(h_fig,'Position',[100 100 260 220]);
%     set(h_fig,'Units','centimeters','Position',[2 2 27 8]);
%     set(gca,'position',[0.05 0.1 0.9 0.85]);
%     pause(0.5);
% end
%分母的路径
fenmuPath='.\history\艇\3連単\';

%若勾选重新生成分母。。。
%只有计算所有R时才调用此函数
if get(handles.gFenmu,'value')&&isempty(handles.nRMark)
    [ F ] = generate3Fenmu( Cdata );
    A1=F{1};A2=F{2};A3=F{3};B112=F{4};B113=F{5};B123=F{6};B012=F{7};B013=F{8};B023=F{9};B2=F{10};C1=F{11};C0=F{12};
else
    %   读取分母
    A1=load([fenmuPath,'A1.txt']);
    A2=load([fenmuPath,'A2.txt']);
    A3=load([fenmuPath,'A3.txt']);
    B112=load([fenmuPath,'B112.txt']);
    B113=load([fenmuPath,'B113.txt']);
    B123=load([fenmuPath,'B123.txt']);
    B012=load([fenmuPath,'B012.txt']);
    B013=load([fenmuPath,'B013.txt']);
    B023=load([fenmuPath,'B023.txt']);
    B2=load([fenmuPath,'B2.txt']);
    C1=load([fenmuPath,'C1.txt']);
    C0=load([fenmuPath,'C0.txt']);
    
end
%tic

%计算所有比赛的分母，取最大值
if get(handles.checkbox_FenmuFromNewData,'value')
    for i=1:length(Cdata)
        %艇的组合项不计算分母
        if i>24
            continue
        end
        Data=Cdata{i};
        if isempty(Data)
            continue;
        end
        A1=a(Data(:,1),A1);
        
        A2=a(Data(:,2),A2);
        
        A3=a(Data(:,1),A3);
        
        B112 = b(Data(:,[1 2]),1,B112 );
        
        B113 = b(Data(:,[1 3]),1,B113);
        
        B123 = b(Data(:,[2 3]),1,B123);
        
        B012 = b(Data(:,[1 2]),0,B012);
        
        B013= b(Data(:,[1 3]),0,B013);
        
        B023 = b(Data(:,[2 3]),0,B023 );
        
        B2 =c(Data,2 ,B2);
        
        C1 = c(Data,1 ,C1);
        
        C0 = c(Data,0,C0);
        
    end
end
F={A1,A2,A3,B112,B113,B123,B012,B013,B023,B2,C1,C0};

%更新分母
if  get(handles.updateFenmu,'value')&&isempty(handles.nRMark)% && handles.caculated
    n1={'A1','A2','A3','B112','B113','B123','B012','B013','B023','B2','C1','C0'};
    for i=1:length(n1)
        filename=[fenmuPath, n1{i}, '.txt'];
        dlmwrite(filename, F{i}, 'precision','%d', 'delimiter', ' ', 'newline','pc');
    end
   
    
end

%matchitemFull  size=Nx3，matchitem前面用0补全
matchitemFull=[];
for i=1:length(handles.isChoosed)
    
    Data=Cdata{i};
    %比赛数据为空，跳出
    if isempty(Data)
        continue;
    end
    [D,result,ratio,matchitem,NN]=c1(Data(:,1),A1,FZ);  %一着
    %计算结果为空，跳出
    if isempty(ratio)
    else
        %补全matchitem
        [mofm, nofm]=size(matchitem);
        matchitemFull=[matchitemFull; [zeros(mofm,3-nofm), matchitem ]];
        
        Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
        Matchitem=[Matchitem;cellstr(num2str(matchitem))];
        name=[name;[repmat(handles.matchname(i),length(ratio),1),repmat({'単勝一着'},length(ratio),1)]];
    end
    
    [D,result,ratio,matchitem,NN]=c1(Data(:,2),A2,FZ);
    if isempty(ratio)
    else
        [mofm, nofm]=size(matchitem);
        matchitemFull=[matchitemFull; [zeros(mofm,3-nofm), matchitem ]];
        Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
        Matchitem=[Matchitem;cellstr(num2str(matchitem))];
        name=[name;[repmat(handles.matchname(i),length(ratio),1),repmat({'単勝ニ着'},length(ratio),1)]];
    end
    
%     [D,result,ratio,matchitem,NN]=c1(Data(:,3),A3,FZ);
%     if isempty(ratio)
%     else
%         [mofm, nofm]=size(matchitem);
%         matchitemFull=[matchitemFull; [zeros(mofm,3-nofm), matchitem ]];
%         Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
%         Matchitem=[Matchitem;cellstr(num2str(matchitem))];
%         name=[name;[repmat(handles.matchname(i),length(ratio),1),repmat({'単勝三着'},length(ratio),1)]];
%     end
    
    [D, result, ratio,matchitem,NN] = c2(Data(:,[1 2]),1,B112,FZ );%二連单
    if isempty(ratio)
    else
        [mofm, nofm]=size(matchitem);
        matchitemFull=[matchitemFull; [matchitem, zeros(mofm,3-nofm)]];
        Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
        Matchitem=[Matchitem;cellstr(num2str(matchitem))];
        name=[name;[repmat(handles.matchname(i),length(ratio),1),repmat({'二連単'},length(ratio),1)]];
    end
    
%     [D, result, ratio,matchitem,NN] = c2(Data(:,[1 3]),1,B113,FZ );
%     if isempty(ratio)
%     else
%         [mofm, nofm]=size(matchitem);
%         matchitemFull=[matchitemFull; [matchitem, zeros(mofm,3-nofm)]];
%         Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
%         Matchitem=[Matchitem;cellstr(num2str(matchitem))];
%         name=[name;[repmat(handles.matchname(i),length(ratio),1),repmat({'中二連単一三'},length(ratio),1)]];
%     end
%     
%     [D, result, ratio,matchitem,NN] = c2(Data(:,[2 3]),1,B123,FZ );
%     if isempty(ratio)
%     else
%         [mofm, nofm]=size(matchitem);
%         matchitemFull=[matchitemFull; [matchitem, zeros(mofm,3-nofm)]];
%         Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
%         Matchitem=[Matchitem;cellstr(num2str(matchitem))];
%         name=[name;[repmat(handles.matchname(i),length(ratio),1),repmat({'反二連単二三'},length(ratio),1)]];
%     end
    
    [D, result, ratio,matchitem,NN] = c2(Data(:,[1 2]),0,B012,FZ );%二连复
    if isempty(ratio)
    else
        [mofm, nofm]=size(matchitem);
        matchitemFull=[matchitemFull; [matchitem, zeros(mofm,3-nofm)]];
        Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
        Matchitem=[Matchitem;cellstr(num2str(matchitem))];
        name=[name;[repmat(handles.matchname(i),length(ratio),1),repmat({'二連複'},length(ratio),1)]];
    end
    
%     [D, result, ratio,matchitem,NN] = c2(Data(:,[1 3]),0,B013,FZ );
%     if isempty(ratio)
%     else
%         [mofm, nofm]=size(matchitem);
%         matchitemFull=[matchitemFull; [matchitem, zeros(mofm,3-nofm)]];
%         Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
%         Matchitem=[Matchitem;cellstr(num2str(matchitem))];
%         name=[name;[repmat(handles.matchname(i),length(ratio),1),repmat({'中二連複一三'},length(ratio),1)]];
%     end
%     
%     [D, result, ratio,matchitem,NN] = c2(Data(:,[2 3]),0,B023,FZ );
%     if isempty(ratio)
%     else
%         [mofm, nofm]=size(matchitem);
%         matchitemFull=[matchitemFull; [matchitem, zeros(mofm,3-nofm)]];
%         Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
%         Matchitem=[Matchitem;cellstr(num2str(matchitem))];
%         name=[name;[repmat(handles.matchname(i),length(ratio),1),repmat({'反二連複二三'},length(ratio),1)]];
%     end
    
    [D, result, ratio,matchitem,NN] = c3(Data,2 ,B2,FZ);   %扩連复
    if isempty(ratio)
    else
        [mofm, nofm]=size(matchitem);
        matchitemFull=[matchitemFull; [zeros(mofm,3-nofm), matchitem ]];
        Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
        Matchitem=[Matchitem;cellstr(num2str(matchitem))];
        name=[name;[repmat(handles.matchname(i),length(ratio),1),repmat({'拡連複'},length(ratio),1)]];
    end
    
    [D, result, ratio,matchitem,NN] = c3(Data,1 ,C1,FZ);   %三連单
    if isempty(ratio)
    else
        matchitemFull=[matchitemFull; matchitem];
        Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
        Matchitem=[Matchitem;cellstr(num2str(matchitem))];
        name=[name;[repmat(handles.matchname(i),length(ratio),1),repmat({'三連単'},length(ratio),1)]];
    end
    
    [D, result, ratio,matchitem,NN] = c3(Data,0 ,C0,FZ);   %三連复
    if isempty(ratio)
    else
        matchitemFull=[matchitemFull; matchitem];
        Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
        Matchitem=[Matchitem;cellstr(num2str(matchitem))];
        name=[name;[repmat(handles.matchname(i),length(ratio),1),repmat({'三連複'},length(ratio),1)]];
    end
    
end
% if handles.image_on==1
%     close(h_fig);
% end
%toc

%   场地后面加上nR标记，只有艇和輪加
%   01_桐生-01R
if ~isempty(handles.nRMark)
    for i=1:size(name,1)
        name{i,1}=[name{i,1},'-',handles.nRMark];
    end
end

%   场地后面加上handles.style, 01_桐生-01R-枠番
%   handles.dstyle空的话就不加
% if ~isempty(handles.dstyle)
%     for i=1:size(name,1)
%         name{i,1}=[name{i,1},'-',handles.dstyle];
%     end
% end
XX=[name,Matchitem,num2cell(Result),num2cell(roundn(Ratio,-3)),num2cell(N)];

% XX=[{'競賽場','競賽類型','警報','剩余数','最大空格','比率','出現回数'};name,Matchitem,num2cell(Result),num2cell(Ratio),num2cell(N)];
%增加排列输出结果，2015.05.08
%name Structure
%比赛场地 警报
%name1: 比赛场地； name2: 警报

%计算结果为空
if isempty(name)
    set(handles.text_updateStatus,'string','结果为空');
else
    name2=name(:,2);
    XXtmp1=[]; XXtmp2=[];
    matchitemFull1=[]; matchitemFull2=[];
    keyString={'単勝一着', '単勝ニ着', '単勝三着', '拡連複',  '二連複', '中二連複一三', '反二連複二三', '二連単', '中二連単一三', '反二連単二三', '三連複', '三連単'};
    %提取所有的单胜一着，单胜二着...
    for i=1:12
        ii=cellisequal(name2, keyString(i));
        
        if i<5
            XXtmp1=[XXtmp1; XX(ii, :)];
            matchitemFull1=[matchitemFull1; matchitemFull(ii,:)];
        else
            XXtmp2=[XXtmp2; XX(ii,:)];
            matchitemFull2=[matchitemFull2; matchitemFull(ii,:)];
        end
    end
    %   排列比绍结果1XX，X1X，XXX
    [~,index]=sortrows(matchitemFull1);
    XX1=XXtmp1(index,:);
    
    is1=matchitemFull2(:,1)==1;
    matchitemFulltmp=matchitemFull2(is1,:);
    matchitemFullleft=matchitemFull2(~is1,:);
    XXtmp=XXtmp2(is1,:);
    XXleft=XXtmp2(~is1,:);
    [~,index]=sortrows(matchitemFulltmp(:,[1 3]));
    XX2=XXtmp(index,:);
    
    is1=matchitemFullleft(:,2)==1;
    matchitemFulltmp=matchitemFullleft(is1,:);
    matchitemFullleft=matchitemFullleft(~is1,:);
    XXtmp=XXleft(is1,:);
    XXleft=XXleft(~is1,:);
    [~,index]=sortrows(matchitemFulltmp(:,[1 3]));
    XX3=XXtmp(index,:);
    
    [~,index]=sortrows(matchitemFullleft);
    XX4=XXleft(index,:);
    
    XX=[XX1;XX2;XX3;XX4];
    
end

