% parameter = [LB 95CI, median, UB 95CI]
ka = [0.0287, 0.0326, 0.0448];
CL = [0.0311, 0.0326, 0.0341];
Q = [0.101, 0.125, 0.144];
Vc = [2.07, 2.48, 2.98];
Vp = [3.48, 3.91, 4.17];

% ICS
y0 = zeros(1, 4);
% weekly dosing regime
dose = [2.5, 2.5, 2.5, 2.5, 5, 5, 5, 5, 7.5, 7.5, 7.5, 7.5, 10, 10, 10, 10];

[A, B, C, D, E] = ndgrid(Vc, Vp, ka, CL, Q);
max = numel(A);

gcp();
parfor i = 1:max
    a = A(i); b = B(i); c = C(i); d = D(i); e = E(i);
    p = Patients.pkParameters(a, b, c, d, e);
    [t, y] = Patients.simulatePK(p, y0, dose);
    writematrix([t, y], sprintf('output_%d_%d_%d_%d_%d.csv', a, b, c, d, e));
end 

%%
% p = Patients.pdParameters(Vc(1), Vp(1), ka(1), CL(1), Q(1));
% y0 = zeros(1, 7);
% tic
% [t5, y5] = Patients.simulatePD(p, y0, dose);
% toc