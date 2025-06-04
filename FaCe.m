function link_prob = FaCe(routing_matrix, path_status, prior_p, epsilon)
% A Bayesian Approach to Network Monitoring for Progressive Failure Localization
% FAILURE CENTRALITY
[m, n] = size(routing_matrix);
failed_paths = routing_matrix(path_status == 1, :);
working_paths = routing_matrix(path_status == 0, :);

% 1. Identify all links that are traversed by successful paths.
working_links = any(working_paths, 1); % 1¡ÁnLogical vector

% 2. Initialize link probabilities to 0 for successful links or to prior probabilities for other links.
link_prob = prior_p * ones(1, n);
link_prob(working_links) = 0; 

% 3. If all links have been covered by successful paths, return directly.
if all(working_links)
    return;
end

% ----------------------------
% Prune the failed paths: Remove the links that are known to be normal.
% ----------------------------
pruned_failed = failed_paths;
pruned_failed(:, working_links) = 0; % Set the known normal links to zero.

% ----------------------------
% Calculate the failure centrality of the remaining links.
% ----------------------------
active_links = find(~working_links); 
for v = active_links
    F_v = find(pruned_failed(:, v)); 
    if isempty(F_v)
        link_prob(v) = prior_p; 
        continue;
    end
    
    % T1
    path_lengths = sum(pruned_failed(F_v, :), 2);
    T1 = mean(1 ./ path_lengths);
    
    % T2
    union_nodes = sum(any(pruned_failed(F_v, :), 1));
    P_v = length(F_v) / union_nodes;
    if P_v >= 1
        T2 = 1 - epsilon / P_v;
    else
        T2 = P_v;
    end
    
    % Update the probabilities.
    link_prob(v) = max(T1, T2);
end

end