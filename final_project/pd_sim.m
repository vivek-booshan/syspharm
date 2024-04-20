function [out1,out2,out3] = pd_sim(Vc,Vp,CL,ka,Q,dis,off,plac,Hlim,E0H,expo,EC50,out,E0G,F0,H0); 
T1=[]
Y1=[]
options = odeset('MaxStep',5e-2, 'AbsTol', 1e-5,'RelTol', 1e-5,'InitialStep', 1e-2);

%% FIRST DOSE
y0 = [0 0 0 0 F0 0 H0]';
p.Vc = Vc;
p.Vp = Vp
p.kCL = CL/Vc;
p.k12 = Q/Vc;
p.k21 = Q/Vp;
p.ka = ka;
p.F = 0.8;
p.DIS=dis
p.OFF=off
p.PLAC=plac
p.Hlim=Hlim
p.E0H=E0H
p.expo=expo
p.EC50=EC50
p.E0G= E0G
p.OUT=out



for i= 1:4
    y0(3) = y0(3)+2.5;
    [Ti,Yi] = ode45(@pd_eqns,[168*(i-1):(1/60):168*i],y0,options,p);
    y0 = Yi(end,:);
    T1 = [T1(1:length(T1)-1);Ti];
    Y1 = [Y1(1:length(Y1)-1,:);Yi];
end

for j= 5:8
    % infusion period
    y0(3) = y0(3)+5; % next dose
    [Tj,Yj] = ode45(@pd_eqns,[168*(j-1):(1/60):168*j],y0,options,p);
    y0 = Yj(end,:);
    T1 = [T1(1:length(T1)-1);Tj];
    Y1 = [Y1(1:length(Y1)-1,:);Yj];
end

for k= 9:12
    % infusion period
    y0(3) = y0(3)+7.5; % next dose
    [Tk,Yk] = ode45(@pd_eqns,[168*(k-1):(1/60):168*k],y0,options,p);
    y0 = Yk(end,:);
    T1 = [T1(1:length(T1)-1);Tk];
    Y1 = [Y1(1:length(Y1)-1,:);Yk];
end

for l= 13:16
    % infusion period
    y0(3) = y0(3)+10; % next dose
    [Tl,Yl] = ode45(@pd_eqns,[168*(l-1):(1/60):168*l],y0,options,p);
    y0 = Yl(end,:);
    T1 = [T1(1:length(T1)-1);Tl];
    Y1 = [Y1(1:length(Y1)-1,:);Yl];
end




for k = 1:length(Y1)
    Y2(k)=Y1(k,5)-Y1(k,5)*Y1(k,6)
end

out1=T1
out2=Y2
out3=Y1(:,7)