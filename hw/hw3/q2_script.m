%%% REQUIRES q1_script to be run

%% AUC for 14 hrs
subjects = 5;
delta = 0.1;
multiplier = 1 + delta;
AUC14HRS = zeros(5, 5);
for subject = 1:subjects
    p = table_1f(:, subject);
    AUC14HRS(1, subject) = local_sens(1, 175*multiplier, 310, p);
    AUC14HRS(2, subject) = local_sens(1, 175, 310*multiplier, p);
    p_kcl = p; p_kcl(2) = p(2)*multiplier; 
    AUC14HRS(3, subject) = local_sens(1, 175, 310, p, p_kcl);
    p_vd = p; p_vd(3) = p(3)*multiplier;
    AUC14HRS(4, subject) = local_sens(1, 175, 310, p, p_vd);
    p_ka = p; p_ka(4) = p(4)*multiplier;
    AUC14HRS(5, subject) = local_sens(1, 175, 310, p, p_ka);
end
disp(AUC14HRS);
% FILE_NAME = 'q2a'; writematrix(AUC14HRS, FILE_NAME);

AUC1HRS = zeros(5, 5);
for subject = 1:subjects
    p = table_1f(:, subject);
    AUC1HRS(1, subject) = local_sens(2, 175*multiplier, 310, p);
    AUC1HRS(2, subject) = local_sens(2, 175, 310*multiplier, p);
    p_kcl = p; p_kcl(2) = p(2)*multiplier; 
    AUC1HRS(3, subject) = local_sens(2, 175, 310, p, p_kcl);
    p_vd = p; p_vd(3) = p(3)*multiplier;
    AUC1HRS(4, subject) = local_sens(2, 175, 310, p, p_vd);
    p_ka = p; p_ka(4) = p(4)*multiplier;
    AUC1HRS(5, subject) = local_sens(2, 175, 310, p, p_ka);
end
disp(AUC1HRS);
% FILE_NAME = 'q2b'; writematrix(AUC1HRS, FILE_NAME);

COST = zeros(5, 5);
for subject = 1:subjects
    y0 = [0, 0, 175];
    p = table_1f(:, subjects);
    y_subject = y_real(:, subject); 
    COST(1, subject) = local_sens(3, 175*multiplier, 310, p, t_real=t_real, y_real=y_subject);
    COST(2, subject) = local_sens(3, 175, 310*multiplier, p, t_real=t_real, y_real=y_subject);
    p_kcl = p; p_kcl(2) = p(2)*multiplier; 
    COST(3, subject) = local_sens(3, 175, 310, p, p_kcl, t_real=t_real, y_real=y_subject);
    p_vd = p; p_vd(3) = p(3)*multiplier;
    COST(4, subject) = local_sens(3, 175, 310, p, p_vd, t_real=t_real, y_real=y_subject);
    p_ka = p; p_ka(4) = p(4)*multiplier;
    COST(5, subject) = local_sens(3, 175, 310, p, p_ka, t_real=t_real, y_real=y_subject);
end
disp(COST);
% FILE_NAME = 'q2c'; writematrix(COST, FILE_NAME);

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