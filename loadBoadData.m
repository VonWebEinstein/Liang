function  Cdata=loadBoadData( handles )
%load all boad data
%   Detailed explanation goes here
Cdata={};
%     if get(handles.checkbox_FenmuFromNewData,'value')
totalN=length(handles.matchname);
handles.isChoosed=getButtonPanelValue(handles);
dataPath=[pwd '\比賽結果\艇\'];
for i=1:totalN
    Cdata{i}=importdata([dataPath, handles.matchname{i}, '.txt']);
end

%   增加艇的几组组合项作为’新的场地‘，
%   组合1，01_桐　生，07_蒲　郡，15_丸　亀，20_若　松；
%   组合2，02_戸   田，03_江戸川，04_平和島，05_多摩川，06_浜名湖，08_常　滑；
%   组合3，09_津，10_三　国，11_びわこ，12_住之江，13_尼　崎，14_鳴　門，16_児　島；
%   组合4，17_宮　島，18_徳　山，19_下　関，21_芦　屋，22_福　岡，23_唐　津，24_大　村；
%   组合5，所有场地 除01_桐　生，07_蒲　郡，15_丸　亀，20_若　松；（半天）
%   组合6，所有场地（全天）

combinationList={[1 7 15 20],[2:6 8],[9:14 16],[17:19 21:24],[2:6 8:14 16:19 21:24],[1:24]};
for i=1:length(combinationList)
    for j=1:length(combinationList{i})
        Cdata{24+i}=[Cdata{24+i};Cdata{combinationList{i}(j)}];
    end
    %按日期和场次排列
    Cdata{24+i}=sortrows(Cdata{24+i}, [1 2]);
end

end

function p=getButtonPanelValue(h)
% 获取Panel中ToggleButton的状态
% p是向量
p(1)=get(h.togglebutton1,'value');
p(2)=get(h.togglebutton2,'value');
p(3)=get(h.togglebutton3,'value');
p(4)=get(h.togglebutton4,'value');
p(5)=get(h.togglebutton5,'value');
p(6)=get(h.togglebutton6,'value');
p(7)=get(h.togglebutton7,'value');
p(8)=get(h.togglebutton8,'value');
p(9)=get(h.togglebutton9,'value');
p(10)=get(h.togglebutton10,'value');
p(11)=get(h.togglebutton11,'value');
p(12)=get(h.togglebutton12,'value');
p(13)=get(h.togglebutton13,'value');
p(14)=get(h.togglebutton14,'value');
p(15)=get(h.togglebutton15,'value');
p(16)=get(h.togglebutton16,'value');
p(17)=get(h.togglebutton17,'value');
p(18)=get(h.togglebutton18,'value');
p(19)=get(h.togglebutton19,'value');
p(20)=get(h.togglebutton20,'value');
p(21)=get(h.togglebutton21,'value');
p(22)=get(h.togglebutton22,'value');
p(23)=get(h.togglebutton23,'value');
p(24)=get(h.togglebutton24,'value');
p(25)=get(h.togglebutton25,'value');
p(26)=get(h.togglebutton26,'value');
p(27)=get(h.togglebutton27,'value');
p(28)=get(h.togglebutton28,'value');
p(29)=get(h.togglebutton29,'value');
p(30)=get(h.togglebutton30,'value');


end 
function setButtonPanelValue(h,p)

set(h.togglebutton1,'value',p(1));
set(h.togglebutton2,'value',p(2));
set(h.togglebutton3,'value',p(3));
set(h.togglebutton4,'value',p(4));
set(h.togglebutton5,'value',p(5));
set(h.togglebutton6,'value',p(6));
set(h.togglebutton7,'value',p(7));
set(h.togglebutton8,'value',p(8));
set(h.togglebutton9,'value',p(9));
set(h.togglebutton10,'value',p(10));
set(h.togglebutton11,'value',p(11));
set(h.togglebutton12,'value',p(12));
set(h.togglebutton13,'value',p(13));
set(h.togglebutton14,'value',p(14));
set(h.togglebutton15,'value',p(15));
set(h.togglebutton16,'value',p(16));
set(h.togglebutton17,'value',p(17));
set(h.togglebutton18,'value',p(18));
set(h.togglebutton19,'value',p(19));
set(h.togglebutton20,'value',p(20));
set(h.togglebutton21,'value',p(21));
set(h.togglebutton22,'value',p(22));
set(h.togglebutton23,'value',p(23));
set(h.togglebutton24,'value',p(24));
set(h.togglebutton25,'value',p(25));
set(h.togglebutton26,'value',p(26));
set(h.togglebutton27,'value',p(27));
set(h.togglebutton28,'value',p(28));
set(h.togglebutton29,'value',p(29));
set(h.togglebutton30,'value',p(30));


end