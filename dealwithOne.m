function [ XX ] = dealwithOne( Cdata, handles )
%����ֻ��һλ������ʽ��
%   ÿ�����ص���ͬ���͵�����ʽ���ݴ���Cdata

%��ȡ��ĸ
fenmuPath=[handles.hpath, handles.dstyle, '\'];

Matchitem=[];
Result=[];
Ratio=[];
name=[];
N=[];
D=[];
FZ= str2double(get(handles.edit2,'string'));

%���÷�ĸ���Ƕ�ȡ��ĸ
%ֻ�м�������Rʱ�ŵ��ô˺���
if get(handles.gFenmu,'value')&&isempty(handles.nRMark)
    [ A ] = generate1Fenmu( Cdata );
else
    A=load([fenmuPath,'A.txt']);
end
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
        A=a(Data,A);
    end
end

%���·�ĸ
if  get(handles.updateFenmu,'value')&&isempty(handles.nRMark)%&&  handles.caculated
    disp('update fenmu1');
    filename=[fenmuPath, 'A.txt'];
    dlmwrite(filename, A, 'precision','%d', 'delimiter', ' ', 'newline','pc');
end

%����
XX=[];
for i=1:length(handles.id2)
    
    Data=Cdata{handles.id2(i)};
    %��������Ϊ�գ�����
    if isempty(Data)
        continue;
    end
    [D,result,ratio,matchitem,NN]=c1(Data,A,FZ);  %һ��
    %������Ϊ�գ�����
    if isempty(ratio)
        continue
    else
        Result=[Result;result];Ratio=[Ratio;ratio];N=[N;NN];
        Matchitem=[Matchitem;cellstr(num2str(matchitem))];
        name=[name;[repmat(handles.matchname(handles.id2(i)),length(ratio),1),repmat({handles.dstyle},length(ratio),1)]];
    end

end
%   ݆��ͧ�Ľ�����غ�����nR
%   01_ͩ��-01R
if strcmp(handles.matchtoupdate,'݆')||strcmp(handles.matchtoupdate,'ͧ')
    if ~isempty(handles.nRMark)
        for i=1:size(name,1)
            name{i,1}=[name{i,1},'-',handles.nRMark];
        end
    end
end
XX=[XX;name,Matchitem,num2cell(Result),num2cell(roundn(Ratio,-3)),num2cell(N)];

