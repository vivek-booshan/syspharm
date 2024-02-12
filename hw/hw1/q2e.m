tmax = 96;
step = 1/60;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      SIMULATION 1      %%%%

D0 = 0.96;
y0 = [D0, 0, 0, 0, 0, 0, P0]';

sim1 = Model(p, y0);
[t1, y1, b1] = sim1.get_solution(0:step:tmax, 0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      SIMULATION 2      %%%%

D0 = 9.6;
y0 = [D0; 0; 0; 0; 0; 0; P0];

sim2 = Model(p, y0);
[t2, y2, b2] = sim2.get_solution(0:step:tmax, 0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%      SIMULATION 3      %%%%

D0 = 96;
y0 = [D0; 0; 0; 0; 0; 0; P0];

sim3 = Model(p, y0);
[t3, y3, b3] = sim3.get_solution(0:step:tmax, 0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%       Plotting          %%%

series_name = ["0.96 nmol", "9.6 nmol", "96 nmol"];
plot_drug(t1, y1, b1, t2, y2, b2, t3, y3, b3, series_name);