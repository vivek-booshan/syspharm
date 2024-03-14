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

%% Q5

load('WeightDistribs_10000.mat');
assert(exist("Weights", "var"));
q5allo = @(parameters) parameter_allometry(Weights, parameters);
IIVfunc = @(stdev) exp(stdev .* randn(length(Weights), 1));

simData_woIIV(:, 1) = q5allo(V_stdev);
simData_woIIV(:, 2) = q5allo(CL_stdev);
simData_woIIV(:, 3) = q5allo(ka_stdev);
simData_woIIV(:, 4) = simData_woIIV(:, 2) ./ simData_woIIV(:, 1);

simDataIIV(:, 1) = simData_woIIV(:, 1).* IIVfunc(V_stdev);
simDataIIV(:, 2) = simData_woIIV(:, 2) .* IIVfunc(CL_stdev);
simDataIIV(:, 3) = simData_woIIV(:, 3) .* IIVfunc(ka_stdev);
simDataIIV(:, 4) = simDataIIV(:, 2) ./ simDataIIV(:, 1);
