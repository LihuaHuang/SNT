function x = SAT_cvx(b, A, lambda, gamma, T, x0)
    % Function to solve the Regularized Modified BPDN problem
    % Inputs:
    % A - Matrix A
    % b - Vector b
    % lambda - Regularization parameter for data fidelity term
    % gamma - Regularization parameter for elements outside the support
    % T - Indices of the known support
    % Output:
    % x - Solution vector


    % Create the complement of the support T
    n = size(A, 2);
    Tc = setdiff(1:n, T);

    % CVX optimization
    cvx_begin
        variable x(n);
%        x >= 0; 
        minimize(  norm(x(Tc), 1) +(lambda / 2) * pow_pos(norm(x(T) - x0(T), 2),2) + (gamma / 2) * pow_pos(norm(A * x - b, 2),2));
    cvx_end
end

