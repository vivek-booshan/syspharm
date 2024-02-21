abs_halflife = 7/60; %from question
cl_halflife = 5; %from prompt
ka = log(2) / abs_halflife;
kcl = log(2) / cl_halflife;
 
Vd = 0.6; % L / kg
weights = [111, 128, 143, 197, 222]*0.45; %convert to kg
V =  Vd * weights;

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

%% 1a

% create subject table from previously calculated parameters
table_1a = zeros(4, 5);
table_1a(1, :) = ka;
table_1a(2, :) = kcl;
table_1a(3, :) = V;
table_1a(4, :) = Vd;

disp('q1a');
disp(table_1a);

%% 1b 1c

table = zeros(5, 5, 2);
% solve for 1b and 1c
for i = 1:2
    % determine which parameters to restriction
    % [q, kcl, V, ka]
    restrict = [1, 0, 0, mod(i, 2)];
    %iterate through each subject
    for subject = 1:numel(V) 
        initial_guess_params = [0, kcl, V(subject), ka]; % initial guess
        caff_err = @(params) caffeineError( ... % anon error function
            t_real, ...
            y_real(:, subject), ...
            y0, ...
            params, ...
            restrict, ...
            initial_guess_params ...
        );
        options = optimoptions( ... % use LM algo and hide displays
            'lsqnonlin', ...
            'Algorithm', 'levenberg-marquardt', ...
            'Display','none' ...
        );
        % tic
        optim_params = lsqnonlin( ... % solve lsqnonlin
            caff_err, ...
            initial_guess_params, ...
            [], [], ...
            options ...
        );
        % toc
        
        % add Vd (L/kg) 
        table(:, subject, i) = [optim_params, optim_params(3) / weights(subject)];
    end
end

% assign respective tables and display
table_1b = table(:, :, 1);
table_1c = table(:, :, 2);

disp('q1b');
disp(table_1b);

disp('q1c');
disp(table_1c);