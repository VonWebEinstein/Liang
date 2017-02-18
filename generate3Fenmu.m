function [ F ] = generate3Fenmu( data )
%产生三个数的分母
%   F={A1,A2,A3,B112,B113,B123,B012,B013,B023,B2,C1,C0}

if iscell(data)
    tmp=[];
    for i=1:length(data)
        tmp=[tmp;data{i}];
    end
    data=tmp;
    clear tmp;
end
m=max(max(data));
A1=[(1:m)', zeros(m,1)];
A2=A1;
A3=A1;

B112=sortrows(unique([data(:,[1 2]); data(:,[1 3]); data(:,[2 3])],'rows'));
B112=B112(B112(:,1)>0,:);
B112=[B112, zeros(size(B112,1),1)];
B113=B112;
B123=B112;

B012=unique(sort(B112(:,[1 2]),2),'rows');
B012=B012(B012(:,1)>0,:);
B012=[B012, zeros(size(B012,1),1)];
B013=B012;
B023=B012;
B2=B012;

C1=sortrows(unique(data,'rows'));
C1=C1(C1(:,1)>0,:);
C1=[C1, zeros(size(C1,1),1)];
C0=unique(sort(C1(:,[1 2 3]),2),'rows');
C0=[C0, zeros(size(C0,1),1)];

F={A1,A2,A3,B112,B113,B123,B012,B013,B023,B2,C1,C0};
end

