%PID Controller Based on Ziegler-Nichols
clear all;
close all;

sys=tf(400,[1,30,200,0]);

 axis('normal');
 zgrid('new');
 
figure(1);
rlocus(sys);
[km,pole]=rlocfind(sys);%k为对应选择点处根轨迹开环增益；p为此点处的系统闭环特征根。

wm=imag(pole(2));%获取虚轴值
kp=0.6*km;
kd=kp*pi/(4*wm);
ki=kp*wm/pi;

figure(2);
grid on;
bode(sys,'r');

sys_pid=tf([kd,kp,ki],[1,0]);
sysc=series(sys,sys_pid);
hold on;
bode(sysc,'b');

figure(3);
rlocus(sysc);
