%% PK sensitivity
step = 21;
CL = linspace(0.03, 0.035, step);
Vc = linspace(2, 3, step);
Vp = linspace(3.45, 4.2, step);

[meshvc, meshcl] = meshgrid(Vc, CL);
[meshvp, ~] = meshgrid(Vp, CL);
y0 = zeros(1, 4);
vc_cl_1wk = zeros(step);
vp_cl_1wk = zeros(step);

parfor i = 1:numel(meshvc)
    pvc = Model.pkParameters(meshvc(i), 3.91, 0.0363, meshcl(i));
    pvp = Model.pkParameters(2.48, meshvp(i), 0.0363, meshcl(i));

    [t, y, ~] = Model.simulatePK(pvc, y0, 5, "solver", @ode23s, "resolution", 15);
    vc_cl_1wk(i) = trapz(t, y(:, 1));
    [t, y, ~] = Model.simulatePK(pvp, y0, 5, "solver", @ode23s, "resolution", 15);
    vp_cl_1wk(i) = trapz(t, y(:, 1));
end

FILE_NAME = 'vc_cl_1wk'; writematrix(vc_cl_1wk, FILE_NAME);
FILE_NAME = 'vp_cl_1wk'; writematrix(vp_cl_1wk, FILE_NAME);


[meshvc, meshvp] = meshgrid(Vc, Vp);
vc_vp_1wk = zeros(step);
parfor i = 1:numel(meshvc)
    pvc = Model.pkParameters(meshvc(i), meshvp(i), 0.0363, 0.0326);
    [t, y, ~] = Model.simulatePK(pvc, y0, 5, "solver", @ode23s, "resolution", 15);
    vc_vp_1wk(i) = trapz(t, y(:, 1));
end
FILE_NAME = 'vc_vp_1wk'; writematrix(vc_vp_1wk, FILE_NAME)

%% PD sensitivity
step = 21;
dose = ones(1, 52)*5;
CL = linspace(0.03, 0.035, step);
Vc = linspace(2, 3, step);
Vp = linspace(3.45, 4.2, step);

[meshvc, meshcl] = meshgrid(Vc, CL);
[meshvp, ~] = meshgrid(Vp, CL);
y0 = zeros(1, 6);
y0(5) = 70;
y0(6) = 30;
vc_cl_wt = zeros(step);
vp_cl_wt = zeros(step);

parfor i = 1:numel(meshvc)
    pvc = Model.pkParameters(meshvc(i), 3.91, 0.0363, meshcl(i));
    pvp = Model.pkParameters(2.48, meshvp(i), 0.0363, meshcl(i));

    [~, y] = Model.simulatePD(pvc, y0, dose, "solver", @ode23s, "resolution", 1);
    vc_cl_wt(i) = sum(y(end, 5:6))/100 - 1
    [~, y] = Model.simulatePD(pvp, y0, dose, "solver", @ode23s, "resolution", 1);
    vp_cl_wt(i) = sum(y(end, 5:6))/100 - 1
end

FILE_NAME = 'vc_cl_wt'; writematrix(vc_cl_wt, FILE_NAME);
FILE_NAME = 'vp_cl_wt'; writematrix(vp_cl_wt, FILE_NAME);


[meshvc, meshvp] = meshgrid(Vc, Vp);
vc_vp_wt = zeros(step);
parfor i = 1:numel(meshvc)
    pvc = Model.pkParameters(meshvc(i), meshvp(i), 0.0363, 0.0326);
    [~, y] = Model.simulatePD(pvc, y0, dose, "solver", @ode23s, "resolution", 1);
    vc_vp_wt(i) = sum(y(end, 5:6))/100 - 1;
end
FILE_NAME = 'vc_vp_wt'; writematrix(vc_vp_wt, FILE_NAME)