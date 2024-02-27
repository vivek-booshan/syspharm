abs_halflife = 7/60; %from question
cl_halflife = 5; %from prompt
ka = log(2) / abs_halflife;
kcl = log(2) / cl_halflife;

q=0;
Vd = 0.6; % L / kg
weights = [111, 128, 143, 197, 222]*0.45; %convert to kg
V =  Vd * weights;

t_real =[0.25, 0.5, 0.75, 2, 5, 8]; % measurements in hours since 11am
y0 = [0, 0, 310]; % initial coffee @ 11am
y_real = [
    12.2, 11.1, 10.7, 7.5, 8.0; %11:15
    13.5, 12.2, 12.0, 8.4, 9.2; %11:30
    13.5, 12.0, 12.2, 8.2, 9.0; %11:45
    11.2,  9.2, 11.0, 6.8, 7.5; %02;00
     7.0,  5.0,  8.5, 4.0, 4.7; %04;00
     4.5,  2.8,  6.5, 2.5, 3.0; %07;00
]; % mg/L

%% 1a

% create subject table from previously calculated parameters
table_1a = zeros(4, 5);

table_1a(1, :) = q;
table_1a(2, :) = kcl;
table_1a(3, :) = V;
table_1a(4, :) = ka;
table_1a(5, :) = Vd;

disp('q1a');
disp(table_1a);

%% 1b 1c 1e 1f

table = zeros(5, 5, 4);
% solve for 1b and 1c
for i = 1:4 
    % initialization of caffeineError arguments
    restrict = [1, 0, 0, mod(i, 2)]; % if 1, restrict parameter
    is10am = (i == 3 || i == 4); % if 1, implement 10am algo
    if is10am
        y0 = [0, 0, 175];
    else
        y0 = [0, 0, 310];
    end
    %iterate through each subject
    for subject = 1:numel(V) 
        initial_guess_params = [0, kcl, V(subject), ka]; % initial guess
        caff_err = @(params) caffeineError( ... % anon error function
            t_real, ...
            y_real(:, subject), ...
            y0, ...
            params, ...
            restrict, ...
            initial_guess_params, ...
            is10am ...
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
table_1e = table(:, :, 3);
table_1f = table(:, :, 4);
% takes a hot minute
disp('q1b'); disp(table_1b);
disp('q1c'); disp(table_1c);
disp('q1e'); disp(table_1e);
disp('q1f'); disp(table_1f);