%[str, ~] =urlread(sprintf('http://app.boatrace.jp/race/pay/?day=20150508'));
expr1 = '<td\scolspan="14"\salign="left"\svalign="middle"\sbgcolor="#eeeeee"><font\ssize="3">#\s*(\S*)\s*<strong>\s*(\S*)\s*</strong>\s*¸‚Í§ˆö</font>.*?</table>';
a='\s*(%d*)\s*<strong>\s*(\S*)\s*</strong>\s¸‚Í§ˆö</font></td>';
[table, x]=regexpi(sourcefile, expr1, 'match','tokens');

b='<img\ssrc="\.\./img/(\d*)\.gif"';
c='bgcolor="#FFFFCC"><font\ssize="3">\s*(\S*)\s*</font></td>';

y=regexpi(table{1}, c, 'tokens');
