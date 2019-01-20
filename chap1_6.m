%Discrete PID control for continuous plant
clear all;
close all;

ts = 0.001;%Sampling time
xk = zeros(2,1);%����2*1ȫ�����
e_1 = 0;
u_1 = 0;

for k = 1:1:2000
    time(k) = k*ts;
    rin(k) = 0.50*sin(1*2*pi*k*ts)
    
    para = u_1;%D/A para������������
    tSpan = [0 ts];%������ [t0 tf] 
    %tt ������������ʱ��㣬xx���ض�Ӧtt�����������
    [tt xx] = ode45('chap1_6f',tSpan,xk,[],para);%[]�ǳ�ʼֵ����
    xk = xx(length(xx),:); %A/D ��ȡxx�����һ��Ԫ��
    yout(k) = xk(1);%��ȡxk�ĵ�1��Ԫ��
    
    e(k) = rin(k)-yout(k);
    de(k) = (e(k)-e_1)/ts;
    
    u(k) = 20.0*e(k)+0.50*de(k);
    %Control limit
    if u(k)>10.0
        u(k) = 10.0;
    end
    if u(k)<-10.0
        u(k) = -10.0
    end
    
    u_1 = u(k);%u_1����һ�ε�PD����ֵ
    e_1 = e(k);%e_1����һ�ε�errorֵ
end
figure(1);
plot(time,rin,'r',time,yout,'b');
xlabel('time(s)'),ylabel('rin,yout');
figure(2);
plot(time,rin-yout,'r');
xlabel('time(s)'),ylabel('error');

