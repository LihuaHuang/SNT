function [x, nitr] = WCS_LP(y,A,w)
%Weighted L1 Optimization,using LP algorithm (w>0)
[m,n] = size(A);
%[z,f_value,return_value,itr] = linprog([w;w],-eye(2*n),zeros(2*n,1),[A,-A],y);
[z,f_value,return_value,itr] = linprog([w;w],[],[],[A,-A],y,zeros(2*n,1));
x = z(1:n)-z(n+1:2*n);
nitr = itr.iterations;
end

