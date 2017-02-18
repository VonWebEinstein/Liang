function [ outdata ] = parseTableFromHTML( sourcefile, regexpression, patten )
%parse single table from html
%   r is string of a table
%   patten is 'match' or 'tokens'
%   out is the data of the table, cell array
%   cells whitch rowspan or colspan >1 were filled with the same value

%[sourcefile, status] =urlread(sprintf('http://app.boatrace.jp/race/pay/?day=20150508'));
% Convert any data in cell arrays to characters
sourcefile=decell(sourcefile);

% get rows
rows = regexpi(sourcefile, '<tr.*?>.*?</tr>', 'match');
% clear r;
rowspan=0;
colspan=0;
% rowindex and colindex point to actual index
rowindex=1;
colindex=1;
% indicate cell is used or not
filling=0;

for i=1 : length(rows)
    %   get columns
    cols = regexpi(rows{i}, '<t[hd].*?>.*?</t[hd]>', 'match');
    for j=1:length(cols)
        %   update rowspan and colspan
        tmp=regexpi(cols{j},'<t[hd].*?rowspan="(\d*)"','tokens');
        if isempty(tmp)
            rowspan(i,j) = 1;
        else
            rowspan(i,j) = str2double(decell(tmp));
        end
        tmp=regexpi(cols{j},'<t[hd].*?colspan="(\d*)"','tokens');
        if isempty(tmp)
            colspan(i,j) = 1;
        else
            colspan(i,j) = str2double(decell(tmp));
        end
        
        % mark used cells with 1
        filling(rowindex:rowindex+rowspan(i,j)-1, colindex:colindex+colspan(i,j)-1)=1;
        
        % parse data from single cell
        outdata{rowindex, colindex} = regexp(decell(cols{j}), regexpression, patten);

        %expand the cell if combined
        if rowspan(i,j)+colspan(i,j)>2
            for k=rowindex:rowindex+rowspan(i,j)-1
                for l=colindex:colindex+colspan(i,j)-1
                    outdata{k,l} = outdata{rowindex, colindex};
                end
            end
        end
        
        % update  colindex
        if all(filling(rowindex,:))
            colindex=size(filling,2)+1;
        else
            colindex=find(filling(rowindex,:)==0,1);
        end
    end
    
    % update rowindex and colindex
    if size(filling,1)==i
        rowindex=rowindex+1;
        colindex=1;
    else
        rowindex=rowindex+1;
        while( sum(filling(rowindex,:))==sum(filling(rowindex-1,:)) )
            rowindex=rowindex+1;
        end
        colindex=find(filling(rowindex,:)==0, 1 );
    end
    
    
    %end
end

