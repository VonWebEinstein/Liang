function [ XX ] = dealwithTwo( Cdata, handles )
% ֻ��������݆�Ķ����g�������}
% ���ݵ������λ��ֻ����������Ͷ�����

Matchitem=[];
Result=[];
Ratio=[];
name=[];
N=[];
D=[];
FZ= str2double(get(handles.edit2,'string'));

%��ĸ��·��
fenmuPath=[handles.hpath, handles.dstyle, '\'];

%����ѡ�������ɷ�ĸ������
%ֻ�м�������Rʱ�ŵ��ô˺���
if get(handles.gFenmu,'value')&&isempty(handles.nRMark)
    [ F ] = generate2Fenmu( Cdata );
    B1=F{1}; B0=F{2};
else
    %   ��ȡ��ĸ
    B1=load([fenmuPath,'B1.txt']);
    B0=load([fenmuPath,'B0.txt']);
end
%tic

%�������б����ķ�ĸ��ȡ���ֵ
if get(handles.checkbox_FenmuFromNewData,'value')
    for i=1:length(Cdata)
        %ͧ�����������ĸ
        if strcmp(handles.matchtoupdate, 'ͧ') && i>24
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

%���·�ĸ
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
    %��������Ϊ�գ�����
    if isempty(Data)
        continue;
    end
    
    [D, result, ratio,matchitem,NN] = c2(Data(:,[1 2]),1,B1,FZ );%���B��
    if isempty(ratio)
    else
        Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
        Matchitem=[Matchitem;cellstr(num2str(matchitem))];
        name=[name;[repmat(handles.matchname(handles.id2(i)),length(ratio),1),repmat({'�����g'},length(ratio),1)]];%��������
    end
    
    
    [D, result, ratio,matchitem,NN] = c2(Data(:,[1 2]),0,B0,FZ );%������
    if isempty(ratio)
    else
        Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
        Matchitem=[Matchitem;cellstr(num2str(matchitem))];
        name=[name;[repmat(handles.matchname(handles.id2(i)),length(ratio),1),repmat({'�����}'},length(ratio),1)]];
    end
    
end

%   ���غ������nR��ǣ�ֻ��ͧ��݆��
%   01_ͩ��-01R
if strcmp(handles.matchtoupdate,'݆')||strcmp(handles.matchtoupdate,'ͧ')
    if ~isempty(handles.nRMark)
        for i=1:size(name,1)
            name{i,1}=[name{i,1},'-',handles.nRMark];
        end
    end
end
%   ���غ������handles.style, 01_ͩ��-01R-����
%   handles.dstyle�յĻ��Ͳ���
if ~isempty(handles.dstyle)
    for i=1:size(name,1)
        name{i,1}=[name{i,1},'-',handles.dstyle];
    end
end
XX=[name,Matchitem,num2cell(Result),num2cell(roundn(Ratio,-3)),num2cell(N)];

% XX=[{'��ِ��','��ِ���','����','ʣ����','���ո�','����','���F����'};name,Matchitem,num2cell(Result),num2cell(Ratio),num2cell(N)];
%name Structure
%�������� ����
%name1: �������أ� name2: ����
    
end


