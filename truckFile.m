%  trunck file

flist={'01_ͩ����','02_������','03_������','04_ƽ�͍u','05_��Ħ��','06_�����','07_�ѡ���','08_������','09_��',...
            '10_������','11_���ú�','12_ס֮��','13_�ᡡ��','14_�Q���T','15_�衡�w','16_�����u','17_�m���u','18_�ԡ�ɽ','19_�¡��v',...
            '20_������','21_«����','22_������','23_�ơ���','24_�󡡴�'};

dataPath=[pwd '\ͧ\'];
for i=1:length(flist)
    fname=[dataPath, flist{i}, '.txt'];
    dat=importdata(fname);
    dat=dat(dat(:,1) >= 20160101,:);
    % clear file
    dlmwrite(fname, [] ,'delimiter', ' ', 'newline','pc');
    % rewrite
    dlmwrite(fname, dat,'precision','%d' ,'-append','delimiter', ' ', 'newline','pc');
end