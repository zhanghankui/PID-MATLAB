% PID Controller with Partial differential
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
kp = 0.20;ki = 0.05;

sys1 = tf([1],[0.04,1]); %Low Freq Signal Filter
dsys1 = c2d(sys1,ts,'tustin');
[num1,den1] = tfdata(dsys1,'v');
f_1 = 0;

M = 3;
for k = 1:1:1000
    time(k) = k*ts;
    
    rin(k) = 20;%Step Signal
    
    %Linear model
    yout(k)=-den(2)*y_1-den(3)*y_2-den(4)*y_3+num(2)*u_1+...
        num(3)*u_2+num(4)*u_3;%plant
    
    if M == 1  % No disturbance signal
        filty(k) = yout(k);      
        error(k) = rin(k)-filty(k);
    end
    
    D(k) = 5.0*rands(1) %Disturbance signal
    yyout(k) = yout(k)+D(k);
    
    if M == 2    %No filter
        filty(k) = yyout(k);
        error(k) = rin(k) - filty(k);
    end
    
    if M == 3 % Using low frequency filter
        filty(k) = -den1(2)*f_1+num1(1)*(yyout(k)+yy_1);
        error(k) = rin(k)-filty(k);
    end
    
    % I separation
    if abs(error(k)<=0.8)
        ei = ei+error(k)*ts;
    else
        ei = 0;
    end
    u(k) = kp*error(k)+ki*ei;%PID calculate
    if u(k) >=10 % Restricting the output of controller
        u(k) = 10;
    end
    if u(k)<=-10;
        u(k) = -10;
    end
    %------------Return of PID parameters-------------------
    rin_1 = rin(k);
    u_5 = u_4;u_4 = u_3;u_3 = u_2;u_2 = u_1;u_1 = u(k);
    y_3 = y_2;y_2 = y_1;y_1 = yout(k); 
    
    f_1 = filty(k);
    yy_1 = yyout(k);
    
    error_2 = error_1;
    error_1 = error(k);
end
figure(1);
plot(time,rin,'b',time,filty,'r');
xlabel('time(s)');ylabel('rin,yout');
figure(2);
plot(time,u,'r');
xlabel('time(s)');ylabel('u');
figure(3);
plot(time,D,'r');
xlabel('time(s)');ylabel('Disturbance signal');
