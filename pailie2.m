function [FullB]= pailie2(a,b)
tic

A = nchoosek(a,b);
B = arrayfun(@(k)perms(A(k,:)),(1:size(A,1))','UniformOutput',false);
FullB = cell2mat(B);
toc

end
