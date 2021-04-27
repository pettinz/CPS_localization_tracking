function [xr,yr] = get_ref(cell,l,size)
%GET_REF get position inside a cell

[xr,yr] = get_coordinates(cell,size);
xr = xr+l/2;
yr = yr+l/2;

end

