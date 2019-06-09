%PD Control with TD Transient 
clear all;
close all;

M=2;
if M==1
    h=0.001;%采样时间
elseif M==2
    h=0.01;%采样时间
end

delta = 50;
xk=zeros(3,1);
u_1=0;
r_1=0;
r1_1=0;r2_1=0;

for k=1:1:1000
    time(k)=k*h;
    
    p1=u_1;
    p2=time(k);
    tSpan=[0 h];
    [tt,xx]=ode45('chap6_4plant',tSpan,xk,[],p1,p2);
%     [TOUT,YOUT] = ode45(ODEFUN,TSPAN,Y0,OPTIONS)
%     TSPAN = [T0 TFINAL] integrates 
%     the system of differential equations y' = f(t,y) from time T0 to TFINAL 
%     with initial conditions Y0
%     ODEFUN is a function handle. For a scalar T
%     and a vector Y, ODEFUN(T,Y) must return a column vector corresponding 
%     to f(t,y).
%     ODEFUN更多的参数放在OPTIONS
%     default integration properties replaced by values in OPTIONS  
    xk=xx(length(xx),:);
    y(k)=xk(1);
    dy(k)=xk(2);
    
    r(k)=sign(sin(time(k)));
    dr(k)=0;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %TD Transient 
    
    r1(k)=r1_1+h*r2_1;
    r2(k)=r2_1+h*fst(r1_1-r_1,r2_1,delta,h);
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    kp=1.0;kd=0.02;
    S  = 2;
    if S==1
        u(k)=kp*(r(k)-y(k))+kd*(dr(k)-dy(k));%Ordinary PD
    elseif S==2 % PD with TD
        u(k)=kp*(r1(k)-y(k))+kd*(r2(k)-dy(k));
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    r_1=r(k);
    r1_1=r1(k);
    r2_1=r2(k);
    
    u_1=u(k);
end

if S==1
    figure(1);
    plot(time,r,'k',time,y,'r:','linewidth',2);
    legend('refer position signal','Position signal tracking');
    xlabel('time(s)');ylabel('r,y');
elseif S==2
    figure(1);
    subplot(211);
    plot(time,r,'k',time,r1,'r:','linewidth',2);
    legend('refer position signal','Transient position signal');
    xlabel('time(s)');ylabel('position signal');
    subplot(212);
    plot(time,r2,'r','linewidth',2);
    legend('Transient speed signal');
    xlabel('time(s)');ylabel('speed signal');
    
    figure(2);
    plot(time,r1,'r',time,y,'b:','linewidth',2);
    legend('Transient position signal','Position signal tracking');
    xlabel('time(s)'),ylabel('r1,y');
end
