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

disp('parameters')
disp(V_popt)
disp(CL_popt)
disp(ka_popt)

%% Q3

TapData.kCL = TapData.CL ./ TapData.V;
simData.V  = parameter_allometry(TapData.V, V_popt);
simData.CL = parameter_allometry(TapData.CL, CL_popt);
simData.ka = parameter_allometry(TapData.ka, ka_popt);
simData.kCL = simData.CL ./ simData.V;

V_stdev  = std(TapData.V  ./ simData.V);
CL_stdev = std(TapData.CL ./ simData.CL);
ka_stdev = std(TapData.ka ./ simData.ka);
kCL_stdev = std(TapData.kCL ./ simData.kCL);
stdev = [V_stdev, CL_stdev, ka_stdev, kCL_stdev];

disp('stdev')
disp(stdev);