function [ dataToWrite ] = dealwithBoatwithOneR( Cdata, handles )
%����ͧ�����ݣ����е�nR����������R
%   Detailed explanation goes here
%   ����(20150520), 3�B�g(3), 3�B�g�˚�(1), 3�B�}�˚�(1), 2�B�g�˚�(1), 2�B�}�˚�(1)
dataToWrite=[];
n=length(Cdata);
%3�B�g
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
% %3�B�g�˚�
% handles.dstyle='3�B�g�˚�';
% data=[];
% for i=1:n
%     if isempty(Cdata{i})
%         continue
%     end
%     data{i}=Cdata{i}(:,5);
% end
% dataToWrite=[dataToWrite; dealwithOne( data, handles )];
% %3�B�}�˚�
% handles.dstyle='3�B�}�˚�';
% data=[];
% for i=1:n
%     if isempty(Cdata{i})
%         continue
%     end
%     data{i}=Cdata{i}(:,6);
% end
% dataToWrite=[dataToWrite; dealwithOne( data, handles )];
% %2�B�g�˚�
% handles.dstyle='2�B�g�˚�';
% data=[];
% for i=1:n
%     if isempty(Cdata{i})
%         continue
%     end
%     data{i}=Cdata{i}(:,7);
% end
% dataToWrite=[dataToWrite; dealwithOne( data, handles )];
% %2�B�}�˚�
% handles.dstyle='2�B�}�˚�';
% data=[];
% for i=1:n
%     if isempty(Cdata{i})
%         continue
%     end
%     data{i}=Cdata{i}(:,8);
% end
% dataToWrite=[dataToWrite; dealwithOne( data, handles )];



end



