%  trunck file

flist={'01_Í©¡¡Éú','02_‘õ¡¡Ìï','03_½­‘õ´¨','04_Æ½ºÍu','05_¶àÄ¦´¨','06_äºÃûºþ','07_ÆÑ¡¡¿¤','08_³£¡¡»¬','09_½ò',...
            '10_Èý¡¡¹ú','11_ÅýÅÃºþ','12_×¡Ö®½­','13_Äá¡¡Æé','14_øQ¡¡éT','15_Íè¡¡w','16_ƒ¹¡¡u','17_Œm¡¡u','18_Ô¡¡É½','19_ÏÂ¡¡év',...
            '20_Èô¡¡ËÉ','21_Â«¡¡ÎÝ','22_¸£¡¡Œù','23_ÌÆ¡¡½ò','24_´ó¡¡´å'};

dataPath=[pwd '\Í§\'];
for i=1:length(flist)
    fname=[dataPath, flist{i}, '.txt'];
    dat=importdata(fname);
    dat=dat(dat(:,1) >= 20160101,:);
    % clear file
    dlmwrite(fname, [] ,'delimiter', ' ', 'newline','pc');
    % rewrite
    dlmwrite(fname, dat,'precision','%d' ,'-append','delimiter', ' ', 'newline','pc');
end