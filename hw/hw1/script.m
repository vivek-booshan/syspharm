clear; 
%%
%%% Required Parameters %%%%
p.kon  = 0.25 / 50;
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

P0 = 100;

%% Q2e
figure(1)
q2e
sgtitle("q2e");

%% Q2f
figure(2);
q2f
sgtitle("q2f");

%% Q2g
figure(3)
q2gh
sgtitle("q2g");
%% Q2f
figure(4)
p.kt1 = 0.01;
p.kt2 = 0.01;
q2gh
sgtitle("q2h");