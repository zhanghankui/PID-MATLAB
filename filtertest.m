clear;
clc;
% y(n) = ax(n) + by(n-1)
a= 0.1;
b = 1-a;
Ts = 0.001;
num = [a 0];
den = [1 -b];
zsys = tf(num,den,Ts);
figure(1);
bode(zsys);

%        'zoh'       Zero-order hold on the inputs 
%        'foh'       Linear interpolation of inputs 
%        'impulse'   Impulse-invariant discretization ?
%        'tustin'    Bilinear (Tustin) approximation. 
%        'matched'   Matched pole-zero method (for SISO systems only). 

sys = d2c(zsys,'tustin');
figure(2);
bode(sys);

zsys2 = c2d(sys,Ts,'tustin');
figure(3);
bode(zsys2);

num = [133];
den = [1 25 0];
sys1 = tf(num,den);
[A,B,C,D] = tf2ss(num,den);
bode(sys1)
