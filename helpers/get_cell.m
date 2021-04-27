function cell = get_cell(x,y,size)
%GET_CELL returns cell position in a square matrix starting
% from x and y coordinates

x = x-1;
cell = x*size + y;

end

