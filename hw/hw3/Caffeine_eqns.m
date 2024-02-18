function dydt = Caffeine_eqns(t, y, p)

q = 0; %p(1);
kc = p(2);
V = p(3);
ka = 5.9413; %p(4);
dydt = zeros(3, 1); %column vector

% 1 = caffeine in body (mg/L)
% 2 = caffeine in degr (mg);
% 3 = caffeine in gut (mg)

dydt(1) = q/V + ka*y(3)/V - kc*y(1);
dydt(2) = kc*y(1)*V;
dydt(3) = -ka*y(3);

