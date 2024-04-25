% parameter = [LB 95CI, median, UB 95CI]
ka = [0.0287, 0.0363, 0.0448];
CL = [0.0311, 0.0326, 0.0341];
Q = [0.101, 0.125, 0.144];
Vc = [2.07, 2.48, 2.98];
Vp = [3.48, 3.91, 4.17];

% ICS
y0 = zeros(1, 4);
% weekly dosing regime
dose = [2.5, 2.5, 2.5, 2.5, 5, 5, 5, 5, 7.5, 7.5, 7.5, 7.5, 10, 10, 10, 10];

[A, B, C, D, E] = ndgrid(Vc, Vp, ka, CL, Q);
max_ = numel(A);

% gcp();
% parfor i = 1:max_
%     a = A(i); b = B(i); c = C(i); d = D(i); e = E(i);
%     p = Model.pkParameters(a, b, c, d, e);
%     [t, y] = Model.simulatePK(p, y0, dose);
%     writematrix([t/168, y], sprintf('output_%d_%d_%d_%d_%d.csv', a, b, c, d, e));
% end 

%% Single Dose (YAEL) %%
dose = [2.5, 5, 7.5, 10];
hold on;
for i = 1:length(dose)
    [t, y] = Model.simulatePK(p, y0, dose(i));
    plot(t, y(:, 1));
end
hold off;

%% relative dose effect of dose skipping (YAEL)
clf
dose = ones(1, 16)*2.5;
p = Model.pkParameters(Vc(1), Vp(1), ka(1), CL(1), Q(1));
[~, y] = Model.simulatePK(p, y0, dose);
steady_state_y0 = y(end, :);
steady_dose = dose(1:4);
steady_min = min(y(:, 1));
steady_max = max(y(:, 1));
tiledlayout(4, 2);

nexttile; hold on;
[t, y] = Model.simulatePK(p, steady_state_y0, steady_dose);
patch([0, 0, length(y), length(y), 0], [0.4, 1, 1, 0.4, 0.4], 'r', 'FaceAlpha', 0.2);
plot(t, y(:, 1)/steady_max);


nexttile;  hold on;
[t, y] = Model.simulatePK(p, steady_state_y0, [2.5, 0, 2.5, 2.5]);
patch([0, 0, length(y), length(y), 0], [0.4, 1, 1, 0.4, 0.4], 'r', 'FaceAlpha', 0.2);
plot(t, y(:, 1)/steady_max);

for i = 1:6
    nexttile; hold on;
    dose_timing = (0:4)*168; dose_timing(2) = 168 + 24*i;
    [t, y] = skipDose(dose_timing, steady_state_y0, p);
    patch([0, 0, length(y), length(y), 0], [0.4, 1, 1, 0.4, 0.4], 'r', 'FaceAlpha', 0.2);
    plot(t, y(:, 1)/steady_max);
end


function [time, solution] = skipDose(dose_timing, y0, p)
    time = [];
    solution = [];
    for i = 1:length(dose_timing)-1
        y0(3) = y0(3) + 2.5;
        [t, y] = ode23s(@Model.tirzepatidePK, dose_timing(i):1:dose_timing(i+1), y0, [], p);
        y0 = y(end, :);
        time = [time; t];
        solution = [solution; y];
    end
end