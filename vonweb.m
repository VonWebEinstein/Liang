function varargout = vonweb(varargin)
% vonweb MATLAB code for vonweb.fig
%      vonweb, by itself, creates a new vonweb or raises the existing
%      singleton*.
%
%      H = vonweb returns the handle to a new vonweb or the handle to
%      the existing singleton*.
%
%      vonweb('CALLBACK',hObject,eventdata,handles,...) calls the local
%      function named CALLBACK in vonweb.M with the given input arguments.
%
%      vonweb('Property','Value',...) creates a new vonweb or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before vonweb_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to vonweb_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, guidata, GUIHANDLES

% Edit the above text to modify the response to help vonweb

% Last Modified by GUIDE v2.5 25-Dec-2016 21:07:08

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @vonweb_OpeningFcn, ...
    'gui_OutputFcn',  @vonweb_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before vonweb is made visible.
function vonweb_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user Data (see guidata)
% varargin   command line arguments to vonweb (see VARARGIN)

%initialize
handles.matchname={'01_桐　生','02_戸　田','03_江戸川','04_平和島','05_多摩川','06_浜名湖','07_蒲　郡','08_常　滑','09_津',...
            '10_三　国','11_琵琶湖','12_住之江','13_尼　崎','14_鳴　門','15_丸　亀','16_児　島','17_宮　島','18_徳　山','19_下　関',...
            '20_若　松','21_芦　屋','22_福　岡','23_唐　津','24_大　村','25_組合(桐蒲住丸若)','26_組合(戸江平多浜常)',...
            '27_組合(津三琵尼鳴児)','28_組合(宮徳下芦福唐大)', '29_組合(半天)','30_組合(全天)', ...
            '31_大组(12)', '32_大组(13)', '33_大组(14)', '34_大组(23)', '35_大组(24)', '36_大组(34)' };
set(handles.popupmenu1,'String',handles.matchname);
set(handles.popupmenu1,'Value',1);
handles.matchStyle={'単勝式','2連勝単式','2連勝複式','3連勝単式','3連勝複式','拡連複'};
set(handles.popupmenu2,'String',handles.matchStyle);
set(handles.popupmenu2,'Value',4);
set(handles.uitable,'Data',{});

set(handles.edit3,'String',datestr(today,'yyyymmdd'));

handles.hpath='.\history\艇\';

handles.loaded=0;
% Choose default command line output for vonweb
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes vonweb wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = vonweb_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user Data (see guidata)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user Data (see guidata)
set(handles.text_updateStatus,'string','正在計算...');
pause(0.1);


Cdata=loadBoadData(handles);
handles.isChoosed = getButtonPanelValue(handles);
%只取选择的场地计算
% matchIsSelected=false(1,length(Cdata));
% for i=1: length(handles.id2)
%     matchIsSelected(handles.id2(i))=1;
% end
Cdata(~logical(handles.isChoosed))={[]};

imname=[datestr(now,29),'-','艇'];
XX=dealwithBoat(Cdata, handles);

%数据是txt的话，改后缀
imname=[imname '.xls'];


%把XX排序
XX=sortXX(XX);
xlswrite([pwd,'\', imname],XX);
%清除更新分母等标记
set(handles.updateFenmu,'value',0);
set(handles.gFenmu,'value',0);
set(handles.checkbox_FenmuFromNewData,'value',0);
set(handles.text_updateStatus,'string','計算完成');

handles.complete=1;


%必须执行一次计算后，才能勾选更新分母，再次计算更新分母，已取消
handles.caculated=1;

guidata(hObject,handles);


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user Data (see guidata)

handles.isChoosed=true(size(handles.matchname));
setButtonPanelValue(handles,handles.isChoosed);

guidata(hObject,handles);
% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user Data (see guidata)
handles.isChoosed=zeros(size(handles.matchname));
setButtonPanelValue(handles,handles.isChoosed);

guidata(hObject,handles);


% --- Executes on key press with focus on edit2 and none of its controls.
function edit2_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)



function edit2_Callback(hObject, eventdata, handles)


% --- Executes on button press in updatedata.
function updatedata_Callback(hObject, eventdata, handles)
% hObject    handle to updatedata (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA
set(handles.text_updateStatus,'String','正在更新數據，暫勿執行其他操作');
pause(0.1);

parseboat(handles);

set(handles.text_updateStatus,'string','更新完成');

guidata(hObject,handles);
% --- Executes on button press in updateFenmu.
function updateFenmu_Callback(hObject, eventdata, handles)
% hObject    handle to updateFenmu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: get(hObject,'Value') returns toggle state of updateFenmu

% if handles.caculated==0
%     set(handles.updateFenmu,'value',0);
% end

%计算资料中的分母时才能更新分母
handles.takeFenmuFromNewData=get(handles.checkbox_FenmuFromNewData,'value');
if ~handles.takeFenmuFromNewData
    set(handles.updateFenmu,'value',0);
end
%勾选更新分母时，才能勾选生成分母
if  ~get(handles.updateFenmu,'value')
    set(handles.gFenmu,'value',0);
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function updateFenmu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to updateFenmu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
handles.caculated=0;
%如果没有选择文件
handles.fileChoose=0;
%没有计算完成
handles.complete=0;
guidata(hObject,handles);



% --- Executes on button press in gFenmu.
function gFenmu_Callback(hObject, eventdata, handles)
% hObject    handle to gFenmu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%必须勾选更新分母，才能勾选重新生成
if ~get(handles.updateFenmu,'value')
    set(handles.gFenmu,'value',0);
end
% Hint: get(hObject,'Value') returns toggle state of gFenmu

guidata(hObject,handles);
% --- Executes during object creation, after setting all properties.
function text_updateStatus_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text_updateStatus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in checkbox_FenmuFromNewData.
function checkbox_FenmuFromNewData_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_FenmuFromNewData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox_FenmuFromNewData
%是否计算资料中的分母，否：直接用读取到的分母，同时禁止更新分母
handles.takeFenmuFromNewData=get(hObject,'Value');
%取消计算资料中的分母时，同时取消上面两项
if ~handles.takeFenmuFromNewData
    set(handles.updateFenmu,'value',0);
    set(handles.gFenmu,'value',0);
end
guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1


% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton2


% --- Executes on button press in togglebutton3.
function togglebutton3_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton3


% --- Executes on button press in togglebutton4.
function togglebutton4_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton4


% --- Executes on button press in togglebutton5.
function togglebutton5_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton5


% --- Executes on button press in togglebutton23.
function togglebutton29_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton23


% --- Executes on button press in togglebutton6.
function togglebutton6_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton6


% --- Executes on button press in togglebutton7.
function togglebutton7_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton7


% --- Executes on button press in togglebutton8.
function togglebutton8_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton8


% --- Executes on button press in togglebutton9.
function togglebutton9_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton9


% --- Executes on button press in togglebutton10.
function togglebutton10_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton10


% --- Executes on button press in togglebutton21.
function togglebutton21_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton21 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton21


% --- Executes on button press in togglebutton11.
function togglebutton11_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton11


% --- Executes on button press in togglebutton12.
function togglebutton12_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton12


% --- Executes on button press in togglebutton13.
function togglebutton13_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton13


% --- Executes on button press in togglebutton14.
function togglebutton14_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton14


% --- Executes on button press in togglebutton15.
function togglebutton15_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton15


% --- Executes on button press in togglebutton22.
function togglebutton22_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton22 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton22


% --- Executes on button press in togglebutton16.
function togglebutton16_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton16


% --- Executes on button press in togglebutton17.
function togglebutton17_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton17


% --- Executes on button press in togglebutton18.
function togglebutton18_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton18


% --- Executes on button press in togglebutton19.
function togglebutton19_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton19


% --- Executes on button press in togglebutton20.
function togglebutton20_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton20 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton20


% --- Executes on button press in togglebutton23.
function togglebutton23_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton23 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton23


% --- Executes on button press in togglebutton24.
function togglebutton24_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton24 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton24


% --- Executes on button press in togglebutton25.
function togglebutton25_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton25
function togglebutton26_Callback(hObject, eventdata, handles)
function togglebutton27_Callback(hObject, eventdata, handles)
function togglebutton28_Callback(hObject, eventdata, handles)
% --- Executes on button press in togglebutton30.
function togglebutton30_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function buttonPanel_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to buttonPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double



guidata(hObject,handles);

            



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


guidata(hObject,handles);


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% 处理日期的输入
% 三种 单日20160201， 间断多日 20160201,20160205,20160504  连续多日20160101-20160201

%重置状态
set(handles.text_updateStatus,'BackgroundColor','white');
set(handles.text_updateStatus,'String','');
set(handles.edit5,'BackgroundColor','white');
set(handles.edit3,'BackgroundColor','white');
pause(0.01);

s=get(handles.edit3,'String');
s1=regexp(s,'^(\d\d\d\d\d\d\d\d)$','tokens');
if ~isempty(s1)%单日
    queryDate=str2double(s1{1}{1});
    checkDate(queryDate);
else
    s1=regexp(s,'^(\d\d\d\d\d\d\d\d)-(\d\d\d\d\d\d\d\d)$','tokens');%连续
    if ~isempty(s1)
        queryDate=[str2double(s1{1}{1}) str2double(s1{1}{2})];
        checkDate(queryDate);
        tmp=datenum(num2str(queryDate(1)),'yyyymmdd'):datenum(num2str(queryDate(2)),'yyyymmdd');
        queryDate=arrayfun(@(x) str2double(datestr(x,'yyyymmdd')), tmp);
        if queryDate(1)>queryDate(2)
            set(handels.edit3,'BackgroundColor',[.92 .84 .84] );
        end
    else
        if ~isempty(regexp(s,'^(\d\d\d\d\d\d\d\d,)*\d\d\d\d\d\d\d\d$','match'))
            s1=regexp(s,'(\d\d\d\d\d\d\d\d)','tokens');
            queryDate=arrayfun(@(x)str2double(s1{x}{1}),1:length(s1));
        else
            % 输入有误
            queryDate=[];
            set(handles.edit3,'BackgroundColor',[.92 .84 .84] );
        end
    end
end
if ~isempty(queryDate)
    set(handles.edit3,'BackgroundColor','white');
end
handles.queryDate=queryDate;




%检查面板输入
set(handles.edit5,'BackgroundColor','white');
s=get(handles.edit5,'String');
s1=regexp(s,'^(\d)$','tokens');
if isempty(s1)
    s1=regexp(s,'^(\d)\W(\d)$','tokens');
    if isempty(s1)
        s1=regexp(s,'^(\d)\W(\d)\W(\d)$','tokens');
        if isempty(s1)
            set(handles.edit5,'BackgroundColor',[.92 .84 .84]);
            set(handles.text_updateStatus,'String','输入有误');
            return
        end
    end
end

searchNO=arrayfun(@(x) str2double(s1{1}{x}), 1:length(s1{1})); %查询的警报

l=length(searchNO);

p=get(handles.popupmenu2,'Value');%竞赛类型
if (l==1&&p==1)||(l==2&&ismember(p,[2 3 6]))||(l==3&&ismember(p,[4 5]))
else
    set(handles.edit5,'BackgroundColor',[.92 .84 .84]);
    set(handles.text_updateStatus,'String','输入不匹配');
    return
end
handles.searchNO=searchNO;

searchRecord( handles );

guidata(hObject,handles);

% --- Executes on button press in clearUITable.
function clearUITable_Callback(hObject, eventdata, handles)
% hObject    handle to clearUITable (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.uitable,'Data',{});
guidata(hObject,handles);


% --- Executes on key press with focus on edit5 and none of its controls.
function edit5_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on key press with focus on edit3 and none of its controls.
function edit3_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


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
%   组合1，01_桐　生，07_蒲　郡，12_住之江，15_丸　亀，20_若　松；
%   组合2，02_戸   田，03_江戸川，04_平和島，05_多摩川，06_浜名湖，08_常　滑；
%   组合3，09_津，10_三　国，11_びわこ，13_尼　崎，14_鳴　門，16_児　島；
%   组合4，17_宮　島，18_徳　山，19_下　関，21_芦　屋，22_福　岡，23_唐　津，24_大　村；
%   组合5，所有场地 除01_桐　生，07_蒲　郡，15_丸　亀，20_若　松；（半天）
%   组合6，所有场地（全天）
%   大组1，组合1+组合2
%   大组2，组合1+组合3
%   大组3，组合1+组合4
%   大组4，组合2+组合3
%   大组5，组合2+组合4
%   大组6，组合3+组合4

combinationList={[1 7 12 15 20],[2:6 8],[9:11 13 14 16],[17:19 21:24],[2:6 8:14 16:19 21:24],[1:24]};
% 加上6个大组
combinationList=[combinationList, union(combinationList{1},combinationList{2}),...
    union(combinationList{1},combinationList{3}),...
    union(combinationList{1},combinationList{4}),...
    union(combinationList{2},combinationList{3}),...
    union(combinationList{2},combinationList{4}),...
    union(combinationList{3},combinationList{4})];
for i=1:length(combinationList)
    for j=1:length(combinationList{i})
        Cdata{24+i}=[Cdata{24+i};Cdata{combinationList{i}(j)}];
    end
    %按日期和场次排列
    Cdata{24+i}=sortrows(Cdata{24+i}, [1 2]);
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
p(31)=get(h.togglebutton31,'value');
p(32)=get(h.togglebutton32,'value');
p(33)=get(h.togglebutton33,'value');
p(34)=get(h.togglebutton34,'value');
p(35)=get(h.togglebutton35,'value');
p(36)=get(h.togglebutton36,'value');

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
set(h.togglebutton31,'value',p(31));
set(h.togglebutton32,'value',p(32));
set(h.togglebutton33,'value',p(33));
set(h.togglebutton34,'value',p(34));
set(h.togglebutton35,'value',p(35));
set(h.togglebutton36,'value',p(36));

% --- Executes on button press in togglebutton31.
function togglebutton33_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton31 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton31


% --- Executes on button press in togglebutton32.
function togglebutton34_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton32 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton32


% --- Executes on button press in togglebutton35.
function togglebutton31_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton35


% --- Executes on button press in togglebutton36.
function togglebutton32_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton36


% --- Executes on button press in togglebutton35.
function togglebutton35_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton35 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton35


% --- Executes on button press in togglebutton36.
function togglebutton36_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton36 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton36
