
function showmap
fig=figure( 'Name','Timer','Position',[0,0,500,500] ,'NumberTitle','off','visible','off');
movegui(fig,'center');
set(fig,'visible','on');
ttext= uicontrol('Style','edit','Position',[150,250,200,30],'String','Press  "Start"',...
    'KeyPressFcn',@keyPress);

ii=0;

    function keyPress(x,y)
        set(ttext,'string',num2str(ii));
        ii = ii+1;
    end
end


