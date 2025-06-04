function [ Ro ] = MaxIndRows( Ri )
%MAXINDROWS Find the maximum linearly independent rows of \(R_i\).

RR = Ri';
[~, jb] = rref(RR);
RRR = RR(:, jb);
Ro = RRR';
end

