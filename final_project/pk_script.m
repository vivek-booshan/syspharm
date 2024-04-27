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
p = Model.pkParameters();
%% pk interactive data
[A, B, C, D, E] = ndgrid(Vc, Vp, ka, CL, Q);
max_ = numel(A);

gcp();
parfor i = 1:max_
    a = A(i); b = B(i); c = C(i); d = D(i); e = E(i);
    p = Model.pkParameters(a, b, c, d, e);
    [t, y] = Model.simulatePK(p, y0, dose);
    writematrix([t/168, y], sprintf('output_%d_%d_%d_%d_%d.csv', a, b, c, d, e));
end 

%% Single Dose %%
dose = [2.5, 5, 7.5, 10];
p = Model.pkParameters();
t = tiledlayout(3, 2);
title(t, "Compartment Concentration of Single Dose")
for i = 1:length(dose)
    [t, y, b] = Model.simulatePK(p, y0, [dose(i), 0, 0, 0, 0], "solver", @ode45, "resolution", 60);
    nexttile(1); hold on;
    plot(t/168, y(:, 1));
    nexttile(2); hold on;
    plot(t/168, y(:, 2));
    nexttile(3); hold on;
    plot(t/168, y(:, 3));
    nexttile(4); hold on;
    plot(t/168, y(:, 4));
    nexttile(5, [1 2]); hold on;
    plot(t/168, b);
end
hold off;
compartment = ["Central", "Peripheral", "Dose", "Cumulative"];
for i = 1:4
    nexttile(i);
    title(sprintf("%s Compartment", compartment(i)));
    xlabel('Time (weeks)');
    ylabel('Concentration (mg/L)');
    legend('2.5 mg', '5 mg', '7.5 mg', '10 mg');
end
nexttile(5)
title("Mass Balance");
ylabel('Mass (mg)');
xlabel("Time (weeks");
legend('2.5 mg', '5 mg', '7.5 mg', '10 mg');

%% individual CL effect on simulation %%
p = Model.pkParameters();
T2DM = Model(1000, 1);
noT2DM = Model(1000, 0);
T2DM.generateBW();
noT2DM.generateBW();
iCL_T2DM = p.CL * (T2DM.BW / 70).^0.8;
iCL_noT2DM = p.CL * (T2DM.BW / 70 .^ 0.8);

hold on;
for i = 1:10
    p = Model.pkParameters(2.48, 3.91, 0.0363, iCL_T2DM(i), 0.125, 0.8);
    [t, y, ~] = Model.simulatePK(p, y0, dose, "solver", @ode45, "resolution", 30);
    plot(t, y(:, 1));
end
hold off;
%% relative dose effect of dose skipping
clf
dose = ones(1, 16)*2.5;
p = Model.pkParameters(Vc(1), Vp(1), ka(1), CL(1), Q(1));
[~, y] = Model.simulatePK(p, y0, dose);
steady_state_y0 = y(end, :);
steady_dose = dose(1:4);
steady_min = min(y(:, 1));
steady_max = max(y(:, 1));
t = tiledlayout(4, 2);
title(t, 'Effect of Dose Skipping on Central Compartment');
xlabel(t, "time (weeks)");
ylabel(t, "Relative Concentration");

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
    yticks(0:0.2:1.2);
    xticks([])
end

nexttile(7); xticks(1:4);
nexttile(8); xticks(1:4);

%% steady state
clf;
dose = ones(1, 20);
mag = [2.5, 5, 7.5, 10, 15];
y0 = zeros(1, 4);
hold on;
for i = 1:length(mag)
    [t, y] = Model.simulatePK(p, y0, dose*mag(i), "resolution", 15);
    plot(t/168, y(:, 1));
end
patch([7, 7, t(end)/168, t(end)/168, 7], [0, 3, 3, 0, 0], 'r', 'FaceAlpha', 0.2);

hold off;
title("Central Compartment Concentration for 20 weeks");
xlabel("time (weeks)"); 
ylabel("Concentration (mg/L)");
legend(string(mag) + " mg")

%% weight loss
clf;
dose = ones(1, 52);
mag = [2.5, 5, 7.5, 10, 15];
hold on;

dose = [dose, 10*ones(52-length(dose))];
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