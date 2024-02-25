load_dose = 20;
maintenance_dose = 5;
Vd = 0.85;
weights = linspace(3, 8, 5);
clearances = linspace(50, 150, 5);
ka = log(2) / (7/60);
y0 = [0, 0, load_dose];
[ww, cc] = meshgrid(weights, clearances); %skip nested for loop

global_sens1 = zeros(5, 5);
global_sens2 = zeros(5, 5);
global_sens3 = zeros(5, 5);
for i = 1:numel(ww)
    p = [0, cc(i), ww(i)*Vd, ka];
    global_sens1(i) = global_sens(1, y0, p);
    global_sens2(i) = global_sens(2, y0, p);
    global_sens3(i) = global_sens(3, y0, p);
end
disp('1')
disp(global_sens1);
disp('2')
disp(global_sens2);
disp('3')
disp(global_sens3);
%%
%%%% FUNCTIONS %%%%
function auc = auc_first24(y0, parameters)
    tspan = 0:1/10:1;
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
            i:1/10:(i+1), ...
            y0 ...
        );
        auc = auc + trapz(t, y(:, 1));
        y0 = y(end, :); 
        y0(end) = y0(end) + 5;
    end
end

function ctrough = ctrough(y0, parameters)
    [~, y] = ode45( ...
        @(t, y) CaffeineODE(t, y, parameters), ...
        0:1/10:1, ...
        y0 ...
    );
    for i = 1:6
        y0 = y(end, :);
        y0(end) = y0(end) + 5;
        [~, y] = ode45( ...
            @(t, y) CaffeineODE(t, y, parameters), ...
            i:1/10:(i+1), ...
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
