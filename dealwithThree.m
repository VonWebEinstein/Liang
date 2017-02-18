function [ XX ] = dealwithThree( Cdata, handles )
%������������
%   ÿ�����������ݴ���Ԫ��Cdata��
%   handles��gui�����ȫ�ֱ���

Matchitem=[];
Result=[];
Ratio=[];
name=[];
N=[];
D=[];
FZ= str2double(get(handles.edit2,'string'));
% handles.image_on=get(handles.checkbox3,'value');
% if handles.image_on
%     mkdir(handles.outpath1,[datestr(now,29),'����-',handles.outname1])
%     impath=[handles.outpath1,datestr(now,29),'����-',handles.outname1,'\'];
%     h_fig= figure();
%     % set(h_fig,'Position',[100 100 260 220]);
%     set(h_fig,'Units','centimeters','Position',[2 2 27 8]);
%     set(gca,'position',[0.05 0.1 0.9 0.85]);
%     pause(0.5);
% end
%��ĸ��·��
fenmuPath='.\history\ͧ\3�B�g\';

%����ѡ�������ɷ�ĸ������
%ֻ�м�������Rʱ�ŵ��ô˺���
if get(handles.gFenmu,'value')&&isempty(handles.nRMark)
    [ F ] = generate3Fenmu( Cdata );
    A1=F{1};A2=F{2};A3=F{3};B112=F{4};B113=F{5};B123=F{6};B012=F{7};B013=F{8};B023=F{9};B2=F{10};C1=F{11};C0=F{12};
else
    %   ��ȡ��ĸ
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

%�������б����ķ�ĸ��ȡ���ֵ
if get(handles.checkbox_FenmuFromNewData,'value')
    for i=1:length(Cdata)
        %ͧ�����������ĸ
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

%���·�ĸ
if  get(handles.updateFenmu,'value')&&isempty(handles.nRMark)% && handles.caculated
    n1={'A1','A2','A3','B112','B113','B123','B012','B013','B023','B2','C1','C0'};
    for i=1:length(n1)
        filename=[fenmuPath, n1{i}, '.txt'];
        dlmwrite(filename, F{i}, 'precision','%d', 'delimiter', ' ', 'newline','pc');
    end
   
    
end

%matchitemFull  size=Nx3��matchitemǰ����0��ȫ
matchitemFull=[];
for i=1:length(handles.isChoosed)
    
    Data=Cdata{i};
    %��������Ϊ�գ�����
    if isempty(Data)
        continue;
    end
    [D,result,ratio,matchitem,NN]=c1(Data(:,1),A1,FZ);  %һ��
    %������Ϊ�գ�����
    if isempty(ratio)
    else
        %��ȫmatchitem
        [mofm, nofm]=size(matchitem);
        matchitemFull=[matchitemFull; [zeros(mofm,3-nofm), matchitem ]];
        
        Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
        Matchitem=[Matchitem;cellstr(num2str(matchitem))];
        name=[name;[repmat(handles.matchname(i),length(ratio),1),repmat({'�g��һ��'},length(ratio),1)]];
    end
    
    [D,result,ratio,matchitem,NN]=c1(Data(:,2),A2,FZ);
    if isempty(ratio)
    else
        [mofm, nofm]=size(matchitem);
        matchitemFull=[matchitemFull; [zeros(mofm,3-nofm), matchitem ]];
        Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
        Matchitem=[Matchitem;cellstr(num2str(matchitem))];
        name=[name;[repmat(handles.matchname(i),length(ratio),1),repmat({'�g�٥���'},length(ratio),1)]];
    end
    
%     [D,result,ratio,matchitem,NN]=c1(Data(:,3),A3,FZ);
%     if isempty(ratio)
%     else
%         [mofm, nofm]=size(matchitem);
%         matchitemFull=[matchitemFull; [zeros(mofm,3-nofm), matchitem ]];
%         Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
%         Matchitem=[Matchitem;cellstr(num2str(matchitem))];
%         name=[name;[repmat(handles.matchname(i),length(ratio),1),repmat({'�g������'},length(ratio),1)]];
%     end
    
    [D, result, ratio,matchitem,NN] = c2(Data(:,[1 2]),1,B112,FZ );%���B��
    if isempty(ratio)
    else
        [mofm, nofm]=size(matchitem);
        matchitemFull=[matchitemFull; [matchitem, zeros(mofm,3-nofm)]];
        Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
        Matchitem=[Matchitem;cellstr(num2str(matchitem))];
        name=[name;[repmat(handles.matchname(i),length(ratio),1),repmat({'���B�g'},length(ratio),1)]];
    end
    
%     [D, result, ratio,matchitem,NN] = c2(Data(:,[1 3]),1,B113,FZ );
%     if isempty(ratio)
%     else
%         [mofm, nofm]=size(matchitem);
%         matchitemFull=[matchitemFull; [matchitem, zeros(mofm,3-nofm)]];
%         Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
%         Matchitem=[Matchitem;cellstr(num2str(matchitem))];
%         name=[name;[repmat(handles.matchname(i),length(ratio),1),repmat({'�ж��B�gһ��'},length(ratio),1)]];
%     end
%     
%     [D, result, ratio,matchitem,NN] = c2(Data(:,[2 3]),1,B123,FZ );
%     if isempty(ratio)
%     else
%         [mofm, nofm]=size(matchitem);
%         matchitemFull=[matchitemFull; [matchitem, zeros(mofm,3-nofm)]];
%         Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
%         Matchitem=[Matchitem;cellstr(num2str(matchitem))];
%         name=[name;[repmat(handles.matchname(i),length(ratio),1),repmat({'�����B�g����'},length(ratio),1)]];
%     end
    
    [D, result, ratio,matchitem,NN] = c2(Data(:,[1 2]),0,B012,FZ );%������
    if isempty(ratio)
    else
        [mofm, nofm]=size(matchitem);
        matchitemFull=[matchitemFull; [matchitem, zeros(mofm,3-nofm)]];
        Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
        Matchitem=[Matchitem;cellstr(num2str(matchitem))];
        name=[name;[repmat(handles.matchname(i),length(ratio),1),repmat({'���B�}'},length(ratio),1)]];
    end
    
%     [D, result, ratio,matchitem,NN] = c2(Data(:,[1 3]),0,B013,FZ );
%     if isempty(ratio)
%     else
%         [mofm, nofm]=size(matchitem);
%         matchitemFull=[matchitemFull; [matchitem, zeros(mofm,3-nofm)]];
%         Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
%         Matchitem=[Matchitem;cellstr(num2str(matchitem))];
%         name=[name;[repmat(handles.matchname(i),length(ratio),1),repmat({'�ж��B�}һ��'},length(ratio),1)]];
%     end
%     
%     [D, result, ratio,matchitem,NN] = c2(Data(:,[2 3]),0,B023,FZ );
%     if isempty(ratio)
%     else
%         [mofm, nofm]=size(matchitem);
%         matchitemFull=[matchitemFull; [matchitem, zeros(mofm,3-nofm)]];
%         Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
%         Matchitem=[Matchitem;cellstr(num2str(matchitem))];
%         name=[name;[repmat(handles.matchname(i),length(ratio),1),repmat({'�����B�}����'},length(ratio),1)]];
%     end
    
    [D, result, ratio,matchitem,NN] = c3(Data,2 ,B2,FZ);   %���B��
    if isempty(ratio)
    else
        [mofm, nofm]=size(matchitem);
        matchitemFull=[matchitemFull; [zeros(mofm,3-nofm), matchitem ]];
        Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
        Matchitem=[Matchitem;cellstr(num2str(matchitem))];
        name=[name;[repmat(handles.matchname(i),length(ratio),1),repmat({'���B�}'},length(ratio),1)]];
    end
    
    [D, result, ratio,matchitem,NN] = c3(Data,1 ,C1,FZ);   %���B��
    if isempty(ratio)
    else
        matchitemFull=[matchitemFull; matchitem];
        Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
        Matchitem=[Matchitem;cellstr(num2str(matchitem))];
        name=[name;[repmat(handles.matchname(i),length(ratio),1),repmat({'���B�g'},length(ratio),1)]];
    end
    
    [D, result, ratio,matchitem,NN] = c3(Data,0 ,C0,FZ);   %���B��
    if isempty(ratio)
    else
        matchitemFull=[matchitemFull; matchitem];
        Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
        Matchitem=[Matchitem;cellstr(num2str(matchitem))];
        name=[name;[repmat(handles.matchname(i),length(ratio),1),repmat({'���B�}'},length(ratio),1)]];
    end
    
end
% if handles.image_on==1
%     close(h_fig);
% end
%toc

%   ���غ������nR��ǣ�ֻ��ͧ��݆��
%   01_ͩ��-01R
if ~isempty(handles.nRMark)
    for i=1:size(name,1)
        name{i,1}=[name{i,1},'-',handles.nRMark];
    end
end

%   ���غ������handles.style, 01_ͩ��-01R-����
%   handles.dstyle�յĻ��Ͳ���
% if ~isempty(handles.dstyle)
%     for i=1:size(name,1)
%         name{i,1}=[name{i,1},'-',handles.dstyle];
%     end
% end
XX=[name,Matchitem,num2cell(Result),num2cell(roundn(Ratio,-3)),num2cell(N)];

% XX=[{'��ِ��','��ِ���','����','ʣ����','���ո�','����','���F����'};name,Matchitem,num2cell(Result),num2cell(Ratio),num2cell(N)];
%����������������2015.05.08
%name Structure
%�������� ����
%name1: �������أ� name2: ����

%������Ϊ��
if isempty(name)
    set(handles.text_updateStatus,'string','���Ϊ��');
else
    name2=name(:,2);
    XXtmp1=[]; XXtmp2=[];
    matchitemFull1=[]; matchitemFull2=[];
    keyString={'�g��һ��', '�g�٥���', '�g������', '���B�}',  '���B�}', '�ж��B�}һ��', '�����B�}����', '���B�g', '�ж��B�gһ��', '�����B�g����', '���B�}', '���B�g'};
    %��ȡ���еĵ�ʤһ�ţ���ʤ����...
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
    %   ���б��ܽ��1XX��X1X��XXX
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

