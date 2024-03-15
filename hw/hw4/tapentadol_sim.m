function outAUC = tapentadol_sim(V,CL,ka,bioF,D0,DoseFreq,TimeLen,FigVis) 
arguments
    V double
    CL double
    ka double
    bioF double
    D0 double
    DoseFreq double
    TimeLen double = 24
    FigVis logical = 0
end
% This function runs one simulation of repeated tapentadol dosing
%%
% INPUTS
% V - volume of central compartment (L)
% CL - volumetric clearance rate (L/hr)
% ka - absorption rate constant (1/hr)
% bioF - bioavailability (no units)
% D0 - dose (mg) - oral dose for each administration
% DoseFreq (hr) - number of hours between doses
% TimeLen (hr) - overall length of simulation
% FigVis - flag to output figures from this simulation or not; generally,
%   set to 1 (yes) if running a single simulation; set to 0 (don't output)
%   if running many simulations.
%
% OUTPUTS
%
% outAUC - AUC of central compartment concentration over 24 hrs - (mg/L)*hr

% TimeLen = 24; % hours
NumberOfDoses = floor(TimeLen/DoseFreq)-1 ; % don't count first dose for loop purposes

options = odeset('MaxStep',5e-2, 'AbsTol', 1e-5,'RelTol', 1e-5,'InitialStep', 1e-2);

%% FIRST DOSE
y0 = [0 D0 0]'; % mg/L - Initial conditions vector
    % 1 = drug in central; 2 = drug in gut; 3 = drug cleared
    
p.V = V;
p.kCL = CL/V;
p.ka = ka;
p.F = bioF;

[T1,Y1] = ode45(@tapentadol_eqns,0:(1/60):DoseFreq,y0,options,p); % simulate for infusion time period
DrugIn = D0*ones(length(T1),1); % added dose
y0 = Y1(end,:);   % use final timepoint values for next period initial timepoint
temp2 = DrugIn(end);

%% SECOND AND SUBSEQUENT DOSES

for i=1:NumberOfDoses
    % infusion period
    y0(2) = y0(2)+D0; % next dose
    [T2,Y2] = ode45(@tapentadol_eqns,DoseFreq*i:(1/60):(DoseFreq*(i+1)),y0,options,p);
    y0 = Y2(end,:);
    DrugIn = [DrugIn(1:length(DrugIn)-1); (temp2 + D0*ones(length(T2),1))] ;
    temp2 = DrugIn(end);
    T1 = [T1(1:length(T1)-1);T2];
    Y1 = [Y1(1:length(Y1)-1,:);Y2];
end

%% MASS BALANCE

TotalFreeD(:,1) = Y1(:,1)*V; % mg in central compartment
TotalFreeD(:,2) = Y1(:,2);   % mg in gut
DrugOut = Y1(:,3) ; % cumulative drug eliminated from system
BalanceD1 = DrugIn - DrugOut - TotalFreeD(:,1) - TotalFreeD(:,2); %(zero = balance)

% Include a check on the molecular balance. Note that we don't want to 
%   do it visually for thousands of runs - too many figures to read
%   through! So, instead we define a criterion; for example, here it will
%   alert us if there is a mismatch by more than 1ppm (10^-6)
check = max(max(BalanceD1))/(D0/V);
% fprintf ('Molecular Balance = %2.1e\n',check);
if check > 1.e-6
    fprintf ('*** Molecular Balance Violated ***\n');
end

%% VISUALIZATION

% output figures to plot if desired; but for repeated calls, likely want to
%   suppress the figures.
if FigVis
    figure;
    plot(T1,Y1(:,1),'k');
    hold on;
    lgd = legend('Central');
    lgd.Location = 'best';
    lgd.Title.String = 'Compartment';
    title(gca,'tapentadol Concentration')
    ylabel(gca,'Concentration (mg/L)')
    xlabel(gca,'time (hrs)')

    figure;
    plot(T1,Y1(:,2),'r');
    hold on;
    lgd = legend('Peripheral');
    lgd.Location = 'best';
    lgd.Title.String = 'Compartment';
    title(gca,'tapentadol Concentration')
    ylabel(gca,'Concentration (mg/L)')
    xlabel(gca,'time (hrs)')

    figure;
    plot(T1,BalanceD1);
    title(gca,'Vancomycin Mass Balance')
    ylabel(gca,'Mass Balance')
    xlabel(gca,'time (hrs)')
end

%% RETURN THE CALCULATED AUC VALUES

outAUC=trapz(T1,Y1(:,1)); % concentrations are mg/L so AUC units = mg/L*hr



