function dydt = pd_eqns(t,y,p)

dydt = zeros(7,1);    
 dydt(1) =     p.F*p.ka*y(3) - p.kCL*y(1) - p.k12*y(1)+p.k21*y(2) ; 
 dydt(2) =     p.k12*y(1)-p.k21*y(2) ;
 dydt(3) =        -p.ka*y(3)*p.Vc ; 
 dydt(4) = (1-p.F)*p.ka*y(3)     + p.kCL*y(1)*p.Vc ; 
 dydt(5) = p.DIS
 dydt(6) = p.OFF*((1-p.PLAC-(p.Hlim/p.E0H)^(1/p.expo))*y(1)/(y(1)+p.EC50)-y(6))
 dydt(7) = (p.OUT*p.E0H*(y(5)-y(5)*y(6))^p.expo/(p.E0G^p.expo))-p.OUT*y(7)