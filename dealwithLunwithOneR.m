function [ dataToWrite ] = dealwithLunwithOneR( Cdata, handles )
%����݆������
%   һ��R��������R
%   ���ݸ�ʽ�� ����(20150520), 3�B�g(3), 2���B(2)
dataToWrite=[];
n=length(Cdata);
%3�B�g
handles.dstyle='3�B�g';
data=[];
for i=1:n
    if isempty(Cdata{i})
        continue
    end
    data{i}=Cdata{i}(:,2:4);
end
dataToWrite=[dataToWrite;dealwithThree( data, handles )];

%2���B
handles.dstyle='2���B';
data=[];
for i=1:n
    if isempty(Cdata{i})
        continue
    end
    data{i}=Cdata{i}(:,5:6);
end
dataToWrite=[dataToWrite; dealwithTwo( data, handles )];
end



