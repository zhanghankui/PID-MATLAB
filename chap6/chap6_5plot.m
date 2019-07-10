close all;
figure(1);
subplot(211);
plot(t,x(:,1),'r',t,x(:,2),'k:','linewidth',2);
xlabel('time(s)');ylabel('position signal');
legend('ideal position signal','transient postion signal');

subplot(212);
plot(t,x(:,3),'r','linewidth',2);
xlabel('time(s)');ylabel('speed signal');
legend('transient speed signal');