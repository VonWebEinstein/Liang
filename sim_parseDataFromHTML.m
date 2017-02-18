function [   ] = sim_parseDataFromHTML( date , website, regexpressions, startdate, lastdate, isfirstday, handles)
%new function to parse boat data from http://kyotei.sakura.ne.jp/kekka_kako.php?y=2015&m=05&d=20
%parse all tables of boat
%   date is vector of date yyyy mm dd ...
%   function write data to txt files with no output variable
%   startdate , lastdate, ���ݵ���������
%   regexperssions 1:parse tables 2:parse results 3:parse �˚�


% extraldata=importdata([pwd,'\extraldata\ͧ\����.txt']);
% date=[2015 5 20 0 0 0];
% regexpressions=extraldata(2:end);
website=sprintf(website, date(1),date(2),date(3));
curdate=date(1)*10000+date(2)*100+date(3);
% disp(num2str(curdate))
set(handles.text_updateStatus,'string',sprintf('%d/%02d/%02d',date(1), date(2), date(3)));
pause(0.01);
for i=1:3
    [sourcefile, status] =urlread(website);
    if status
        break;
    end
end
if ~status
    set(handles.text_updateStatus,'string','Ո��ԇ��z��W�j�B��');
end

% count table number and take match name
[table, matchname]=regexp(sourcefile, regexpressions{1}, 'match','tokens');
for i=1:length(table)
%     outdata1 = regexpi(table{i}, regexpressions{2}, 'tokens');%����ʽ
    outdata1=[];
    outdata1_tmp = parseTableFromHTML( table{i}, 'div\sclass="rb">(\d*)</div>', 'tokens' );
    %����ʽ���ڶ��У��ڶ��п�ʼ
    for rows=2:size(outdata1_tmp,1)
        tmp=[];
        if ~isempty(outdata1_tmp{rows,2})
            for j=1:length(outdata1_tmp{rows,2})
                tmp=[tmp str2double(outdata1_tmp{rows,2}{j}{1})];
            end
        end
        if length(tmp)<3
            tmp=[tmp zeros(1,3-length(tmp))];
        end
        outdata1=[outdata1; tmp];
    end
    outdata2 = regexpi(table{i}, regexpressions{3}, 'tokens');%����ʽ
    outdata3 = regexpi(table{i}, '<b>(\d*)</b></a></td>', 'tokens');%nR
    
    %ת����ֵ
    tmp=[];
    for itmp=1:length(outdata3)
        tmp(itmp)=str2double(outdata3{itmp}{1});
    end
    outdata3=tmp';
%     
%     tmp=[];
%     for itmp=1:length(outdata1)
%         tmp(itmp)=str2double(outdata1{itmp}{1});
%         if isnan(tmp(itmp))
%             tmp(itmp)=0;
%         end
%     end
% %     outdata1=reshape(tmp,10,[])';
%     outdata1=[tmp(1:10:end)',tmp(2:10:end)',tmp(3:10:end)'];
%     tmp=[];
%     outdata1=outdata1(:,1:3);
    
    for itmp=1:length(outdata2)
        tmp(itmp)=str2double(outdata2{itmp}{1});
        if isnan(tmp(itmp))
            tmp(itmp)=0;
        end
    end
    outdata2=reshape(tmp,4,[])';
    tmp=[];
    
    %�������
    
    outdata=[repmat(curdate,size(outdata1,1),1),outdata3,outdata1, outdata2];
    
    %���������ļ���
    if length(matchname{i}{2})==2
        matchname{i}{2}=[matchname{i}{2}(1) '��' matchname{i}{2}(2)];
    end
    filename=sprintf('%s_%s.txt', matchname{i}{1}, matchname{i}{2});
    %disp([num2str(curdate), '-',filename])
    
    
    
    filename=[pwd '\��ِ�Y��\ͧ\' filename];
    %������һ��������Ƿ�����
    %���ܸ��²����������ݣ����޸�
    if  isfirstday && (datenum(date)==lastdate(str2double(matchname{i}{1})))
        %�û������һ�������
        oridata=importdata(filename);
        tf=oridata(:,1)==curdate;
        if isequal(oridata(tf,:),outdata)
            continue
        else
            writedata=[oridata(~(tf),:); outdata];
            fp = fopen(filename, 'wt');
            fprintf(fp, '%d %d %d %d %d %d %d %d %d\n', writedata');
            fclose(fp);
        end
    else
        dlmwrite(filename, outdata,'precision','%d' ,'-append','delimiter', ' ', 'newline','pc');
        %fp = fopen([pwd '\��ِ�Y��\ͧ\' filename], 'wt');
        %fprintf(fp, '%d  %d  %d  %d', writedata);
        %fclose(fp);
    end
end

end







