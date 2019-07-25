close all;
figure(1);
plot(t,x(:,1),'r',t,x(:,2),'k:',t,x(:,4),'b-.','linewidth',2);
xlabel('time(s)'),ylabel('position signal');
legend('ideal signal','transient position signal','position tracking');

% figure(2);
% subplot(311);
% plot(t,z(:,1),