%Discrete PID control for continuous plant
clear all;
close all;

ts = 0.001;%Sampling time
xk = zeros(2,1);%生成2*1全零矩阵
e_1 = 0;
u_1 = 0;

for k = 1:1:2000
    time(k) = k*ts;
    rin(k) = 0.50*sin(1*2*pi*k*ts)
    
    para = u_1;%D/A para是求解参数设置
    tSpan = [0 ts];%是区间 [t0 tf] 
    %tt 返回列向量的时间点，xx返回对应tt的求解列向量
    [tt xx] = ode45('chap1_6f',tSpan,xk,[],para);%[]是初始值向量
    xk = xx(length(xx),:); %A/D 获取xx的最后一行元素
    yout(k) = xk(1);%获取xk的第1列元素
    
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
    
    u_1 = u(k);%u_1是上一次的PD计算值
    e_1 = e(k);%e_1是上一次的error值
end
figure(1);
plot(time,rin,'r',time,yout,'b');
xlabel('time(s)'),ylabel('rin,yout');
figure(2);
plot(time,rin-yout,'r');
xlabel('time(s)'),ylabel('error');

