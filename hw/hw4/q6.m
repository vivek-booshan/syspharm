% get_patient_parameter = @(data, idx) structfun(@(x) x(idx), data, 'UniformOutput', false);
if ~exist("simData_woIIV", 'var')
    disp("simData_woIIV not found");
    exit;
end
bioF = 0.85;
fixedD0 = 45; % mg
weightDose = 1; % mg/kg 
weightDoses = weightDose * Weights;
doseFreq = 6;
numSubjects = 10000;
fixed_IIV = zeros(numSubjects, 1);
fixed_woIIV = zeros(numSubjects, 1);

weight_IIV = zeros(numSubjects, 1);
weight_woIIV = zeros(numSubjects, 1);

gcp();
% parfor GREATLY speeds up calculations 
% greater worker activity to separate as 4 loops

%% w/o IIV
% preallocate to decrease communication between processes
V = simData_woIIV(:, 1); 
CL = simData_woIIV(:, 2);
ka = simData_woIIV(:, 3);

parfor i = 1:numSubjects
    fixed_woIIV(i) = tapentadol_sim(V(i), CL(i), ka(i), bioF, fixedD0, doseFreq);
end

writematrix([Weights, fixed_woIIV], 'fixed_woIIV.txt');

parfor i = 1:numSubjects
    weight_woIIV(i) = tapentadol_sim(V(i), CL(i), ka(i), bioF, weightDoses(i), doseFreq);
end
writematrix([Weights, weight_woIIV], 'weight_woIIV.txt');

%% w/ IIV
V = simData_IIV(:, 1);
CL = simData_IIV(:, 2);
ka = simData_IIV(:, 3);

parfor i = 1:numSubjects
    fixed_IIV(i) = tapentadol_sim(V(i), CL(i), ka(i), bioF, fixedD0, doseFreq);
end
writematrix([Weights, fixed_IIV], 'fixed_IIV.txt');

parfor i = 1:numSubjects
    weight_IIV(i) = tapentadol_sim(V(i), CL(i), ka(i), bioF, weightDoses(i), doseFreq);
end
writematrix([Weights, weight_IIV], 'weight_IIV.txt')