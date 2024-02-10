clear;

p.kon  = 0.005;
p.koff = 0.25;

p.kt1  = 1.0;
p.kt1r = 1.0;

p.kt2  = 1.0;
p.kt2r = 1.0;

p.kb   = 0.1;
p.kbr  = 0.1;

p.kc   = 0.3 / 2.75;

p.vbp  = 2.75;
p.vt1  = 0.25 * 0.25;
p.vt2  = 0.025 * 0.25;
p.vb   = 45 * 0.15;

D0 = 0.96;
P0 = 100;

y0 = [D0, 0, 0, 0, 0, 0, P0]';
options = odeset('MaxStep', 5e-2, 'AbsTol', 1e-5, 'RelTol', 1e-5, 'InitialStep', 1e-2);
[T1, Y1] = ode23(@m4C_eqns_Heparin, 0:1/60:96, y0, options, p);