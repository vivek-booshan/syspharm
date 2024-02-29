% function error = caffeineError( ...
%     t_measured, y_measured, ...
%     y0, p, ...
%     restrict, initial_guess_params, is10am ...
%     )
%     arguments
%         t_measured (1, :) double
%         y_measured (1, :) double
%         y0 (1, 3) double
%         p (1, 4) double
%         restrict (1, 4) double
%         initial_guess_params (1, 4) double
%         is10am logical = 0
%     end
% 
%     p = p.*(1 - restrict) + initial_guess_params.*restrict;
%     if is10am
%         [~, y] = ode45(@(t, y) CaffeineODE(t, y, p), 0:1/4:1, y0);
%         y0 = y(end, :);
%         y0(end) = y0(end) + 310;
%     end
%     [t, y] = ode45(@(t, y) CaffeineODE(t, y, p), t_measured, y0);
%     y_interp = interp1(t, y(:, 1), t_measured, 'linear', 'extrap'); 
%     error = sum((y_interp(:) - y_measured(:)).^2);
% end
function error = caffeineError( ...
    t_measured, y_measured, ...
    y0, p, ...
    restrict, initial_guess_params, is10am ...
    )
    arguments
        t_measured (1, :) double
        y_measured (1, :) double
        y0 (1, 3) double
        p (1, 4) double
        restrict (1, 4) double
        initial_guess_params (1, 4) double
        is10am logical = 0
    end

    p = p.*(1 - restrict) + initial_guess_params.*restrict;
    if is10am
        [~, y] = ode45(@(t, y) CaffeineODE(t, y, p), 0:1/4:1, y0);
        y0 = y(end, :);
        y0(end) = y0(end) + 310;
    end

    error = zeros(size(t_measured));
    [t, y] = ode45(@(t, y) CaffeineODE(t, y, p), 0:1/10:14, y0);
    for j=1:length(t_measured)
        teval = abs(t - t_measured(j));
        [~, tindex] = min(teval);
        error(j) = y(tindex) - y_measured(j);
    end
end