function [out1,out2,out3,out4, out5] = pk_sim(Vc,Vp,CL,ka,Q) 

T1=[];
Y1=[];
Balance=[];
options = odeset('MaxStep',5e-2, 'AbsTol', 1e-5,'RelTol', 1e-5,'InitialStep', 1e-2);

%% FIRST DOSE
y0 = [0 0 0 0]';
p.Vc = Vc;
p.Vp = Vp;
p.kCL = CL/Vc;
p.k12 = Q/Vc;
p.k21 = Q/Vp;
p.ka = ka;
p.F = 0.8;

for i= 1:4
    y0(3) = y0(3)+2.5;
    [Ti,Yi] = ode45(@pk_eqns,[168*(i-1):(1/60):168*i],y0,options,p);
    y0 = Yi(end,:);
    T1 = [T1(1:length(T1)-1);Ti];
    Y1 = [Y1(1:length(Y1)-1,:);Yi];
    Balancei= -2.5*i+Yi(:,1)*p.Vc+Yi(:,2)*p.Vc+Yi(:,4)+Yi(:,3);
    Balance=[Balance(1:length(Balance)-1);Balancei];
end

for j= 5:8
    % infusion period
    y0(3) = y0(3)+5; % next dose
    [Tj,Yj] = ode45(@pk_eqns,[168*(j-1):(1/60):168*j],y0,options,p);
    y0 = Yj(end,:);
    T1 = [T1(1:length(T1)-1);Tj];
    Y1 = [Y1(1:length(Y1)-1,:);Yj];
    Balancej= -5*(j-4)-10+Yj(:,1)*p.Vc+Yj(:,2)*p.Vc+Yj(:,4)+Yj(:,3);
    Balance=[Balance(1:length(Balance)-1);Balancej];
end

for k= 9:12
    % infusion period
    y0(3) = y0(3)+7.5; % next dose
    [Tk,Yk] = ode45(@pk_eqns,[168*(k-1):(1/60):168*k],y0,options,p);
    y0 = Yk(end,:);
    T1 = [T1(1:length(T1)-1);Tk];
    Y1 = [Y1(1:length(Y1)-1,:);Yk];
    Balancek= -7.5*(k-8)-30+Yk(:,1)*p.Vc+Yk(:,2)*p.Vc+Yk(:,4)+Yk(:,3);
    Balance=[Balance(1:length(Balance)-1);Balancek];
end

for l= 13:16
    % infusion period
    y0(3) = y0(3)+10; % next dose
    [Tl,Yl] = ode45(@pk_eqns,[168*(l-1):(1/60):168*l],y0,options,p);
    y0 = Yl(end,:);
    T1 = [T1(1:length(T1)-1);Tl];
    Y1 = [Y1(1:length(Y1)-1,:);Yl];
    Balancel= -10*(l-12)-60+Yl(:,1)*p.Vc+Yl(:,2)*p.Vc+Yl(:,4)+Yl(:,3);
    Balance=[Balance(1:length(Balance)-1);Balancel];
end


out1=T1;
out2=Y1(:,1);
out3=Y1(:,2);
out4=trapz(T1,Y1(:,1));
out5=Balance;
