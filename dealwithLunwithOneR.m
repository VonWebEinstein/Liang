function [ dataToWrite ] = dealwithLunwithOneR( Cdata, handles )
%计算輪的数据
%   一个R或者所有R
%   数据格式： 日期(20150520), 3連単(3), 2枠連(2)
dataToWrite=[];
n=length(Cdata);
%3連単
handles.dstyle='3連単';
data=[];
for i=1:n
    if isempty(Cdata{i})
        continue
    end
    data{i}=Cdata{i}(:,2:4);
end
dataToWrite=[dataToWrite;dealwithThree( data, handles )];

%2枠連
handles.dstyle='2枠連';
data=[];
for i=1:n
    if isempty(Cdata{i})
        continue
    end
    data{i}=Cdata{i}(:,5:6);
end
dataToWrite=[dataToWrite; dealwithTwo( data, handles )];
end



