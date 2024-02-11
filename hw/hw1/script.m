clear; 
%%
%%% Required Parameters %%%%
p.kon  = 0.25 / 50;
p.koff = 0.25;

p.kt1  = 1.0;
p.kt1r = 1.0;

p.kt2  = 1.0;
p.kt2r = 1.0;

p.kb   = 0.1;
p.kbr  = 0.1;

p.kc   = 0.3 / 2.75;

p.vbp  = 2.75;
p.vt1  = 0.25 * 0.25;
p.vt2  = 0.025 * 0.25;
p.vb   = 45 * 0.15;

P0 = 100;

%% Q2e
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      SIMULATION 1      %%%%

D0 = 0.96;
y0 = [D0, 0, 0, 0, 0, 0, P0]';
step = 1/60;
tmax = 96;

sim1 = Model(p, y0);
[t, y1, b1] = sim1.get_solution(0:step:tmax, 0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      SIMULATION 2      %%%%

D0 = 9.6;
y0 = [D0; 0; 0; 0; 0; 0; P0];
step = 1/60;
tmax = 96;

sim2 = Model(p, y0);
[t, y2, b2] = sim2.get_solution(0:step:tmax, 0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      SIMULATION 3      %%%%

D0 = 96;
y0 = [D0; 0; 0; 0; 0; 0; P0];
step = 1/60;
tmax=96;

sim3 = Model(p, y0);
[t, y3, b3] = sim3.get_solution(0:step:tmax, 0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%       Plotting          %%%

fig = tiledlayout(3, 2);
series_name = ["0.96 nmol", "9.6 nmol", "96 nmol"];
xlabel(fig, "time (hrs)");
ylabel(fig, "Concentration [nmol]")

nexttile;
plot(...       
    t, y1(:, 1), ...
    t, y2(:, 1), ...
    t, y3(:, 1), ...
    'LineWidth', 3 ...
);
legend(series_name);
title("Free Drug Concentration in Blood");

nexttile;
plot(...
    t, sum(y1(:, 1:2), 2), ...
    t, sum(y2(:, 1:2), 2), ...
    t, sum(y3(:, 1:2), 2), ...
    'LineWidth', 3 ...
);
legend(series_name);
title("Concentration of Total Drug in Blood");

nexttile;
plot(...
    t, y1(:, 3), ...
    t, y2(:, 3), ...
    t, y3(:, 3), ...
    'LineWidth', 3 ...
);
legend(series_name);
title("Concentration of Free Drug in Large Tumor");

nexttile
plot(...
    t, y1(:, 4), ...
    t, y2(:, 4), ...
    t, y3(:, 4), ...
    'LineWidth', 3 ...
);
legend(series_name);
title("Concentration of Free Drug in Small Tumor");

nexttile;
plot(...ax5, ...
    t, y1(:, 6), ...
    t, y2(:, 6), ...
    t, y3(:, 6), ...
    'LineWidth', 3 ...
);
legend(series_name);
title("Concentration of Free Drug in Body");

nexttile
plot(...
    t, b1, ...
    t, b2, ...
    t, b3, ...
    'LineWidth', 3 ...
);
legend(series_name);
title("Mass Balance");


%% Q2f

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      SIMULATION 1      %%%%

D0 = 0.96;
y0 = [D0, 0, 0, 0, 0, 0, P0]';
step = 1/60;
tmax = 96;

sim1 = Model(p, y0);
[t, y1, b1] = sim1.get_solution(0:step:tmax, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      SIMULATION 2      %%%%

D0 = 9.6;
y0 = [D0; 0; 0; 0; 0; 0; P0];
step = 1/60;
tmax = 96;

sim2 = Model(p, y0);
[t, y2, b2] = sim2.get_solution(0:step:tmax, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      SIMULATION 3      %%%%

D0 = 96;
y0 = [D0; 0; 0; 0; 0; 0; P0];
step = 1/60;
tmax=96;

sim3 = Model(p, y0);
[t, y3, b3] = sim3.get_solution(0:step:tmax, 1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%       Plotting          %%%

fig = tiledlayout(3, 2);
series_name = ["0.96 nmol", "9.6 nmol", "96 nmol"];
xlabel(fig, "time (hrs)");
ylabel(fig, "Concentration [nmol]")

nexttile;
plot(...       
    t, y1(:, 1), ...
    t, y2(:, 1), ...
    t, y3(:, 1), ...
    'LineWidth', 3 ...
);
legend(series_name);
title("Free Drug Concentration in Blood");

nexttile;
plot(...
    t, sum(y1(:, 1:2), 2), ...
    t, sum(y2(:, 1:2), 2), ...
    t, sum(y3(:, 1:2), 2), ...
    'LineWidth', 3 ...
);
legend(series_name);
title("Concentration of Total Drug in Blood");

nexttile;
plot(...
    t, y1(:, 3), ...
    t, y2(:, 3), ...
    t, y3(:, 3), ...
    'LineWidth', 3 ...
);
legend(series_name);
title("Concentration of Free Drug in Large Tumor");

nexttile
plot(...
    t, y1(:, 4), ...
    t, y2(:, 4), ...
    t, y3(:, 4), ...
    'LineWidth', 3 ...
);
legend(series_name);
title("Concentration of Free Drug in Small Tumor");

nexttile;
plot(...ax5, ...
    t, y1(:, 6), ...
    t, y2(:, 6), ...
    t, y3(:, 6), ...
    'LineWidth', 3 ...
);
legend(series_name);
title("Concentration of Free Drug in Body");

nexttile
plot(...
    t, b1, ...
    t, b2, ...
    t, b3, ...
    'LineWidth', 3 ...
);
legend(series_name);
title("Mass Balance");
