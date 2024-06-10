%% pk interactive data
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

if not(isfolder("data"))
    mkdir("data")
end

gcp();
parfor i = 1:max_
    a = A(i); b = B(i); c = C(i); d = D(i); e = E(i);
    p = Model.pkParameters(a, b, c, d, e);
    [t, y] = Model.simulatePK(p, y0, dose);
    writematrix([t/168, y], sprintf('data/output_%d_%d_%d_%d_%d.csv', a, b, c, d, e));
end 

%% Single Dose %%
dose = [2.5, 5, 7.5, 10];
p = Model.pkParameters();
y0 = zeros(1, 4);
% t = tiledlayout(3, 2);


[~, y1, b1] = Model.simulatePK(p, y0, [2.5, 0, 0, 0]);
[~, y2, b2] = Model.simulatePK(p, y0, [5.0, 0, 0, 0]);
[~, y3, b3] = Model.simulatePK(p, y0, [7.5, 0, 0, 0]);
[t, y4, b4] = Model.simulatePK(p, y0, [10., 0, 0, 0]);
len = numel(t);

writematrix([ ...
    t/168, y1, b1, ones(1, len)'; ...
    t/168, y2, b2, 2*ones(1, len)'; ...
    t/168, y3, b3, 3*ones(1, len)'; ...
    t/168, y4, b4, 4*ones(1, len)'; ...
    ], "single_dose_data.csv");

%% relative dose effect of dose skipping
clf;
% parameter = [LB 95CI, median, UB 95CI]
ka = [0.0287, 0.0363, 0.0448];
CL = [0.0311, 0.0326, 0.0341];
Q = [0.101, 0.125, 0.144];
Vc = [2.07, 2.48, 2.98];
Vp = [3.48, 3.91, 4.17];

% ICS
y0 = zeros(1, 4);
% weekly dosing regime
p = Model.pkParameters();
dose = ones(1, 16)*2.5;

[~, y] = Model.simulatePK(p, y0, dose);
steady_state_y0 = y(end, :);
steady_dose = dose(1:4);
steady_min = min(y(:, 1));
steady_max = max(y(:, 1));
t = tiledlayout(4, 2, "Padding", "compact", "TileSpacing", "compact");
fontsize(t, "Scale", 1.2)
title(t, 'Effect of Dose Skipping on Central Compartment');
xlabel(t, "time (weeks)", "FontSize", 16);
ylabel(t, "Relative Concentration", "FontSize", 16);

nexttile; hold on;
[t, y] = Model.simulatePK(p, steady_state_y0, steady_dose);

patch([0, 0, length(y), length(y), 0], [0.53, 1, 1, 0.53, 0.53], 'r', 'FaceAlpha', 0.2);
plot(t/168, y(:, 1)/steady_max);
title("Standard Dosing")
axis([0 4 0 1.3]);
xline(1:3, '--');
yticks(0:0.2:1.2);
xticks([]);

nexttile;  hold on;
[t, y] = Model.simulatePK(p, steady_state_y0, [2.5, 0, 2.5, 2.5]);
patch([0, 0, length(y), length(y), 0], [0.53, 1, 1, 0.53, 0.53], 'r', 'FaceAlpha', 0.2);
plot(t/168, y(:, 1)/steady_max);
title("Skipped Dose");
axis([0, 4, 0, 1.3]);
xline(1:3, '--');
yticks(0:0.2:1.2);
xticks([]);

for i = 1:6
    nexttile; hold on;
    dose_timing = (0:4)*168; dose_timing(2) = 168 + 24*i;
    [t, y] = skipDose(dose_timing, steady_state_y0, p);
    patch([0, 0, length(y), length(y), 0], [0.53, 1, 1, 0.53, 0.53], 'r', 'FaceAlpha', 0.2);
    plot(t/168, y(:, 1)/steady_max);
    title(sprintf("%d days late", i));
    axis([0, 4, 0, 1.3]);
    xline(1:3, '--');
    yticks(0:0.2:1.2)
    % if mod(i, 2) == 1
    %     yticks(0:0.2:1.2);
    % else
    %     yticks([]);
    % end
    xticks([])
end

nexttile(7); xticks(1:4);
nexttile(8); xticks(1:4);

%% steady state
clf;
dose = ones(1, 20);
mag = [2.5, 5, 7.5, 10, 15];
y0 = zeros(1, 4);
p = Model.pkParameters();
hold on;
for i = 1:length(mag)
    [t, y] = Model.simulatePK(p, y0, dose*mag(i), "resolution", 15);
    plot(t/168, y(:, 1));
end
patch([7, 7, t(end)/168, t(end)/168, 7], [0, 3, 3, 0, 0], 'r', 'FaceAlpha', 0.025);

hold off;
title("Central Compartment Concentration for 20 weeks");
xlabel("time (weeks)", "FontSize", 16); 
ylabel("Concentration (mg/L)", "FontSize", 16);
legend(string(mag) + " mg")

%% AUC
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

parfor i = 1:max_
    a = A(i); b = B(i); c = C(i); d = D(i); e = E(i);
    data = importdata("data/" + sprintf('output_%s_%s_%s_%s_%s.csv', a, b, c, d, e))
    central = data(:, 2);  % data(:, 1) is time
    peripheral = data(:, 3);
    central_AUC(i) = trapz(central);
    peripheral_AUC(i) = trapz(peripheral);
end

f = boxchart([ ...
    central_AUC' ./ 1e5, ... %/ reference_central_AUC, ...
    peripheral_AUC' ./ 1e5 ... %/ reference_peripheral_AUC, ...
    ]);
title("Distribution of Compartment AUCs for Titrated Dosing Schedule", "FontSize", 16)
xticklabels(["Central", "Peripheral"])
ylabel("AUC (in ten thousands)", "FontSize", 16)

%% functions
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