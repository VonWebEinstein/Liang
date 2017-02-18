url='http://app.boatrace.jp/race/?day=20110313';

for i=1:3
    [sourcefile, status]=urlread(url);
    if status
        break
    end
end
mexp='<table.*?</table>';
table=regexp(sourcefile, mexp, 'match');