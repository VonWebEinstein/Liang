function [ r ] = decell ( r )
%wipe off the cell nesting
% r is 1x1 mat
i=20;
while (iscell(r)&&size(r,1)*size(r,2)==1)
    if isempty(r)
        r=[];
        break
    else
        r = r{1};
        i=i-1;
        if ~i
            disp('decell ERROR')
            break
        end
    end
end

end

