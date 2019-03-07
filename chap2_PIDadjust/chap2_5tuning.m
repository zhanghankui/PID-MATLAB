%PID Controler Based on Ziegler-Nichols
clear all;
close all;

ts = 0.25;
sys = tf(1,[10,2,0]);
dsys = c2d(sys,ts,'zoh');
[num,den]=tfdata(dsys,'v');%v�����������ֵ��Ԫ�������Ϊ����ֱ�����

axis('normal');%�ָ�����ϵ�Ĵ�С��ȡ���Ե�Ԫ������ƣ�ȡ�� axis square �� axis equal Ӱ��
zgrid('new');

figure(1);
rlocus(dsys);%z����켣
[km,pole]=rlocfind(dsys);

wm=angle(pole(1))/ts;
kp=0.6*km;
kd=kp*pi/(4*wm);
ki=kp*wm/pi;

sysc=tf([kd,kp,ki],[10,2,0,0]);
dsysc=c2d(sysc,ts,'zoh');
figure(2);
rlocus(dsysc);
axis('normal'),zgrid;
