tmax = 192;
step = 1/60;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      SIMULATION 1      %%%%
D0 = 96;
y0 = [D0; 0; 0; 0; 0; 0; P0];
freq = 24;

sim = Model(p, y0);
[t1, y1, b1] = sim.repeated_bolus(D0, tmax, freq, step, true);

% t1 =  zeros(freq / step + 1, tmax/freq);
% y1 = zeros(freq / step + 1, length(y0), tmax/freq);
% b1 = zeros(freq / step + 1, tmax/freq);
% for i = 1:tmax/24
%     sim = Model(p, y0);
%     [t, y, b] = sim.get_solution((i-1)*freq:step:i*freq, true);
%     % [t1(:, i), y1(:, :, i), b1(:, i)] = sim.get_solution((i-1)*freq:step:i*freq, true);
%     % sim.ics = y1(end, :, i) + D0;
%     t1 = [t1; t];
%     y1 = [y1; y];
%     b1 = [b1; b];
%     y0 = y(end, :);
%     y0(1) = y0(1) + D0;
% end
% t1 = reshape(t1, [], 1); % vertcat each col to 1d array
% % y1 = y1(1:end-1, :, :);
% % b1 = b1(1:end-1, :);
% y1 = reshape(y1, [], size(y1, 2)); % vertcat each 3d slice into 2d array
% b1 = reshape(b1, [], 1); % vertcat each col into vector

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      SIMULATION 2      %%%%
D0 = 32;
y0 = [D0; 0; 0; 0; 0; 0; P0];
freq = 8;

sim = Model(p, y0);
[t2, y2, b2] = sim.repeated_bolus(D0, tmax, freq, step, true);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      SIMULATION 3      %%%%
D0 = 12;
y0 = [D0; 0; 0; 0; 0; 0; P0];
freq = 3;

sim = Model(p, y0);
[t3, y3, b3] = sim.repeated_bolus(D0, tmax, freq, step, true);
series_name = ["96 nmol every 24 hrs", "32 nmol every 8 hrs", "12 nmol every 3 hrs"];
plot_drug(t1, y1, b1, t2, y2, b2, t3, y3, b3, series_name);