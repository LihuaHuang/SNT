[n, m] = size(A);
x = zeros(m,tot);
y = zeros(n,tot);
mu = 0.02;  % 0.01
% congestedlevel = 0.02;  % 0.02
bad_link_value = 10; bad_link_num = round(congestedlevel*n);

% Initial link delay simulation
bad_link = randperm(m,bad_link_num);      % Links in the network have the same congestion probability.
x_tmp = exprnd(mu,m,1); x_tmp(bad_link) = bad_link_value;
x(:,1) = x_tmp;
sigma = 1; noise = normrnd(0,sigma,[n 1]);   % gaussian noise
y(:,1) = A*x(:,1)+noise;
% d = 1;   % The number of changes, passed in from an external file.

% At each time slot, change the state of \(d\) links.
p1 = 1/(m-bad_link_num); p2 = 1/bad_link_num;

for t = 2:tot
    x(:, t) = x(:, t-1);
    
    % Randomly select \(d\) bad links to turn into good ones from the current set of bad links.
    if ~isempty(bad_link)
        bad_to_good = randsample(bad_link, min(d, length(bad_link))); 
        x(bad_to_good, t) = exprnd(mu, length(bad_to_good), 1);
        bad_link = setdiff(bad_link, bad_to_good);
    end
    
    % Randomly select \(d\) good links to turn into bad ones from the current set of good links.
    good_link = setdiff(1:m, bad_link);
    if ~isempty(good_link)
        good_to_bad = randsample(good_link, min(d, length(good_link))); 
        x(good_to_bad, t) = bad_link_value;
        bad_link = union(bad_link, good_to_bad);
    end
    y(:,t) = A*x(:,t) + normrnd(0, sigma, [n 1]);
end