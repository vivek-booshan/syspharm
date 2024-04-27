function dydt = m1C_eqns_Heparin(t,y,p)
% This function defines equations to simulate the concentration of heparin,
% protamine, and heparin-protamine complexes. Our main code doesn't call
% this function directly; it calls an ODE solver, which then calls this
% function repeatedly - i.e. at each time step - to calculate dydt
%
%% THIS FUNCTION RETURNS:
% dydt = the rates of change of the concentrations of
%  the molecules we are simulating
%
%% ARGUMENTS
% t = current time (this is passed from the ODE solver to here)
% y = current value of the concentrations (this is passed from the ode 
% solver to here; this will have three elements, one for each molecule)
% p = structured parameter set (we define this in our main code, and pass
% it to the ODE solver, which passes it to this function)

%% EQUATIONS

% this line just defines how many equations there will be
dydt = zeros(3,1);    % make it a column vector (e.g. (3,1))

% List of equations. Equation (1) is the ODE associated with the
% concentration of molecule (1); but note that each equation might depend
% on the concentrations of multiple molecules. This is what makes these
% 'coupled ODEs'
dydt(1) = p.qH/p.V - p.kcH*y(1)  - p.kon*y(1)*y(2) + p.koff*y(3); %H (heparin)
dydt(2) = p.qP/p.V - p.kcP*y(2)  - p.kon*y(1)*y(2) + p.koff*y(3); %P (protamine)
dydt(3) =          - p.kcPH*y(3) + p.kon*y(1)*y(2) - p.koff*y(3); %P-H

% Note that qH is included in the above equation (1). We could exclude this
% if we were only simulating protamine administration after heparin
% overdose; but leaving it in makes the code more flexible, and we can
% simply set the value of qH to zero to exclude heparin infusion.
