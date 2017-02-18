function [ out ] = parseCellOfTableFromHTML( origdata )
%parse a cell of table from html
%   do something youn want to capture data from the cell
%   origdata is str
%   out is a 1x1 cell

out = regexp(origdata, regexpDisjunction({expr1,expr2,expr3}), 'tokens');
% if isempty(out)
%     out='';
% else
%     out=decell(out);
% end
end

