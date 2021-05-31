function [position] = move(position, l_room)
%MOVE target in an adjacent cell
moves=[1 -10 10 -1];
%1 -> up
%-10 -> left
%10 -> right
%-1 -> down

casual=randperm(4);

for i=1:5
    if position+moves(casual(i))<=l_room^2 && position+moves(casual(i))>0
        break
    end
end
position=position+moves(casual(i));
casual=0;
end

