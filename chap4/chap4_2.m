%离散微分器
%线性微分器
%dx1=x2
%dx2=R^2*(-a0*(x1-v(t))-b0*x2/R)
%y=x2(t)
close all;
clear all;

T=0.001;
y_1=0;dy_1=1;
yv_1 =0;
v_1=0;

for k=1:1:10000
    t=k*T;
    time(k)=t;
    
    v(k)=sin(t);
    dv(k)=cos(t);
    
    d(k)=0.01*rands(1); %Noise
    yv(k)=v(k)+d(k);%Practical signal
    
    R=1/0.01;a0=0.1;b0=0.1;
    y(k)=y_1+T*dy_1;%积分形式 y(k)为x1 dy(k)为x2
    dy(k)=dy_1+T*R^2*(-a0*(y(k)-yv(k))-b0*dy_1/R);
    
    dyv(k)=(yv(k)-yv_1)/T; % Speed by Difference 实际值直接微分
    
    y_1=y(k);
    v_1=v(k);
    yv_1=yv(k);
    dy_1=dy(k);
end

figure(1);
subplot(211);
plot(time,v,'r',time,yv,'k:','linewidth',2);
xlabel('time(s)');ylabel('signal');
legend('ideal signal','signal with noise');
subplot(212);
plot(time,v,'r',time,y,'k:','linewidth',2);
xlabel('time(s)');ylabel('signal');
legend('ideal signal','signal by TD');

figure(2);
subplot(211);
plot(time,dv,'r',time,dyv,'k:','linewidth',2);
xlabel('time(s)');ylabel('derivative signal');
legend('ideal derivative signal','derivative signal by difference');

subplot(212);
plot(time,dv,'r',time,dy,'k:','linewidth',2);
xlabel('time(s)');ylabel('derivative signal');
legend('ideal derivative signal','derivative signal by TD');
