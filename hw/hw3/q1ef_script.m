%% 
y0 = [0, 0, 160];
is10am = 1;
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
table_1e = table(:, :, 1);
table_1f = table(:, :, 2);
disp(table_1e)
disp(table_1f)