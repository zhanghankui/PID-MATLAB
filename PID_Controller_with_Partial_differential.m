%PID Controller with Partial differential
clear all;
close all;

ts = 0.001;
sys = tf(5.235e005,[1,87.35,1.047e004,0]);
dsys = c2d(sys,ts,'z');
[num,den] = tfdata(dsys,'v');

u_1 = 0.0;u_2 = 0.0;u_3 = 0.0;u_4 = 0;u_5 = 0;
y_1 = 0.0;y_2 = 0.0;y_3 = 0.0;

kp = 0.12;ki = 0.015;
x = [0,0];

for k = 1:1:3000
    time(k) = k*ts;
    rin(k) = 20;%step signal
    
    %Linear model
    yout(k)=-den(2)*y_1-den(3)*y_2-den(4)*y_3+num(2)*u_1+num(3)*u_2+num(4)*u_3;%plant
    
    D(k) = 0.50*rands(1); %Disturbance signal
    yyout(k) = yout(k)+D(k);
    
    M = 1;
    if M == 1 %No filter
        filty(k) = yyout(k);
    elseif M == 2 %Using filter with tracker and differentiation
        r = 2000;
        h = 0.02;
        T = ts;
        
        delta = r*h;
        delta0 = delta*h;
        y = x(1) - yyout(k) + h*x(2);
        a0 = sqrt(delta*delta + 8*r*abs(y));
        if abs(y) <= delta0
            a = x(2) + y/h;
        else
            a = x(2) + 0.5*(a0-delta)*sign(y);
        end
        if abs(a)<=delta
            fst2 = -r*a/delta;
        else
            fst2 = -r*sign(a);
        end
        
        x(1) = x(1) + T*x(2);
        x(2) = x(2) + T*fst2;
        filty(k) = x(1);%对输出测量数据进行微分-跟踪滤波后的结果
    end
    error(k) = rin(k) - filty(k);
    
    %T Sepration
    if abs(error(k))<=0.8
        ei = ei+error(k)*ts;
    else
        ei = 0;
    end
    u(k) = kp*error(k) + ki*ei;
    
    if u(k) >=10 %Restricting the output of controller
        u(k) = 10;
    end
    if u(k) <= -10
        u(k) = -10;
    end
    %------------------Return of PID parameters----------------
    rin_1 = rin(k);
    u_5 = u_4;u_4 = u_3;u_3 = u_2;u_2 = u_1;u_1 = u(k);
    y_3 = y_2;y_2 = y_1;y_1 = yout(k);
end

figure(1);
subplot(211);
plot(time,rin,'b',time,yout,'r');
set(gca,'YLim',[19.9 20.1]);
xlabel('time(s)');ylabel('rin,yout');
subplot(212);
plot(time,u,'r');
set(gca,'YLim',[-0.1 0.1]);
xlabel('time(s)');ylabel('u');

% figure(2);
% plot(time,D,'r');
% xlabel('time(s)');ylabel('Disturbance signal');
% 
% figure(3);
% plot(time,yyout,'r',time,filty,'b');
% xlabel('time(s)');ylabel('ideal gignal,practical signal');
