function run( fileName, d, m1, m2 )
%RUN Run SAT, SBT, and other methods.
%   fileName: routing matrix
%   d: Number of link state transitions
%   m1: number of measurements at time 1
%   m2: number of measurements at time t>1
    Agen = load(fileName, 'R');
    A = Agen.R;
    A1 = A(1:m1, :);
    A1 = MaxIndRows(A1);
    A2 = A(1:m2, :);
    A2 = MaxIndRows(A2);

    SAT_SBT;
end

