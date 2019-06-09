clear all;
close all;

h=0.01;%采样时间

delta=50;
% xk=zeros(3,1);
u_1=0;
r_1=0;
r1_1=0;r2_1=0;

for k=1:1:1000
    time(k)=h*k;
    
    r(k)=sign(sin(time(k)));
    dr(k)=0;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %TD Transient process
%     x1=r1_1-r_1;
%     x2=r2_1;
    
    r1(k)=r1_1+h*r2_1;
    r2(k)=r2_1+h*fst(r1_1-r_1,r2_1,delta,h);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    r_1 = r(k);
    r1_1 = r1(k);
    r2_1 = r2(k);
end

figure(1);
subplot(211);
plot(time,r,'k',time,r1,'r:','linewidth',2);
legend('refer position singal','Transient position signal');
xlabel('time(s)');ylabel('position signal');
subplot(212);
plot(time,r2,'r','linewidth',2);
legend('Transient speed signal');
xlabel('time(s)');ylabel('speed signal');