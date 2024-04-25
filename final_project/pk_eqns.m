function dydt = pk_eqns(t,y,p)

dydt = zeros(4,1);    
 dydt(1) =     p.F*p.ka*y(3)/p.Vc - p.kCL*y(1) - p.k12*y(1)+p.k21*y(2); 
 dydt(2) =     p.k12*y(1) -p.k21*y(2) ;
 dydt(3) =        -p.ka*y(3) ; 
 dydt(4) = (1-p.F)*p.ka*y(3)     + p.kCL*y(1)*p.Vc ; 