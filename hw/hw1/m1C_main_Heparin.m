clear;
% This program runs multiple simulations of the heparin-protamine system,
% using equations listed in a separate function/file.

%% PARAMETERS

% First, we list the values for the parameters used in the equations
p.qH = 0;     % units: nmol/hr
% qH is the continuous infusion rate for heparin; set to zero because 
% following initial bolus, the mistake was identified and infusion ceased

p.qP = 58900; % units: nmol/hr
% qP is the continuous infusion rate for protamine sulfate; infusion of 
% protamine commences immediately after the heparin ceases

% Basis of this value:
% typical protamine sulfate infusion is 5 mg/min or 5*60 = 300 mg/hr
% molecular weight (MW) of protamine sulfate = 5100 Da = 5100 g/mol
% so, the protamine sulfate infusion is 0.3 / 5,100 = 5.89 * 10-5 mol/hr = 58,900 nmol/hr
% NOTE! that the infusion is in either weight (mg/hr) or amount (nmol/hr), not in concentration terms

D0H = 1300; % units: nmol (bolus) 
% D0H can be used for a bolus dose of heparin 
% in this case, 1300 represents an incorrect high dose
% REMEMBER! that bolus is typically incorporated as an initial condition,
% rather than as a term in the ODEs

% Basis of this value:
% typical heparin dose is 10 IU; incorrect dose is 10,000 IU
% 10 IU = 0.02 mg     10,000 IU = 20 mg
% MW of heparin roughly 15 kDa = 15,000 Da = 15,000 g/mol
% so, the typical heparin dose is 0.00002 / 15,000 = 1.3 nmol
% and the higher heparin dose is  0.02 / 15,000 = 1.3 * 10-6 mol = 1300 nmol
% NOTE! that these are bolus doses and not infusion rates

D0P = 0;    % units: nmol (bolus) 
% D0P can be used for a bolus dose of protamine sulfate
% in this case, it's zero because protamine is being infused instead. 
% Combinations of bolus and infusion can also be used, which is why both
% are made available here as parameters and incorporated into the
% equations. This is also an example of keeping the code flexible so that
% we can try lots of different scenarios

p.V = 0.31; % units: L 
% V is the volume of distribution 
% here, we are assuming the volume is the same for heparin and protamine,
% and we are assuming that it's the plasma volume of an 8 lb neonate
% source - https://reference.medscape.com/calculator/648/estimated-blood-volume

p.kcH  =  .462 ; % units: 1/hr 
p.kcP  = 5.63  ; % units: 1/hr 
p.kcPH = 9.24  ; % units: 1/hr 
% These "kcX" are the clearance rate constants for heparin, protamine 
% and the heparin-protamine complex.

% Basis of these values:
% half-life of heparin = ~ 1.5 hours
% kcH = ln2 / t1/2 = 0.693 / 1.5 = 0.462 hr-1

% half-life of protamine sulfate = ~ 7.4 minutes = 0.123 hrs
% kcH = ln2 / t1/2 = 0.693 / 0.123 = 5.63 hr-1

% half-life of heparin-protamine sulfate = ~ 4.5 minutes = 0.075 hours
% kcH = ln2 / t1/2 = 0.693 / 0.075 = 9.24 hr-1

p.kon = .0002 ; % 1/(nM*hr)  also written as  nM^-1 hr^-1
p.koff = .36 ; % 1/hr 
% These are estimated binding and unbinding rate constants  
% for heparin binding to (or unbinding from) protamine

% dissociation constant of antithrombin III for heparin = 6 10^5 dm3/mol
% source: https://doi-org.proxy1.library.jhu.edu/10.1016/0304-4165(86)90136-4
% (binding affinity for protamine sulfate is hard to measure, but this is close)
% This dissociation constant is 6 10^5 dm3 / mol * 10^-9 mol/nmol * 6 10-4 L/nmol
% or, in terms more familiar to pharmacology, Kd = 1/6e-4 = 1670 nmol/L = 1670 nM
% assuming an unbinding rate of 10^-4 s-1 = 0.36 hr-1, this results
% in a binding rate of kon = koff/Kd = 0.36 / (1670) = 0.0002 (nM)^-1 hr^-1

% Initial conditions. This is important for initial value problems
% NOTE that the order of elements (H, P, P-H) must be the same as the 
% order of equations in the equations file.
y0 = [D0H/p.V D0P/p.V 0]'; % nM

%% SIMULATIONS

% FIRST SIMULATION
p.qP = 0; 
% first run - no treatment, just heparin initially (because of the overdose)
% heparin infusion ceased and protamine not administered, so qH =0 & qP = 0
y0 = [D0H/p.V D0P/p.V 0]'; % Initial Conditions; units: nM
options = odeset('MaxStep',5e-2, 'AbsTol', 1e-5,'RelTol', 1e-5,'InitialStep', 1e-2);
[T1,Y1] = ode45(@m1C_eqns_Heparin,[0 5],y0,options,p); % simulate model
TotalD1 = Y1*p.V ; % Total of drugs in compartment

% SECOND SIMULATION
p.qP = 58900/10; % three values of qP tested
y0 = [D0H/p.V D0P/p.V 0]'; % Initial Conditions; units: nM
[T2,Y2] = ode45(@m1C_eqns_Heparin,[0 5],y0,options,p); % simulate model
TotalD2 = Y2*p.V ;

% THIRD SIMULATION
p.qP = 58900; 
y0 = [D0H/p.V D0P/p.V 0]'; % Initial Conditions; units: nM
[T3,Y3] = ode45(@m1C_eqns_Heparin,[0 5],y0,options,p); % simulate model
TotalD3 = Y3*p.V ;

% FOURTH SIMULATION
p.qP = 58900*10; 
y0 = [D0H/p.V D0P/p.V 0]'; % Initial Conditions; units: nM
[T4,Y4] = ode45(@m1C_eqns_Heparin,[0 5],y0,options,p); % simulate model
TotalD4 = Y4*p.V ;

%% VISUALIZATION

fig1 = figure; % this sets up a new figure
ax1=subplot(3,2,1); % this defines one panel of the figure
% 'subplot' defines which panel; the (3,2,1) tells it that out of 
% six panels (3x2), this is the 1st one (i.e. top left)
% (see https://www.mathworks.com/help/matlab/ref/subplot.html)
% Note that we can now use 'ax1' to refer to this specific panel
plot(ax1,T1,Y1(:,1),'k',T2,Y2(:,1),'b',T3,Y3(:,1),'r',T4,Y4(:,1),'g','linewidth',3)
% 'plot' draws lines - T1 as x-axis, Y1 as y-axis, 'k' refers to line color
title(ax1,'Concentration of free Heparin in Compartment')
ylabel(ax1,'[D] (nM)')
xlabel(ax1,'time (hrs)')
lgd = legend('0', '5890', '58900', '589000');
lgd.Location = 'northeast'; % or eastoutside 
lgd.Title.String = ['Protamine' newline 'infusion rate' newline '(nmol/hr)'];

ax2=subplot(3,2,2);
plot(ax2,T1,TotalD1(:,1),'k',T2,TotalD2(:,1),'b',T3,TotalD3(:,1),'r',T4,TotalD4(:,1),'g','linewidth',3)
title(ax2,'Total Amount of free Heparin in System')
ylabel(ax2,'Total Drug (nmol)')
xlabel(ax2,'time (hrs)')
lgd = legend('0', '5890', '58900', '589000');
lgd.Location = 'northeast';
lgd.Title.String = ['Protamine' newline 'infusion rate' newline '(nmol/hr)'];

ax3=subplot(3,2,3);
plot(ax3,T1,Y1(:,2),'k',T2,Y2(:,2),'b',T3,Y3(:,2),'r',T4,Y4(:,2),'g','linewidth',3)
title(ax3,'Concentration of free Protamine in Compartment')
ylabel(ax3,'[D] (nM)')
xlabel(ax3,'time (hrs)')
lgd = legend('0', '5890', '58900', '589000');
lgd.Location = 'northeast';
lgd.Title.String = ['Protamine' newline 'infusion rate' newline '(nmol/hr)'];

ax4=subplot(3,2,4);
plot(ax4,T1,TotalD1(:,2),'k',T2,TotalD2(:,2),'b',T3,TotalD3(:,2),'r',T4,TotalD4(:,2),'g','linewidth',3)
title(ax4,'Total Amount of free Protamine in System')
ylabel(ax4,'Total Drug (nmol)')
xlabel(ax4,'time (hrs)')
lgd = legend('0', '5890', '58900', '589000');
lgd.Location = 'northeast';
lgd.Title.String = ['Protamine' newline 'infusion rate' newline '(nmol/hr)'];

ax5=subplot(3,2,5);
plot(ax5,T1,Y1(:,3),'k',T2,Y2(:,3),'b',T3,Y3(:,3),'r',T4,Y4(:,3),'g','linewidth',3)
title(ax5,'Concentration of Heparin-Protamine complex in Compartment')
ylabel(ax5,'[D] (nM)')
xlabel(ax5,'time (hrs)')
lgd = legend('0', '5890', '58900', '589000');
lgd.Location = 'northeast';
lgd.Title.String = ['Protamine' newline 'infusion rate' newline '(nmol/hr)'];

ax6=subplot(3,2,6);
plot(ax6,T1,TotalD1(:,3),'k',T2,TotalD2(:,3),'b',T3,TotalD3(:,3),'r',T4,TotalD4(:,3),'g','linewidth',3)
title(ax6,'Total Amount of Heparin-Protamine complex in System')
ylabel(ax6,'Total Drug (nmol)')
xlabel(ax6,'time (hrs)')
lgd = legend('0', '5890', '58900', '589000');
lgd.Location = 'northeast';
lgd.Title.String = ['Protamine' newline 'infusion rate' newline '(nmol/hr)'];

set(fig1, 'Position',[0 0 900 900])
exportgraphics(fig1,"HP_Figure1.png",'Resolution',300);

%% Visualization 1d
fig1 = figure;
ax1 = subplot(2, 2, 1);
plot( ...
    ax1, ...
    T1, Y1(:, 1) + Y1(:, 3), 'k', ...
    T2, Y2(:, 1) + Y2(:, 3), 'b', ...
    T3, Y3(:, 1) + Y3(:, 3), 'r', ...
    T4, Y4(:, 1) + Y4(:, 3), 'g', ...
    'linewidth', 3 ...
);
title(ax1, "Total Heparin Concentration");
xlabel(ax1, 'time (hrs)');
ylabel(ax1, '[D] (nm)');
lgd = legend('0', '5890', '58900', '589000');
lgd.Location = 'northeast';
lgd.Title.String = ['Protamine' newline 'infusion rate' newline '(nmol/hr)'];

ax2=subplot(2,2,2);
plot( ...
    ax2, ...
    T1, TotalD1(:,1), 'k', ...
    T2, TotalD2(:,1), 'b', ...
    T3, TotalD3(:,1), 'r', ...
    T4, TotalD4(:,1), 'g', ...
    'linewidth', 3 ...
);
title(ax2,'Total Amount of free Heparin in System');
ylabel(ax2,'Total Drug (nmol)');
xlabel(ax2,'time (hrs)');
lgd = legend('0', '5890', '58900', '589000');
lgd.Location = 'northeast';
lgd.Title.String = ['Protamine' newline 'infusion rate' newline '(nmol/hr)'];

ax3 = subplot(2, 2, 3)
plot( ...
    ax3, ...
    T1, Y1(:, 2) + Y1(:, 3), 'k', ...
    T2, Y2(:, 2) + Y2(:, 3), 'b', ...
    T3, Y3(:, 2) + Y3(:, 3), 'r', ...
    T4, Y4(:, 2) + Y4(:, 3), 'g', ...
    'linewidth', 3 ...
);
title(ax3, "Total Protamine Concentration");
xlabel("time (hrs)");
ylabel("[D] (nm)");
lgd.Location = 'northeast';
lgd.Title.String = ['Protamine' newline 'infusion rate' newline '(nmol/hr)'];

ax4=subplot(2,2,4);
plot( ...
    ax4, ...
    T1, TotalD1(:,2), 'k', ...
    T2, TotalD2(:,2), 'b', ...
    T3, TotalD3(:,2), 'r', ...
    T4, TotalD4(:,2), 'g', ...
    'linewidth', 3 ...
);
title(ax4,'Total Amount of free Protamine in System')
ylabel(ax4,'Total Drug (nmol)')
xlabel(ax4,'time (hrs)')
lgd = legend('0', '5890', '58900', '589000');
lgd.Location = 'northeast';
lgd.Title.String = ['Protamine' newline 'infusion rate' newline '(nmol/hr)'];
