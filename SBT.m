function [x] = SBT(R, y, x_last, lambda)
%SBT  Sequential Boolean Tomography, assigning different weights to the links from the previous moment and the new links.
%    SBT is equivalent to TOMO without weights, where at each step it seeks the link that best explains the path, but assigns greater weight to new links.
tmp = logical(sum(R(~logical(y), :), 1));
Rc = R(logical(y), :);

[m, n] = size(Rc);
Pc = (Rc-repmat(tmp, m, 1)==1);

x = zeros(n ,1); Domain = Pc;
Qb = ones(m, 1);

w = x_last'+0; w(w==0)=lambda;     % If it is a new link, assign a weight of \(\lambda\) (\(\lambda > 1\)), otherwise assign a weight of 1.
while sum(Qb)>0
    score = w./sum(Domain, 1);
    ei = find(score==min(score));
    
    for i=1:length(ei)
        x(ei(i)) = 1;
        Qb = (Qb-Domain(:, ei(i)))>0;
        Domain = (Domain-repmat(Domain(:, ei(i)), 1, n))>0;
    end
end

end

