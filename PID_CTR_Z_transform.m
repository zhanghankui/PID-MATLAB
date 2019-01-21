% PID Controller Z变换
clear all;
close all;

ts = 0.001;
sys = tf(400,[1,50,0]);
dsys = c2d(sys,ts,'z');
[num,den] = tfdata(dsys,'v');

u_1 = 0.0;u_2 = 0.0;u_3 = 0.0;
y_1 = 0.0;y_2 = 0.0;y_3 = 0.0;

x = [0,0,0]';

error_1 = 0;
error_2 = 0;

for k = 1:1:1000
    time(k) = k*ts;
    
    rin(k) = 1.0;
    kp = 8;
    ki = 0.10;
    kd = 10;
    
    du(k) = kp*x(1)+kd*x(2)+ki*x(3);
    u(k) = u_1+du(k);
    
    if u(k)>=10;
        u(k) = 10;
    end
    if u(k)<=-10;
        u(k) = -10;
    end
    yout(k) = -den(2)*y_1-den(3)*y_2+num(2)*u_1+num(3)*u_2;
    
    error = rin(k)-yout(k);
   
    % Return of parameters
    u_3 = u_2;u_2 = u_1;u_1 = u(k);
    y_3 = y_2;y_2 = y_1;y_1 = yout(k);
    
    x(1) = error-error_1;             % Calculating P
    x(2) = error-2*error_1+error_2;   % Calculating D
    x(3) = error;                     % Calculating I   
    
    error_2 = error_1;
    error_1 = error;
end
plot(time,rin,'b',time,yout,'r');
xlabel('time(s)');ylabel('rin,yout');
legend('Ideal position signal','Position tracking');
