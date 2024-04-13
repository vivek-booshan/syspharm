%% AUC for 14 hrs
%%% REQUIRES q1_script to be run

subjects = 5;
delta = 0.1;
multiplier = 1 + delta;
local_sens_table = zeros(subjects, subjects, 3);
y0 = [0, 0, 175]; 
y_subject=0;

for i = 1:3
    for subject = 1:subjects
        p = table_1f(:, subject);
        if i == 3
            y_subject = y_real(:, subject);
        end
        % modify D1
        local_sens_table(1, subject, i) = local_sens( ...
            i, ...
            175*multiplier, 310, p, ...
            t_real=t_real, y_real=y_subject ...
        );
        % modify D2
        local_sens_table(2, subject, i) = local_sens( ...
            i, ...
            175, 310*multiplier, p, ...
            t_real=t_real, y_real=y_subject ...
        );
        % modify kcl
        p_kcl = p; p_kcl(2) = p(2)*multiplier; 
        local_sens_table(3, subject, i) = local_sens( ...
            i, ...
            175, 310, p, p_kcl, ...
            t_real=t_real, y_real=y_subject ...
        );
        % modify Volume
        p_vd = p; p_vd(3) = p(3)*multiplier;
        local_sens_table(4, subject, i) = local_sens( ...
            i, ...
            175, 310, p, p_vd, ...
            t_real=t_real, y_real=y_subject ...
        );
        % modify ka
        p_ka = p; p_ka(4) = p(4)*multiplier;
        local_sens_table(5, subject, i) = local_sens( ...
            i, ...
            175, 310, p, p_ka, ...
            t_real=t_real, y_real=y_subject ...
        );
    end
end

FILE_NAME = 'q2a'; writematrix(local_sens_table(:, :, 1), FILE_NAME);
FILE_NAME = 'q2b'; writematrix(local_sens_table(:, :, 2), FILE_NAME);
FILE_NAME = 'q2c'; writematrix(local_sens_table(:, :, 3), FILE_NAME);

%%%%%%%%%% FUNCTIONS %%%%%%%%%%%%
function auc = auc14hrs(D1, D2, p)
    tspan1 = 0:1/10:1;
    tspan2 = 1:1/10:14;
    y0 = [0, 0, D1];
    [t1, y1] = ode45(@(t, y) CaffeineODE(t, y, p), tspan1, y0);
    y0 = y1(end, :);
    y0(end) = y0(end) + D2;
    [t2, y2] = ode45(@(t, y) CaffeineODE(t, y, p), tspan2, y0);
    auc = trapz([t1; t2], [y1(:, 1); y2(:, 1)]);
end

function auc = auc1hrs(D1, D2, p)
    tspan1 = 0:1/10:1;
    tspan2 = 1:1/10:2;
    y0 = [0, 0, D1];
    [t1, y1] = ode45(@(t, y) CaffeineODE(t, y, p), tspan1, y0);
    y0 = y1(end, :);
    y0(end) = y0(end) + D2;
    [t2, y2] = ode45(@(t, y) CaffeineODE(t, y, p), tspan2, y0);
    auc = trapz([t1; t2], [y1(:, 1); y2(:, 1)]);
end

function error = costfunc(t_measured, y_measured, D1, D2, p)
    arguments
        t_measured (1, :) double
        y_measured (1, :) double
        D1 double
        D2 double
        p (1, :) double
    end
    y0 = [0, 0, D1];
    [~, y] = ode45(@(t, y) CaffeineODE(t, y, p), 0:1/10:1, y0);
    y0 = y(end, :);
    y0(end) = y0(end) + D2;
    [t, y] = ode45(@(t, y) CaffeineODE(t, y, p), t_measured, y0);
    y_interp = interp1(t, y(:, 1), t_measured); 
    error = sum((y_interp(:) - y_measured(:)).^2);
end

function sensitivity = local_sens(mode, D1, D2, p, pmod, options)
    arguments
        mode double
        D1 double
        D2 double
        p (1, :) double
        pmod (1, :) double = p
        options.t_real = 0
        options.y_real = 0
    end
    switch mode
        case 1
            out1 = auc14hrs(175, 310, p);
            out2 = auc14hrs(D1, D2, pmod);
        case 2
            out1 = auc1hrs(175, 310, p);
            out2 = auc1hrs(D1, D2, pmod);

        case 3
            out1 = costfunc(options.t_real, options.y_real, 175, 310, p);
            out2 = costfunc(options.t_real, options.y_real, D1, D2, pmod);
    end

    numer = (out2 - out1) / out1;
    denom = 0.1;
    sensitivity = numer / denom;
end