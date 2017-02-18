function [ dataToWrite ] = dealwithLun( Cdata, handles )
%   处理輪的数据，按照allR-1R~12R 循环
%   调用dealwithLunwithOneR()
%   CData is a cell
%   %   数据格式： 日期(20150520), nR(1), 3連単(3), 2枠連(2)
dataToWrite=[];
% allR
%nR标记，01_桐生-01R-枠番
handles.nRMark='';
%   去除nR标记再计算
nRData={};
for i=1:length(Cdata)
    if isempty(Cdata{i})
        continue
    else
        nRData{i}=Cdata{i}(:,[1 3:end]);
    end
end
dataToWrite=[dataToWrite; dealwithLunwithOneR( nRData, handles )];

%   01R~12R
for n=1:12
    handles.nRMark=sprintf('%02dR',n);
    %   从CData中筛选nR的数据
    nRData={};
    for i=1:length(Cdata)
        if isempty(Cdata{i})
            continue
        else
            nRData{i}=Cdata{i}(Cdata{i}(:,2)==n,[1 3:end]);
        end
    end
    dataToWrite=[dataToWrite; dealwithLunwithOneR( nRData, handles )];
end

dataToWrite=[{'競賽場','競賽類型','警報','剩余数','最大空格','比率','出現回数'};dataToWrite];
end


