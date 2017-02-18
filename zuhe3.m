function [ m ] = zuhe3( n )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
m=[];
for i=1:n
    for j=i:n
        for k=j:n
            if i~=j&&j~=k&&i~=k||(i==j&&i==5&&k~=5)||(i==k&&i==5&&j~=5)||(k==j&&k==5&&i~=5)
                m=[m;[i j k]];
            end
        end
    end
end
end

