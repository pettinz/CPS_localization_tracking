function [position] = move(position, l_room)
%MOVE target in an adjacent cell
if mod(position, 10)==0
    moves=[-10 10 -1];
    poss=3;
elseif mod(position, 10)==1
    moves=[1 -10 10];
    poss=3;
else
    moves=[1 -10 10 -1];
    poss=4;
end
%1 -> up
%-10 -> left
%10 -> right
%-1 -> down

casual=randperm(poss);

for i=1:poss
    if position+moves(casual(i))<=l_room^2 && position+moves(casual(i))>0
        break
    end
end
position=position+moves(casual(i));
casual=0;
end

