% Cdata=xlsread('Ý†-ÀúÊ·.xls');
[~, n]=size(Cdata);
id=(n+1)/5;
Data=[];
lun=[];
for i=1:id
    
    Data= Cdata(:,(5* id-3):(5* id-1));
    Data=Data(~isnan(Data(:,1)),:);
    lun=[lun;Data];
end
Data=lun;
clear lun;


[DA1]=a(Data(:,1));
[DA2]=a(Data(:,2));
[DA3]=a(Data(:,3));
[DB112] = b(Data(:,[1 2]),1 );
[DB113] = b(Data(:,[1 3]),1);
[DB123] = b(Data(:,[2 3]),1);
[DB012] = b(Data(:,[1 2]),0);
[DB013] = b(Data(:,[1 3]),0);
[DB023] = b(Data(:,[2 3]),0 );
[DB2] =c(Data,2 );
[DC1] = c(Data,1 );
[DC0] = c(Data,0);
%     

