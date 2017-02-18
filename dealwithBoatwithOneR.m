function [ dataToWrite ] = dealwithBoatwithOneR( Cdata, handles )
%计算艇的数据，其中的nR，或者所有R
%   Detailed explanation goes here
%   日期(20150520), 3連単(3), 3連単人気(1), 3連複人気(1), 2連単人気(1), 2連複人気(1)
dataToWrite=[];
n=length(Cdata);
%3連単
handles.dstyle='';
data=[];
for i=1:n
    if isempty(Cdata{i})
        data{i}=[];
    else
        data{i}=Cdata{i}(:,2:4);
    end
end
dataToWrite=[dataToWrite; dealwithThree( data, handles )];
% %3連単人気
% handles.dstyle='3連単人気';
% data=[];
% for i=1:n
%     if isempty(Cdata{i})
%         continue
%     end
%     data{i}=Cdata{i}(:,5);
% end
% dataToWrite=[dataToWrite; dealwithOne( data, handles )];
% %3連複人気
% handles.dstyle='3連複人気';
% data=[];
% for i=1:n
%     if isempty(Cdata{i})
%         continue
%     end
%     data{i}=Cdata{i}(:,6);
% end
% dataToWrite=[dataToWrite; dealwithOne( data, handles )];
% %2連単人気
% handles.dstyle='2連単人気';
% data=[];
% for i=1:n
%     if isempty(Cdata{i})
%         continue
%     end
%     data{i}=Cdata{i}(:,7);
% end
% dataToWrite=[dataToWrite; dealwithOne( data, handles )];
% %2連複人気
% handles.dstyle='2連複人気';
% data=[];
% for i=1:n
%     if isempty(Cdata{i})
%         continue
%     end
%     data{i}=Cdata{i}(:,8);
% end
% dataToWrite=[dataToWrite; dealwithOne( data, handles )];



end



