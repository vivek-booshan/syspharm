function dydt = tapentadol_eqns(t,y,p)
%
% Equations describing tapentadol PK; one central compartment, with
% oral delivery & ansorption from the gut; clearance from the 
% central compartment. 
%

dydt = zeros(3,1);    % make it a column vector (e.g. (3,1)

% 1 = drug in central compartment (mg/L)
% 2 = drug in gut (mg)
% 3 = degraded drug (mg)

 dydt(1) =     p.F*p.ka*y(2)/p.V - p.kCL*y(1) ; 
 dydt(2) =        -p.ka*y(2) ; 
 dydt(3) = (1-p.F)*p.ka*y(2)     + p.kCL*y(1)*p.V ; 
 
 
