% generate path measurement data.
% congested links with 10 ms delay, while the other links experience fixed delay value
% sampled from exponentially distribution.
% Require routing matrix A1 A2.
[n1, m] = size(A1);
[n2, m] = size(A2);
x = zeros(m,tot);
y = zeros(n1,tot);
mu = 2;  % 0.01
% congestedlevel = 0.02;  % 0.02
bad_link_value = 10; bad_link_num = round(congestedlevel*m);

% Initial link delay simulation
bad_link = randperm(m,bad_link_num);      % Links in the network have the same congestion probability.
x_tmp = exprnd(mu,m,1); x_tmp(bad_link) = bad_link_value;
x(:,1) = x_tmp;
sigma = 1; noise = normrnd(0,sigma,[n1 1]);   % gaussian noise
y(:,1) = A1*x(:,1)+noise;
% d = 1;   % The number of changes, passed in from an external file.

% At each time slot, change the state of \(d\) links.
for t = 2 : tot
    x(:, t) = x(:, t-1); 
    for j = 1:d
    if rand()>0.1 && bad_link_num>0     
        bad_to_good_link = randsample(bad_link, 1);
        x(bad_to_good_link, t) = exprnd(mu,1,1);  
        bad_link = setdiff(bad_link, bad_to_good_link);
        
        good_link = setdiff(1:m, bad_link);
        good_to_bad_link = randsample(good_link, 1);
        x(good_to_bad_link, t) = bad_link_value;
        bad_link = union(bad_link, good_to_bad_link);
    
    end
    end

    y(1:n2,t) = A2*x(:,t) + normrnd(0,sigma,[n2 1]);
end