%PID Controller for square tracking with filtered signal
clear all;
close all;

ts = 20;
sys = tf([1],[60 1],'inputdelay',80);
dsys = c2d(sys,ts,'zoh');
[num,den] = tfdata(dsys,'v');

u_1 = 0; u_2 = 0; u_3 = 0; u_4 = 0; u_5 = 0;
y_1 = 0;
error_1 = 0;
ei = 0;
rin_1 = 0;rin_2 = 0;

for k = 1:1:1500
    time(k) = k*ts;
    
    rin(k) = 1.0*sign(sin(0.00005*2*pi*k*ts));
    
    M = 2;
    switch M;
        case 1
            irin(k) = rin(k);
        case 2
            irin(k) = 0.10*rin(k)+0.80*rin_1+0.10*rin_2;
    end
    
    %Linear model
    yout(k) = -den(2)*y_1+num(2)*u_5;
    
    kp = 0.80;
    kd = 10;
    ki = 0.002;
    
    error(k) = irin(k) -yout(k);
    ei = ei+error(k)*ts;
    
    u(k) = kp*error(k)+kd*(error(k)-error_1)/ts+ki*ei;
    
    %Update parameters
    u_5 = u_4;u_4 = u_3;u_3 = u_2;u_2 = u_1;u_1 = u(k);
    y_1 = yout(k); 
    
    error_2 = error_1;
    error_1 = error(k);
    rin_2 = rin_1;
    rin_1 = irin(k);
end

figure(1);
plot(time,rin,'k',time,yout,'k');
xlabel('time(s)');ylabel('rin,yout');
figure(2);
plot(time,u,'k');
xlabel('time(s)');ylabel('u');
