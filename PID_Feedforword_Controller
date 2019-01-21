%PID Feedforword Controller
clear all;
close all;

ts = 0.001;
sys = tf(133,[1,25,0]);
dsys = c2d(sys,ts,'z');
[num,den] = tfdata(dsys,'v');

u_1 = 0;u_2 = 0;
y_1 = 0;y_2 = 0;

error_1 = 0;ei = 0;
for k = 1:1:1000
    time(k) = k*ts;
    
    A = 0.5;F = 3.0;
    rin(k) = A*sin(F*2*pi*k*ts);
    drin(k) = A*F*2*pi*cos(F*2*pi*k*ts);
    ddrin(k) = -A*F*2*pi*F*2*pi*sin(F*2*pi*k*ts);
    
    %Linear model
    yout(k) = -den(2)*y_1-den(3)*y_2+num(2)*u_1+num(3)*u_2;
    
    error(k) = rin(k) -yout(k);
    
    ei=ei+error(k)*ts;
    
    up(k) = 80*error(k)+20*ei+2.0*(error(k)-error_1)/ts;
    
    uf(k) = 25/133*drin(k)+1/133*ddrin(k);
    
    M = 1;
    if M == 1 %Only using PID
        u(k) = up(k);
    elseif M == 2 %PID+Feedforward
        u(k) = up(k) + uf(k);
    end
    
    if u(k) >= 10
        u(k) = 10;
    end
    if u(k) <= -10
        u(k) = -10;
    end
    
    u_2 = u_1; u_1 = u(k);
    y_2 = y_1; y_1 = yout(k);
    error_1 = error(k);
end
figure(1);
plot(time,rin,'r',time,yout,'b');
xlabel('time(s)');ylabel('rin,yout');
figure(2);
plot(time,error,'r');
xlabel('time(s)');ylabel('error');
figure(3);
plot(time,up,'k',time,uf,'b',time,u,'r');
xlabel('time(s)');ylabel('up,uf,u');
legend('up','uf','u');
% plot(time,up,'k',time,uf,'b');
% xlabel('time(s)');ylabel('up,uf');
% legend('up','uf');
