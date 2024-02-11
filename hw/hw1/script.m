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
% q2e

%% Q2f
% q2f

%% Q2g
tmax = 192;
step = 1/60;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      SIMULATION 1      %%%%
D0 = 96;
y0 = [D0; 0; 0; 0; 0; 0; P0];
freq = 24;
sim = Model(p, y0);

t1 =  zeros(freq / step + 1, tmax/freq);
y1 = zeros(freq / step + 1, length(y0), tmax/freq);
b1 = zeros(freq / step + 1, tmax/freq);

% [t, y] = ode45(@heparinODE, 0:1/60:24, y0, options, p);
% for i = 1:tmax/24
%     options = odeset( ...
%                 'MaxStep', 5e-2, ...
%                 'AbsTol', 1e-5, ...
%                 'RelTol', 1e-5, ...
%                 'InitialStep', 1e-2 ...
%             );
%     [t1(:, i), y1(:, :, i), b1(:, i)] = ode45(@heparinODE, (i-1)*freq:step:i*freq, y0, options, p);
%     y0 = y1(end, :, i);
%     y0(1) = y0(1) + D0;
% end
for i = 1:tmax/24
    sim = Model(p, y0);
    [t1(:, i), y1(:, :, i), b1(:, i)] = sim.get_solution((i-1)*freq:step:i*freq, true);
    % sim.ics = y1(end, :, i) + D0;
    y0 = y1(end, :, i);
    y0(1) = y0(1) + D0;
end
t1 = reshape(t1, [], 1); % vertcat each col to 1d array
% y1 = y1(1:end-1, :, :);
% b1 = b1(1:end-1, :);
y1 = reshape(y1, [], size(y1, 2)); % vertcat each 3d slice into 2d array
b1 = reshape(b1, [], 1); % vertcat each col into vector
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      SIMULATION 2      %%%%
D0 = 32;
y0 = [D0; 0; 0; 0; 0; 0; P0];
freq = 8;
sim = Model(p, y0);

t2 = zeros(freq / step + 1, tmax/freq);
y2 = zeros(freq / step + 1, length(y0), tmax/freq);
b2 = zeros(freq / step + 1, tmax/freq);
for i=1:tmax/freq
    [t2(:, i), y2(:, :, i), b2(:, i)] = sim.get_solution((i-1)*freq:step:i*freq, true);
    % sim.ics = y2(end, :, i);
    y0 = y2(end, :, i);
    y0(1) = y0(1) + D0;
    sim = Model(p, y0);
end
t2 = reshape(t2, [], 1); % vertcat each col to 1d array
% y2 = y2(1:end-1, :, :);
% b2 = b2(1:end-1, :);
y2 = reshape(y2, [], size(y2, 2)); % vertcat each 3d slice into 2d array
b2 = reshape(b2, [], 1); % vertcat each col into vector

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      SIMULATION 3      %%%%
D0 = 12;
y0 = [D0; 0; 0; 0; 0; 0; P0];
freq = 3;
sim = Model(p, y0);

t3 = zeros(freq / step + 1, tmax/freq);
y3 = zeros(freq / step + 1, length(y0), tmax/freq);
b3 = zeros(freq / step + 1, tmax/freq);
for i=1:tmax/freq
        [t3(:, i), y3(:, :, i), b3(:, i)] = sim.get_solution((i-1)*freq:step:i*freq, true);
        % sim.ics = y3(end, :, i);
        y0 = y3(end, :, i);
        y0(1) = y0(1) + D0;
        sim = Model(p, y0);
end

t3 = reshape(t3, [], 1); %M vertcat each col to 1d array
% y3 = y3(1:end-1, :, :);
% b3 = b3(1:end-1, :);
y3 = reshape(y3, [], size(y3, 2)); % vertcat each 3d slice into 2d array
b3 = reshape(b3, [], 1); % vertcat each col into vector

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%       Plotting          %%%

fig = tiledlayout(3, 2);
series_name = ["96 per 24", "32 per 8", "12 per 3"];
xlabel(fig, "time (hrs)");
ylabel(fig, "Concentration [nmol]")

nexttile;
plot(...       
    t1, y1(:, 1), ...
    t2, y2(:, 1), ...
    t3, y3(:, 1), ...
    'LineWidth', 3 ...
);
legend(series_name);
title("Free Drug Concentration in Blood");

nexttile;
plot(...
    t1, sum(y1(:, 1:2), 2), ...
    t2, sum(y2(:, 1:2), 2), ...
    t3, sum(y3(:, 1:2), 2), ...
    'LineWidth', 3 ...
);
legend(series_name);
title("Concentration of Total Drug in Blood");

nexttile;
plot(...
    t1, y1(:, 3), ...
    t2, y2(:, 3), ...
    t3, y3(:, 3), ...
    'LineWidth', 3 ...
);
legend(series_name);
title("Concentration of Free Drug in Large Tumor");

nexttile
plot(...
    t1, y1(:, 4), ...
    t2, y2(:, 4), ...
    t3, y3(:, 4), ...
    'LineWidth', 3 ...
);
legend(series_name);
title("Concentration of Free Drug in Small Tumor");

nexttile;
plot(...ax5, ...
    t1, y1(:, 6), ...
    t2, y2(:, 6), ...
    t3, y3(:, 6), ...
    'LineWidth', 3 ...
);
legend(series_name);
title("Concentration of Free Drug in Body");

nexttile
plot(...
    t1, b1, ...
    t2, b2, ...
    t3, b3, ...
    'LineWidth', 3 ...
);
legend(series_name);
title("Mass Balance");