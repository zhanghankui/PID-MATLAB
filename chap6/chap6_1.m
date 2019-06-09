%微分器测试
clear all;
close all;
%r1跟踪v r2跟踪dv
h=0.001;%Sampling time
delta = 1500;%决定跟踪快慢的参数
r1_1 =0;r2_1=2*pi;%状态变量的上一次值
vn_1=0;%信号加噪声的上一次值

for k=1:1:1000
    time(k)=k*h;%time
    
    v(k)=sin(2*pi*k*h);%理想信号
    n(k)=0.5*(rand(1)-0.5);%噪声
    vn(k)=v(k)+n(k);%实际信号
    dv(k)=2*pi*cos(2*pi*k*h);%理想信号微分
    
    r1(k)=r1_1+h*r2_1;
    r2(k)=r2_1+h*fst(r1_1-vn(k),r2_1,delta,h);%非线性微分跟踪器
    
    dvn(k)=(vn(k)-vn_1)/h;%by defference 直接离散微分
    
    vn_1=vn(k);
    r1_1=r1(k);
    r2_1=r2(k);
end
figure(1);
subplot(211);

plot(time,v,'k:',time,vn,'r:','linewidth',2);
xlabel('time(s)');ylabel('signal');
legend('ideal signal','signal with noise');

subplot(212);
plot(time,v,'k:',time,r1,'r:','linewidth',2);
xlabel('time(s)');ylabel('signal');
legend('ideal signal','signal by TD');

figure(2);
subplot(211);
plot(time,dv,'k:',time,dvn,'linewidth',2);
xlabel('time(s)');ylabel('derivative signal');
legend('ideal derivative signal','derivative signal by difference');
subplot(212);
plot(time,dv,'k:',time,r2,'r:','linewidth',2);
xlabel('time(s)');ylabel('derivative signal');
legend('ideal derivative signal','derivative signal by TD');

    
    
