function [ dataToWrite ] = dealwithZhongHorse( Cdata, handles )
%�������R����������XX
%   Detailed explanation goes here

%����(20150502)������(3)���R��(3)���˚�(3)�����B�˚�(1)���R�B�˚�(1)���R�g�˚�(1)���磻���˚�(3)��3�B�}�˚�(1)��3�B�g�˚�(1)
dataToWrite=[];
n=length(Cdata);
%����
handles.dstyle='����';
%nR��ǣ��������ɷ�ĸʱʶ��
handles.nRMark='';
data=cell(1,n);
for i=1:n
    if isempty(Cdata{i})
        continue
    end
    data{i}=Cdata{i}(:,2:4);
end
[ F ] = generate3Fenmu( data );
dataToWrite=[dataToWrite; dealwithThree( data, handles )];
%�R��
handles.dstyle='�R��';
data=cell(1,n);
for i=1:n
    if isempty(Cdata{i})
        continue
    end
    data{i}=Cdata{i}(:,5:7);
end
dataToWrite=[dataToWrite; dealwithThree( data, handles )];
%�˚�
handles.dstyle='�˚�';
data=cell(1,n);
for i=1:n
    if isempty(Cdata{i})
        continue
    end
    data{i}=Cdata{i}(:,8:10);
end
dataToWrite=[dataToWrite; dealwithThree( data, handles )];
%���B�˚�
handles.dstyle='���B�˚�';
data=cell(1,n);
for i=1:n
    if isempty(Cdata{i})
        continue
    end
    data{i}=Cdata{i}(:,11);
end
dataToWrite=[dataToWrite; dealwithOne( data, handles )];
%�R�B�˚�
handles.dstyle='�R�B�˚�';
data=cell(1,n);
for i=1:n
    if isempty(Cdata{i})
        continue
    end
    data{i}=Cdata{i}(:,12);
end
dataToWrite=[dataToWrite; dealwithOne( data, handles )];
%�R�g�˚�
handles.dstyle='�R�g�˚�';
data=cell(1,n);
for i=1:n
    if isempty(Cdata{i})
        continue
    end
    data{i}=Cdata{i}(:,13);
end
dataToWrite=[dataToWrite; dealwithOne( data, handles )];
%�磻���˚�1
handles.dstyle='�磻���˚�1';
data=cell(1,n);
for i=1:n
    if isempty(Cdata{i})
        continue
    end
    data{i}=Cdata{i}(:,14);
end
dataToWrite=[dataToWrite; dealwithOne( data, handles )];
%�磻���˚�2
handles.dstyle='�磻���˚�2';
data=cell(1,n);
for i=1:n
    if isempty(Cdata{i})
        continue
    end
    data{i}=Cdata{i}(:,15);
end
dataToWrite=[dataToWrite; dealwithOne( data, handles )];
%�磻���˚�3
handles.dstyle='�磻���˚�3';
data=cell(1,n);
for i=1:n
    if isempty(Cdata{i})
        continue
    end
    data{i}=Cdata{i}(:,16);
end
dataToWrite=[dataToWrite; dealwithOne( data, handles )];
%3�B�}�˚�
handles.dstyle='3�B�}�˚�';
data=cell(1,n);
for i=1:n
    if isempty(Cdata{i})
        continue
    end
    data{i}=Cdata{i}(:,17);
end
dataToWrite=[dataToWrite; dealwithOne( data, handles )];
%3�B�g�˚�
handles.dstyle='3�B�g�˚�';
data=cell(1,n);
for i=1:n
    if isempty(Cdata{i})
        continue
    end
    data{i}=Cdata{i}(:,18);
end
dataToWrite=[dataToWrite; dealwithOne( data, handles )];

dataToWrite=[{'��ِ��','��ِ���','����','ʣ����','���ո�','����','���F����'};dataToWrite];
end

