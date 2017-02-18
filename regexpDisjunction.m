function [ se ] = regexpDisjunction( re )
%combine all the regular expressions to a single expression with logical OR
%   re is a cell vector with each element is 1x1 cell of string
%   se is a string used in regexp

se=re{1};
if length(re)>1

for i=2:length(re)
    se=[se, '|', re{i} ];

end
end

