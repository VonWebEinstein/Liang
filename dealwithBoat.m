function [ dataToWrite ] = dealwithBoat( Cdata, handles )
%   ����ͧ�����ݣ�����allR-1R~12R ѭ��
%   ����dealwithBoatwithOneR()
%   CData is a cell


dataToWrite=[];
% allR
%nR��ǣ�01_ͩ��-01R-����
handles.nRMark='';
%   ȥ��nR����ټ���
nRData={};
for i=1:length(Cdata)
    if isempty(Cdata{i})
        nRData{i}=[];
    else
        nRData{i}=Cdata{i}(:,[1 3:end]);
    end
end
dataToWrite=[dataToWrite; dealwithBoatwithOneR( nRData, handles )];

%   01R~12R
for n=1:12
    handles.nRMark=sprintf('%02dR',n);
    %   ��CData��ɸѡnR������
    nRData={};
    for i=1:length(Cdata)
        if isempty(Cdata{i})
            nRData{i}=[];
        else
            nRData{i}=Cdata{i}(Cdata{i}(:,2)==n,[1 3:end]);
        end
    end
    dataToWrite=[dataToWrite; dealwithBoatwithOneR( nRData, handles )];
end

dataToWrite=[{'��ِ��','��ِ���','����','ʣ����','���ո�','����','���F����'};dataToWrite];
end

