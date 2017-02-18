function [ dataToWrite ] = dealwithZhongHorse( Cdata, handles )
%处理中馬，结果输出到XX
%   Detailed explanation goes here

%日期(20150502)，枠番(3)，馬番(3)，人気(3)，枠連人気(1)，馬連人気(1)，馬単人気(1)，ワイド人気(3)，3連複人気(1)，3連単人気(1)
dataToWrite=[];
n=length(Cdata);
%枠番
handles.dstyle='枠番';
%nR标记，重新生成分母时识别
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
%馬番
handles.dstyle='馬番';
data=cell(1,n);
for i=1:n
    if isempty(Cdata{i})
        continue
    end
    data{i}=Cdata{i}(:,5:7);
end
dataToWrite=[dataToWrite; dealwithThree( data, handles )];
%人気
handles.dstyle='人気';
data=cell(1,n);
for i=1:n
    if isempty(Cdata{i})
        continue
    end
    data{i}=Cdata{i}(:,8:10);
end
dataToWrite=[dataToWrite; dealwithThree( data, handles )];
%枠連人気
handles.dstyle='枠連人気';
data=cell(1,n);
for i=1:n
    if isempty(Cdata{i})
        continue
    end
    data{i}=Cdata{i}(:,11);
end
dataToWrite=[dataToWrite; dealwithOne( data, handles )];
%馬連人気
handles.dstyle='馬連人気';
data=cell(1,n);
for i=1:n
    if isempty(Cdata{i})
        continue
    end
    data{i}=Cdata{i}(:,12);
end
dataToWrite=[dataToWrite; dealwithOne( data, handles )];
%馬単人気
handles.dstyle='馬単人気';
data=cell(1,n);
for i=1:n
    if isempty(Cdata{i})
        continue
    end
    data{i}=Cdata{i}(:,13);
end
dataToWrite=[dataToWrite; dealwithOne( data, handles )];
%ワイド人気1
handles.dstyle='ワイド人気1';
data=cell(1,n);
for i=1:n
    if isempty(Cdata{i})
        continue
    end
    data{i}=Cdata{i}(:,14);
end
dataToWrite=[dataToWrite; dealwithOne( data, handles )];
%ワイド人気2
handles.dstyle='ワイド人気2';
data=cell(1,n);
for i=1:n
    if isempty(Cdata{i})
        continue
    end
    data{i}=Cdata{i}(:,15);
end
dataToWrite=[dataToWrite; dealwithOne( data, handles )];
%ワイド人気3
handles.dstyle='ワイド人気3';
data=cell(1,n);
for i=1:n
    if isempty(Cdata{i})
        continue
    end
    data{i}=Cdata{i}(:,16);
end
dataToWrite=[dataToWrite; dealwithOne( data, handles )];
%3連複人気
handles.dstyle='3連複人気';
data=cell(1,n);
for i=1:n
    if isempty(Cdata{i})
        continue
    end
    data{i}=Cdata{i}(:,17);
end
dataToWrite=[dataToWrite; dealwithOne( data, handles )];
%3連単人気
handles.dstyle='3連単人気';
data=cell(1,n);
for i=1:n
    if isempty(Cdata{i})
        continue
    end
    data{i}=Cdata{i}(:,18);
end
dataToWrite=[dataToWrite; dealwithOne( data, handles )];

dataToWrite=[{'競賽場','競賽類型','警報','剩余数','最大空格','比率','出現回数'};dataToWrite];
end

