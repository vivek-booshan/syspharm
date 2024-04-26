popPK = Model.pkParameters();
allometry_CL = @(BW) popPK.CL * (BW / 70).^0.8;
allometry_Vc = @(FFM, FM) popPK.Vc * (FFM + FM*0.487)/70;
allometry_Vp = @(FFM, FM) popPK.Vp * (FFM + FM*0.487)/70;

T2DM = Model(1000, 1);
T2DM.generateBMI;
T2DM.generateBW;
T2DM.generateFFM;
iCL_T2DM = allometry_CL(T2DM.BW);
iVc_T2DM = allometry_Vc(T2DM.FFM, T2DM.FM);
iVp_T2DM = allometry_Vp(T2DM.FFM, T2DM.FM);

noT2DM = Model(1000, 0);
noT2DM.generateBMI;
noT2DM.generateBW;
noT2DM.generateFFM;
iCL_noT2DM = allometry_CL(noT2DM.BW);
iVc_noT2DM = allometry_Vc(noT2DM.FFM, noT2DM.FM);
iVp_noT2DM = allometry_Vp(noT2DM.FFM, noT2DM.FM);

%% Violin plot data
writematrix([T2DM.BMI, T2DM.BW, T2DM.gender, noT2DM.BMI, noT2DM.BW, noT2DM.gender], "BMI_BW_data.csv");
%% BMI vs parameter data
writematrix([T2DM.BMI, iCL_T2DM, iVc_T2DM, iVp_T2DM, noT2DM.BMI, iCL_noT2DM, iVc_noT2DM, iVp_noT2DM], "allometry_data.csv");
%% 
popPK = Model.pkParameters();
dose = ones(1, 52);
num_patients = T2DM.num_patients;
T2DM_FFM = T2DM.FFM;
T2DM_FM = T2DM.FM;
changeBW25 = zeros(num_patients, 1);
changeBW50 = zeros(num_patients, 1);
changeBW75 = zeros(num_patients, 1);
changeBW100 = zeros(num_patients, 1);

dose25 = dose*2.5;
parfor i = 1:num_patients
    FFM = T2DM_FFM(i); FM = T2DM_FM(i);
    y0 = zeros(1, 6);
    y0(5:6) = [FFM, FM];
    [~, y] = Model.simulatePD(p, y0, dose25);
    newBW = sum(y(end, 5:6));
    changeBW25(i) = (newBW/(FFM + FM)) - 1;
end

dose50 = dose*5;
parfor i = 1:num_patients
    FFM = T2DM_FFM(i); FM = T2DM_FM(i);
    y0 = zeros(1, 6);
    y0(5:6) = [FFM, FM];
    [~, y] = Model.simulatePD(p, y0, dose50);
    newBW = sum(y(end, 5:6));
    changeBW50(i) = (newBW/(FFM + FM)) - 1;
end

dose75 = dose*7.5;
parfor i = 1:num_patients
    FFM = T2DM_FFM(i); FM = T2DM_FM(i);
    y0 = zeros(1, 6);
    y0(5:6) = [FFM, FM];
    [~, y] = Model.simulatePD(p, y0, dose75);
    newBW = sum(y(end, 5:6));
    changeBW75(i) = (newBW/(FFM + FM)) - 1;
end

dose100 = dose*10;
parfor i = 1:num_patients
    FFM = T2DM_FFM(i); FM = T2DM_FM(i);
    y0 = zeros(1, 6);
    y0(5:6) = [FFM, FM];
    [~, y] = Model.simulatePD(p, y0, dose100);
    newBW = sum(y(end, 5:6));
    changeBW100(i) = (newBW/(FFM + FM)) - 1;
end
%%
popPK = Model.pkParameters();
dose = ones(1, 52);
num_patients = noT2DM.num_patients;
noT2DM_FFM = noT2DM.FFM;
noT2DM_FM = noT2DM.FM;
norm_changeBW25 = zeros(num_patients, 1);
norm_changeBW50 = zeros(num_patients, 1);
norm_changeBW75 = zeros(num_patients, 1);
norm_changeBW100 = zeros(num_patients, 1);

dose25 = dose*2.5;
parfor i = 1:num_patients
    FFM = noT2DM_FFM(i); FM = noT2DM_FM(i);
    y0 = zeros(1, 6);
    y0(5:6) = [FFM, FM];
    [~, y] = Model.simulatePD(p, y0, dose25);
    newBW = sum(y(end, 5:6));
    norm_changeBW25(i) = (newBW/(FFM + FM)) - 1;
end

dose50 = dose*5;
parfor i = 1:num_patients
    FFM = noT2DM_FFM(i); FM = noT2DM_FM(i);
    y0 = zeros(1, 6);
    y0(5:6) = [FFM, FM];
    [~, y] = Model.simulatePD(p, y0, dose50);
    newBW = sum(y(end, 5:6));
    norm_changeBW50(i) = (newBW/(FFM + FM)) - 1;
end

dose75 = dose*7.5;
parfor i = 1:num_patients
    FFM = noT2DM_FFM(i); FM = noT2DM_FM(i);
    y0 = zeros(1, 6);
    y0(5:6) = [FFM, FM];
    [~, y] = Model.simulatePD(p, y0, dose75);
    newBW = sum(y(end, 5:6));
    norm_changeBW75(i) = (newBW/(FFM + FM)) - 1;
end

dose100 = dose*10;
parfor i = 1:num_patients
    FFM = noT2DM_FFM(i); FM = noT2DM_FM(i);
    y0 = zeros(1, 6);
    y0(5:6) = [FFM, FM];
    [~, y] = Model.simulatePD(p, y0, dose100);
    newBW = sum(y(end, 5:6));
    norm_changeBW100(i) = (newBW/(FFM + FM)) - 1;
end

%writematrix([changeBW25, changeBW50, changeBW75, changeBW100, ones(num_patients, 1); norm_changeBW25, norm_changeBW50, norm_changeBW75, norm_changeBW100, zeros(num_patients, 1)], "changeBW.csv");

%% 1 year treatment, 2 year off
clf;
dose = zeros(1, 52*3); % three years
mag = [2.5, 5, 7.5, 10];
FFM = mean([T2DM.FFM; noT2DM.FFM]);
FM = mean([T2DM.FM; noT2DM.FM]);
y0 = zeros(1, 6); y0(5:6) = [FFM, FM];
hold on;
for i = 1:length(mag)
    dose(1:52*1.5) = mag(i);
    [t, y] = Model.simulatePD(popPK, y0, dose);
    plot(t/8736, sum(y(:, 5:6), 2));
end
hold off;
title("1.5 Years On and 1.5 Years Off Schedule");
ylabel('Bodyweight (kg)');
xlabel("Time (years)");
legend('2.5 mg', '5 mg', '7.5 mg', '10 mg');

%% shiny app data
BMI = 15:0.1:50;
T2DM_BW = -6.642 + BMI*3.099;
normal_BW = -8.832 + BMI*3.233;

T2DM_FFM_male = 9270*T2DM_BW ./ (6680 + 216*BMI);
%T2DM_FM_male = T2DM_BW - T2DM_FFM_male;

T2DM_FFM_female = 9270*T2DM_BW ./ (8780 + 244*BMI);
%T2DM_FM_female = T2DM_BW - T2DM_FFM_female;

normal_FFM_male = 9270*normal_BW ./ (6680 + 216*BMI);
%normal_FM_male = normal_BW - normal_FFM_male;

normal_FFM_female = 9270*normal_BW ./ (8780 + 244*BMI);
%normal_FM_female = normal_BW - normal_FM_female;

T2DM_male_loss = zeros(length(BMI), 1);
T2DM_female_loss = zeros(length(BMI), 1);
normal_male_loss = zeros(size(BMI));
normal_female_loss = zeros(size(BMI));
popPK = Model.pkParameters();
ka = popPK.ka;
allometry_CL = @(BW) popPK.CL * (BW / 70).^0.8;
allometry_Vc = @(FFM, FM) popPK.Vc * (FFM + FM*0.487)/70;
allometry_Vp = @(FFM, FM) popPK.Vp * (FFM + FM*0.487)/70;
dose = ones(1, 52)*5;
%maxiter = length(BMI);
parfor i = 1:length(BMI)
    iBMI = BMI(i);
    iT2DM_BW = T2DM_BW(i);
    inormal_BW = normal_BW(i);

    iT2DM_FFM_male = T2DM_FFM_male(i);
    iT2DM_FM_male = iT2DM_BW - iT2DM_FFM_male;
    iT2DM_FFM_female = T2DM_FFM_female(i);
    iT2DM_FM_female = iT2DM_BW - iT2DM_FFM_female;
    
    inormal_FFM_male = normal_FFM_male(i);
    inormal_FM_male = inormal_BW - inormal_FFM_male;
    inormal_FFM_female = normal_FFM_female(i);
    inormal_FM_female = inormal_BW - inormal_FFM_female;
    
    CL_T2DM = allometry_CL(iT2DM_BW)
    CL_normal = allometry_CL(inormal_BW)
    
    Vc_T2DM_male = allometry_Vc(iT2DM_FFM_male, iT2DM_FM_male);
    Vc_T2DM_female = allometry_Vc(iT2DM_FFM_female, iT2DM_FM_female);
    Vc_normal_male = allometry_Vc(inormal_FFM_male, inormal_FM_male);
    Vc_normal_female = allometry_Vc(inormal_FFM_female, inormal_FM_female);

    Vp_T2DM_male = allometry_Vp(iT2DM_FFM_male, iT2DM_FM_male);
    Vp_T2DM_female = allometry_Vp(iT2DM_FFM_female, iT2DM_FM_female);
    Vp_normal_male = allometry_Vp(inormal_FFM_male, inormal_FM_male);
    Vp_normal_female = allometry_Vp(inormal_FFM_female, inormal_FM_female);
    
    p = Model.pkParameters(Vc_T2DM_male, Vp_T2DM_male, ka, CL_T2DM);
    y0 = zeros(1, 6); y0(5:6) = [iT2DM_FFM_male, iT2DM_FM_male];
    [~, T2DM_male] = Model.simulatePD(p, y0, dose, "solver", @ode23s);
    p = Model.pkParameters(Vc_T2DM_female, Vp_T2DM_female, ka, CL_T2DM);
    y0 = zeros(1, 6); y0(5:6) = [iT2DM_FFM_female, iT2DM_FM_female];
    [~, T2DM_female] = Model.simulatePD(p, y0, dose, "solver", @ode23s);
    p = Model.pkParameters(Vc_normal_male, Vp_normal_male, ka, CL_normal);
    y0 = zeros(1, 6); y0(5:6) = [inormal_FFM_male, inormal_FM_male];
    [~, normal_male] = Model.simulatePD(p, y0, dose, "solver", @ode23s);
    p = Model.pkParameters(Vc_normal_female, Vp_normal_female, ka, CL_normal);
    y0 = zeros(1, 6); y0(5:6) = [inormal_FFM_female, inormal_FM_female];
    [t, normal_female] = Model.simulatePD(p, y0, dose, "solver", @ode23s);

    writematrix([t/168, sum(T2DM_male(:, 5:6), 2), sum(T2DM_female(:, 5:6), 2), sum(normal_male(:, 5:6), 2), sum(normal_female(:, 5:6), 2)], ...
        sprintf("shinyBMI_%g_data.csv", i));
end