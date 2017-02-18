a=reshape(1:300,3,[])';
tic
dlmwrite('exp.txt',a ,'precision','%d' ,'-append','delimiter', ' ', 'newline','pc');
toc
a=reshape(1:300,3,[]);
tic
fp = fopen('exp2.txt', 'wt');
fprintf(fp, '%d  %d  %d\n', a);
fclose(fp);
toc

tic
x=load('exp.txt');
toc

tic
x2=importdata('exp.txt');
toc