% PID Controller with intergration sturation
clear all;
close all;

ts = 0.001;
sys = tf(5.235e005,[1,87.35,1.047e004,0]);
dsys = c2d(sys,ts,'z');
[num,den] = tfdata(dsys,'v');

u_1 = 0.0;u_2 = 0.0;u_3 = 0.0;
y_1 = 0;y_2 = 0;y_3 = 0;

x = [0,0,0]';
error_1 = 0;

um = 6;
kp = 0.85;ki = 9.0;kd = 0.0;
rin = 30; %Step Signal

for k = 1:1:800
    time(k) = k*ts;
    
    u(k) = kp*x(1)+kd*x(2)+ki*x(3); % PID Controller
    
    if u(k)>=um
        u(k) = um;
    end
    if u(k)<=-um
        u(k) = -um;
    end
    
    % Linear model
    yout(k)=-den(2)*y_1-den(3)*y_2-den(4)*y_3+num(2)*u_1+num(3)*u_2+num(4)*u_3;
    
    error(k) = rin - yout(k);
    
    M = 2;
    if M == 1 % Using integration sturation
        if u(k)>=um
            if error(k)>0
                alpha = 0;
            else
                alpha = 1;
            end
        elseif u(k)<=-um
            if error(k)>0
                alpha = 1;
            else
                alpha = 0;
            end
        else
            alpha = 1;
        end
    elseif M == 2 %Not using integration sturation
        alpha = 1;
    end
    
    %Return of PID parameters
    u_3 = u_2;u_2 = u_1;u_1 = u(k);
    y_3 = y_2;y_2 = y_1;y_1 = yout(k);
    
    error_1 = error(k);
    
    x(1) = error(k);                % Calculating P
    x(2) = (error(k)-error_1)/ts;   % Calculating D
    x(3) = x(3)+alpha*error(k)*ts;  % Calculating I 
    
    xi(k) = x(3);
end

figure(1);
subplot(311);
plot(time,rin,'b',time,yout,'r');
xlabel('time(s)');ylabel('Position tracking');
subplot(312);
plot(time,u,'r');
xlabel('time(s)');ylabel('Controller output');
subplot(313);
plot(time,xi,'r');
xlabel('time(s)');ylabel('Integration');
