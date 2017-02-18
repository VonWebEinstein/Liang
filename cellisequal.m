function [ r ] = cellisequal( c, a )
%c is a cell vector
%a is a 1x1 cell
%compare each element of c and a
%return a logical vector the same size as c

[m,n]=size(c);
r= false(m,n);
for i=1: max(m,n)
    r(i)=isequal(c(i),a);
end
end

