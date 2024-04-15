tmax = 8; % FDA 8-72
ka = log(2) / tmax;
bioF = 0.8; % FDA
kCL = 0.061; % L/h FDA
Vd = 10.3; % L FDA

T2DM = Patients(1000, 1);
xdist_T2DM = T2DM.getVirtualPopulation();
noT2DM = Patients(1000, 0);
xdist_noT2DM = noT2DM.getVirtualPopulation();


