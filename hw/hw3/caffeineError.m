function error = caffeineError(t_measured, y_measured, y0, p, restrict, initial_guess_params)

    p = p.*(1 - restrict) + initial_guess_params.*restrict;
    error = 0;
    [t, y] = ode45(@(t, y) CaffeineODE(t, y, p), t_measured, y0);
    y_interp = interp1(t, y(:, 1), t_measured); % optimize for degr
    error = error + sum((y_interp(:) - y_measured).^2);
end