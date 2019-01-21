%PID Controller with Gradual approaching input value
clear all;
close all;

ts = 0.001;
sys = tf(5.235e005,[1,87.35,1.047e004,0]);
dsys = c2d(sys,ts,'z');
[num,den] = tfdata(dsys,'v');

u_1 = 0.0;u_2 = 0.0;u_3 = 0.0;u_4 = 0;u_5 = 0;
y_1 = 0.0;y_2 = 0.0;y_3 = 0.0;
error_1 = 0;error_2 = 0;ei = 0;

kp = 0.50;ki = 0.05;
rate = 0.25;
rini = 0.0;

for k = 1:1:1000
    time(k) = k*ts;
    rd = 20; %Step Signal
    r(k) = rd;
    %Linear model
    yout(k)=-den(2)*y_1-den(3)*y_2-den(4)*y_3+num(2)*u_1+num(3)*u_2+num(4)*u_3;%plant
    
    M = 2;
    if M == 1 %Using simple PID
        rin(k) = rd;
    end
    if M == 2 %Using Gradual approaching input value
        if rini<rd-0.25
            rini = rini+k*ts*rate;
        elseif rini>rd+0.25
            rini = rini - k*ts*rate;
        else
            rini = rd;
        end
        rin(k) = rini;
    end
    
    error(k) = rin(k)-yout(k);
    %PID with I separation
    if abs(error(k))<=0.8
        ei = ei + error(k)*ts;
    else
        ei = 0;
    end
    u(k) = kp*error(k)+ki*ei;
    
    if u(k)>=10
        u(k) = 10;
    end
    if u(k)<=-10
        u(k) = -10;
    end
    
    %----------------Return of PID parameter-----------------
    rin_1 = rin(k);
    u_3 = u_2;u_2 = u_1;u_1 = u(k);
    y_3 = y_2;y_2 = y_1;y_1 = yout(k);
    
    error_2 = error_1;
    error_1 = error(k);
end

figure(1);
plot(time,r,'b',time,yout,'r');
xlabel('time(s)');ylabel('rd,yout');
figure(2);
plot(time,u,'r');
xlabel('time(s)');ylabel('u');
figure(3);
plot(time,rin,'r.');
xlabel('time(s)');ylabel('rin');
        
