%% 1a

abs_halflife = 7/60; %from question
cl_halflife = 5; %from prompt

ka = log(2) / abs_halflife;
kcl = log(2) / cl_halflife;

Vd = 0.6; % L / kg
weights = [111, 128, 143, 197, 222];
V =  Vd * weights;

table_1a = zeros(4, 5);
table_1a(1, :) = ka;
table_1a(2, :) = kcl;
table_1a(3, :) = V;
table_1a(4, :) = Vd;
disp(table_1a);

%% 1b

abs_halflife = 7/60;
Vd = 5;

t_real =[0.25, 0.5, 0.75, 2, 5, 8]; % measurements in hours since 11am
y0 = [0, 0, 310]; % initial coffee @ 11am
y_real = [
    8.8, 7.7, 8.0, 5.2, 6.0; %11:15
    9.8, 8.6, 9.0, 6.0, 6.5; %11:30
    9.0, 7.7, 8.5, 5.5, 6.1; %11:45
    6.4, 5.0, 7.2, 3.9, 4.5; %02;00
    4.6, 3.3, 6.0, 2.7, 3.2; %04;00
    3.0, 1.7, 4.5, 1.7, 2.0; %07;00
]; % mg/L

% cost_function = @(params) sum((estimated_caffeine_levels(t_real, y0, params) - y_real(:, 1)));
% caffeine_model = @(params) Caffeine_eqns(t, y0, params);


% function estimated_levels = estimated_caffeine_levels(t_real, y0, params)
%     [~, y_est] = ode45(@(t, y) Caffeine_eqns(t, y, params), t_real, y0);
%     estimated_levels = y_est(:, 1);
% end
for i = 1:numel(V) 
    initial_guess_params = [0, kcl, V(i), ka];
    caff_err = @(params) caffeine_error(t_real, y_real, y0, params);
    options = optimoptions('lsqnonlin', 'Algorithm', 'levenberg-marquardt');
    % tic
    optim_params = lsqnonlin(caff_err, initial_guess_params, [], [], options);
    % toc
    fprintf('Patient %d', i);
    disp(optim_params);
end
function error = caffeine_error(t_measured, y_measured, y0, p)
    
    error = 0;
    max_subjects = size(y_measured, 5);

    for subject = 1:max_subjects       
        [t, y] = ode45(@(t,y) Caffeine_eqns(t, y, p), t_measured, y0);
        % y_interp = interp1(t, y(:, 1), t_measured);
        % error = error + sum((y_interp(:) - y_measured(:, subject)).^2);
        error = error + sum((y(:, 1) - y_measured(:, subject)).^2);
    end
end