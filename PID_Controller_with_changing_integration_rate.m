% PID Controller with changing integration rate
clear all;
close all;

%Big time delay Plant
ts = 20;
sys=tf([1],[60 1],'inputdelay',80);
dsys = c2d(sys,ts,'zoh');
[num,den] = tfdata(dsys,'v');

u_1 = 0.0;u_2 = 0.0;u_3 = 0.0;u_4 = 0;u_5 = 0;
y_1 = 0.0;y_2 = 0.0;y_3 = 0.0;

error_1 = 0;error_2 = 0;

ei = 0;

for k = 1:1:200
    time(k) = k*ts;
    
    rin(k) = 1.0; %Step Signal
    
    %Linear model
    yout(k) = -den(2)*y_1+num(2)*u_5;
    error(k) = rin(k) - yout(k);
    
    kp = 0.45;kd = 12;ki = 0.0048;
    A = 0.4; B = 0.6;
    
    %T type integration
    ei = ei + (error(k)+error_1)/2*ts;
    
    M = 2;
    if M == 1 % Changing integration rate
        if abs(error(k))<=B
            f(k) = 1;
        elseif abs(error(k))>B&abs(error(k))<=A+B
            f(k) = (A-abs(error(k))+B)/A;
        else
            f(k) = 0;
        end
    elseif M == 2 %Not changing integration rate
        f(k) = 1;
    end
    
    u(k) = kp*error(k)+kd*(error(k)-error_1)/ts + ki*f(k)*ei;
    ui(k) = ei;
    if u(k)>=10
        u(k) = 10;
    end
    if u(k)<=-10
        u(k) = -10;
    end
    %Return of PID parameters
    u_5 = u_4;u_4 = u_3;u_3 = u_2;u_2 = u_1;u_1 = u(k);
    y_3 = y_2;y_2 = y_1;y_1 = yout(k);       
    
    error_2 = error_1;
    error_1 = error(k);
end

figure(1);
plot(time,rin,'b',time,yout,'r');
xlabel('time(s)');ylabel('rin,yout');
figure(2);
plot(time,f,'r');
xlabel('time(s)');ylabel('Integration rate f');
    
