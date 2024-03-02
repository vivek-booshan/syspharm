load_dose = 20;
maintenance_dose = 5;
Vd = 0.85;
step = 21;
weights = 0.45 * linspace(3, 8, step);
V = Vd * weights;
clearances = log(2) ./ linspace(50, 150, step);
ka = log(2) / (7/60);
y0 = [load_dose, 0, 0];
[vv, cc] = meshgrid(V, clearances); %skip nested for loop

global_sens1 = zeros(step);
global_sens2 = zeros(step);
global_sens3 = zeros(step);

for i = 1:numel(vv)
    p = [0, cc(i), vv(i), 0];
    global_sens1(i) = global_sens(1, y0, p);
    global_sens2(i) = global_sens(2, y0, p);
    global_sens3(i) = global_sens(3, y0, p);
end

FILE_NAME = 'q3a'; writematrix(global_sens1, FILE_NAME);
FILE_NAME = 'q3b'; writematrix(global_sens2, FILE_NAME);
FILE_NAME = 'q3c'; writematrix(global_sens3, FILE_NAME);
%%
%%%% FUNCTIONS %%%%
function auc = auc_first24(y0, parameters)
    tspan = 0:1/10:24;
    [t, y] = ode45( ...
        @(t, y) CaffeineODE(t, y, parameters), ...
        tspan, ...
        y0...
    );
    auc = trapz(t, y(:, 1));
end

function auc = auc_week(y0, parameters)
    auc = 0;
    for i=0:6 % woah, zero indexing and inclusive end??
        [t, y] = ode45( ...
            @(t, y) CaffeineODE(t, y, parameters), ...
            24*i:1/24:24*(i+1), ...
            y0 ...
        );
        auc = auc + trapz(t, y(:, 1));
        y0 = y(end, :); 
        y0(1) = y0(1) + 5;
    end
end

function ctrough = ctrough(y0, parameters)
    [~, y] = ode45( ...
        @(t, y) CaffeineODE(t, y, parameters), ...
        0:1/10:24, ...
        y0 ...
    );
    for i = 1:6
        y0 = y(end, :);
        y0(1) = y0(1) + 5;
        [~, y] = ode45( ...
            @(t, y) CaffeineODE(t, y, parameters), ...
            24*i:1/10:24*(i+1), ...
            y0 ...
        );
    end
    ctrough = y(end, 1);
end

function sensitivity = global_sens(mode, y0, parameters)
    switch mode
        case 1
            sensitivity = auc_first24(y0, parameters);
        case 2
            sensitivity = auc_week(y0, parameters);
        case 3
            sensitivity = ctrough(y0, parameters);
    end
end
