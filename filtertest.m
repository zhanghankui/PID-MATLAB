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

%        'zoh'       Zero-order hold on the inputs 零阶保持器法，又称阶跃响应不变法
%        'foh'       Linear interpolation of inputs 一阶保持器法
%        'impulse'   Impulse-invariant discretization 脉冲响应不变法
%        'tustin'    Bilinear (Tustin) approximation. 双线性变换法
%        'matched'   Matched pole-zero method (for SISO systems only). 

sys = d2c(zsys,'tustin');
figure(2);
bode(sys);

zsys2 = c2d(sys,Ts,'tustin');
figure(3);
bode(zsys2);

num = [133];
den = [1 25 0];
sys1 = tf(num,den);%传递函数
[A,B,C,D] = tf2ss(num,den);%状态空间模型
bode(sys1)%伯德图
