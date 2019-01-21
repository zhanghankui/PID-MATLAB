%PID Controller with dead zone
clear all;
close all;

ts = 0.001;
sys = tf(5.235e005,[1,87.35,1.047e004,0]);
dsys = c2d(sys,ts,'z');
[num,den] = tfdata(dsys,'v');

u_1 = 0.0;u_2 = 0.0;u_3 = 0.0;u_4 = 0;u_5 = 0;
y_1 = 0.0;y_2 = 0.0;y_3 = 0.0;

yy_1 = 0;
error_1 = 0;error_2 = 0; ei = 0;

sys1 = tf([1],[0.04,1]); %Low Freq Signal Filter
dsys1 = c2d(sys1,ts,'tustin');
[num1,den1] = tfdata(dsys1,'v');
f_1 = 0;

for k = 1:1:2000
    time(k) = k*ts;
    
    rin(k) = 1; %Step Signal
    
    %Linear model
    yout(k)=-den(2)*y_1-den(3)*y_2-den(4)*y_3+num(2)*u_1+...
        num(3)*u_2+num(4)*u_3;%plant
    
    D(k) = 0.50*rands(1);%Disturbance Signal    
    yyout(k) = yout(k) + D(k);
    
    %Low frequency filter
    filty(k) = -den1(2)*f_1 + num1(1)*(yyout(k)+yy_1);
    error(k) = rin(k) - filty(k);
    
    if abs(error(k)<=0.20)
        ei = ei+error(k)*ts;
    else
        ei = 0;
    end
    
    kp = 0.50; ki = 0.10; kd = 0.020;
    u(k) = kp*error(k)+ki*ei+kd*(error(k)-error_1)/ts;
    
    M = 2;
    if M == 1
        u(k) = u(k);
%       error(k) = error(k);
    elseif M == 2 %Using Dead zone
        if abs(error(k))<=0.10
            u(k) = 0;
%           error(k) = 0;
        end
    end
    
    if u(k) >=10
        u(k) = 10;
    end
    if u(k)<=-10
        u(k) = -10;
    end
    
    %-----------------Return of PID parameters------------------
    rin_1 = rin(k);
    u_3 = u_2;u_2 = u_1;u_1 = u(k);
    y_3 = y_2;y_2 = y_1;y_1 = yout(k);
    
    f_1 = filty(k);
    yy_1 = yyout(k);
    
    error_2 = error_1;
    error_1 = error(k);
end
figure(1);
subplot(211);
plot(time,rin,'r',time,filty,'b');
xlabel('time(s)');ylabel('rin,yout');
subplot(212);
plot(time,u,'r');
xlabel('time(s)');ylabel('u');
figure(2);
plot(time,D,'r');
xlabel('time(s)');ylabel('Disturbance signal');
