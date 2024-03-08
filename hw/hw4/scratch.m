if ~exist('TapData', 'var')
    load('TapData.mat')
end

V_err = @(params) allometry_error(TapData.wt, TapData.V, params);
CL_err = @(params) allometry_error(TapData.wt, TapData.CL, params);
ka_err = @(params) allometry_error(TapData.wt, TapData.ka, params);

options = optimoptions( ...
    'lsqnonlin', ...
    'Algorithm', 'levenberg-marquardt', ...
    'Display', 'none' ...
);
V_popt = lsqnonlin(V_err, [1, 1], [], [], options);
CL_popt = lsqnonlin(CL_err, [1, 1], [], [], options);
ka_popt = lsqnonlin(ka_err, [1, 1], [], [], options);

disp(V_popt)
disp(CL_popt)
disp(ka_popt)