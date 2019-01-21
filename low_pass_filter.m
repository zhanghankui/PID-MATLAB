% low pass filter
clear all;
close all;

ts = 0.001;
Q = tf([1],[0.04,1]); %Low Freq Signal Filter
Qz = c2d(Q,ts,'tustin');
[num,den] = tfdata(Qz,'v');

y_1 = 0;y_2 = 0;
r_1 = 0;r_2 = 0;

for k = 1:1:5000
    time(k) = k*ts;
    % Tnput Signal with disturbance
    D(k) = 0.10*sin(100*2*pi*k*ts); % Disturbance signal
    rin(k) = D(k)+0.50*sin(0.2*2*pi*k*ts);%Tnput Signal
    
    yout(k) = -den(2)*y_1+num(1)*rin(k)+num(2)*r_1;
    
    y_1 = yout(k);
    r_1 = rin(k);
end
figure(1);bode(Q);
figure(2);
subplot(211);
plot(time,rin,'r');
xlabel('time(s)');ylabel('rin');
subplot(212);
plot(time,yout,'b');
xlabel('time(s)');ylabel('yout');
