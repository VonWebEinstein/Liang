[sourcefile, status] =urlread(sprintf('http://app.boatrace.jp/race/pay/?day=20150508'));
if ~status
    error('∂¡»°¥ÌŒÛ\n')
end
mexp='<table>(.*?)</table>';
r=regexp(sourcefile, mexp, 'tokens');
r=r{1};

% Convert any data in cell arrays to characters
while(iscell(r))
    r = r{1};
end

%Establish a row index
rowind = 0;

% Build cell aray of table data

    rows = regexpi(r, '<tr.*?>(.*?)</tr>', 'tokens');
    for i = 1:numel(rows)
        colind = 0;
        if (isempty(regexprep(rows{i}{1}, '<.*?>', '')))
            continue
        else
            rowind = rowind + 1;
        end
        
        headers = regexpi(rows{i}{1}, '<th.*?>(.*?)</th>', 'tokens');
        if ~isempty(headers)
            for j = 1:numel(headers)
                colind = colind + 1;
                data = regexprep(headers{j}{1}, '<.*?>', '');
                if (~strcmpi(data,'&nbsp;'))
                    out{rowind,colind} = strtrim(data);
                end
            end
            continue
        end
        cols = regexpi(rows{i}{1}, '<td.*?>(.*?)</td>', 'tokens');
        for j = 1:numel(cols)
            if(rowind==1)
                if(isempty(cols{j}{1}))
                    continue
                else
                    colind = colind + 1;
                end
            else
                colind = j;
            end
            data = regexprep(cols{j}{1}, '&nbsp;', ' ');
            data = regexprep(data, '<.*?>', '');
            
            if (~isempty(data))
                out{rowind,colind} = strtrim(data) ;
            end
        end
    end

