%% Mass Balance PK
p = pkParameters();
y0 = zeros(1, 4);
dose = [2.5, 2.5, 2.5, 2.5, 5, 5, 5, 5, 7.5, 7.5, 7.5, 7.5, 10, 10, 10, 10];
options = odeset('MaxStep',5e-2, 'AbsTol', 1e-5,'RelTol', 1e-5,'InitialStep', 1e-2);

[t, y, b] = Model.simulatePK(p, y0, dose, ...
    "solver", @ode45, "resolution", 60, "options", options) % optional args
plot(t/168, b); % divide by 168 to convert from hours to weeks

%% WEIGHT PD
p = pkParameters();
y0 = zeros(1, 6);
y0(5:6) = [70 30]; % assign FFM and FM
dose = ones(1, 4)*2.5; % can be whatever
[t, y] = Model.simulateWeightLoss(p, y0, dose);
