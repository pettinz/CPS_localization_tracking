function [x,y] = get_coordinates(cell,size)
%GET_COORDINATES returns x and y coordinates of a square matrix cell

size = sqrt(size);
cell = cell - 1;
x = fix(cell/size);
y = mod(cell,size);

end

