ka = [0.0287, 0.0363, 0.0448];
CL = [0.0311, 0.0326, 0.0341];
Q = [0.101, 0.125, 0.144];
Vc = [2.07, 2.48, 2.98];
Vp = [3.48, 3.91, 4.17];
[A, B, C, D, E] = ndgrid(Vc, Vp, ka, CL, Q);
max_ = numel(A);

central_AUC = zeros(1, 243); %IDs = zeros(1, 243);
peripheral_AUC = zeros(1, 243);
data = importdata("data/output_2.480000e+00_3.910000e+00_3.630000e-02_3.260000e-02_1.250000e-01.csv");
y = data(:, 1:end);
reference_central_AUC = trapz(y(:, 1));
reference_peripheral_AUC = trapz(y(:, 2));
FILE_NAMES = dir(fullfile("data/", "*.csv"));

%% AUC
parfor i = 1:max_
    a = A(i); b = B(i); c = C(i); d = D(i); e = E(i);
    % Vc_idx = string(find(Vc == a));
    % Vp_idx = string(find(Vp == b));
    % ka_idx = string(find(ka == c));
    % CL_idx = string(find(CL == d));
    % Q_idx  = string(find(Q == e));
    % IDs(i) = Vc_idx + Vp_idx + ka_idx + CL_idx + Q_idx
    % file = FILE_NAMES(i).name;
    % data = importdata("data/" + file);
    data = importdata("data/" + sprintf('output_%s_%s_%s_%s_%s.csv', a, b, c, d, e))
    central = data(:, 2);  % data(:, 1) is time
    peripheral = data(:, 3);
    central_AUC(i) = trapz(central);
    peripheral_AUC(i) = trapz(peripheral);
end
%%

f = boxchart([ ...
    central_AUC' ./ 1e5, ... %/ reference_central_AUC, ...
    peripheral_AUC' ./ 1e5 ... %/ reference_peripheral_AUC, ...
    ]);
title("Distribution of Compartment AUCs for Titrated Dosing Schedule", "FontSize", 16)
xticklabels(["Central", "Peripheral"])
ylabel("AUC (in ten thousands)", "FontSize", 16)