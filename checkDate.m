function checkDate(queryDate)
% ¼ì²éÈÕÆÚ
for i=queryDate
    d=datevec(datenum(num2str(i),'yyyymmdd'));
    if sum([10000,100,1].*d(1:3))~=i
        set(handles.edit3,'BackgroundColor',[.92 .84 .84] );
    end
end
end
