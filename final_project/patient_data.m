tmax = 8; % FDA 8-72
ka = log(2) / tmax;
bioF = 0.8; % FDA
kCL = 0.061; % L/h FDA
Vd = 10.3; % L FDA

T2DM = Patients(1000, 1);
BMIdist = T2DM.generateBMI();
FGdist = T2DM.generateFG();
BMIdist_zval = (BMIdist - T2DM.meanSimulatedBMI) / T2DM.stdSimulatedBMI;
FGdist_zval = (BMIdist - T2DM.meanSimulatedFG) / T2DM.stdSimulatedFG;
p = 0:0.01:1;
Y = p.*BMIdist_zval + sqrt(1 - p.^2).*FGdist_zval;
% correlation = @(p, x1, x2) p.*x1 + sqrt(1 - p.^2).*x2;
% corr2 = @(p) correlation(p, BMIdist_zval, FGdist_zval);
% Y = arrayfun(corr2, 0.1, 'UniformOutput', true);

