function [x] = TOMO(R, y)
%TOMO  The Boolean Solution to the Congested IP Link Location Problem: Theory and Practice
%     R: routing matrix y: measuments results{0 1} p: congested probability x: Location result 1
%     represents congested (0<p<0.5). TOMO is equivalent to not having p, where at each step it seeks the link that best explains the path.
tmp = logical(sum(R(~logical(y), :), 1));
Rc = R(logical(y), :);

[m, n] = size(Rc);
Pc = (Rc-repmat(tmp, m, 1)==1);

x = zeros(n ,1); Domain = Pc;
Qb = ones(m, 1);

while sum(Qb)>0
    score = 1./sum(Domain, 1);
    ei = find(score==min(score));
    
    for i=1:length(ei)
        x(ei(i)) = 1;
        Qb = (Qb-Domain(:, ei(i)))>0;
        Domain = (Domain-repmat(Domain(:, ei(i)), 1, n))>0;
    end
end

end

