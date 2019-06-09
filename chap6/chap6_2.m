%基于微分器的PD控制
close all;
clear all;

h=0.001;%采样时间
y_1=0;
dy_1=0;
yp_1=0;
ei=0;

%Plant 
a=25;b=133;
sys=tf(b,[1 a 0]);%133/(s^2+25s)
dsys=c2d(sys,h,'z');
[num,den]=tfdata(dsys,'v');
u_1=0;u_2=0;%u 控制量      
p_1=0;p_2=0;%p plant输出

for k=1:1:5000
    t=k*h;
    time(k)=t;
    
    p(k)=-den(2)*p_1-den(3)*p_2+num(2)*u_1+num(3)*u_2;
    dp(k)=(p(k)-p_1)/h;%差分微分
    
    yd(k)=sin(t);%位置指令
    dyd(k)=cos(t);%位置指令理想微分
    d(k)=0.5*sign(rands(1));%Noise
    if mod(k,100)==1 | mod(k,100)==2%叠加毛刺
        yp(k)=p(k)+d(k);%Practical signal
    else
        yp(k)=p(k);
    end
    
    M=2;
    if M==1%by difference
        y(k)=yp_1;
        dy(k)=(y(k)-y_1)/h;
    elseif M==2 %by TD
        delta=1000;
        y(k)=y_1+h*dy_1;
        dy(k)=dy_1+h*fst(y_1-yp_1,dy_1,delta,h);
    end
    kp=10;kd=0.5;ki=0.8;
    ei=ei+(yd(k)-y(k))*h;
    u(k)=kp*(yd(k)-y(k))+kd*(dyd(k)-dy(k))+ki*ei;%PI计算
    
    y_1=y(k);
    dy_1=dy(k);
    yp_1=yp(k);
    u_2=u_1;u_1=u(k);
    p_2=p_1;p_1=p(k);
end

figure(1);
plot(time,p,'k:',time,yp,'r:',time,y,'b:','linewidth',2);
xlabel('time(s)');ylabel('position tracking');
legend('plant out','plant out with nosie','plant out signal disposed by TD');

figure(2);
plot(time,yd,'k',time,p,'r:','linewidth',2);
xlabel('time(s)');ylabel('Positon tracking');
legend('refer position signal','tracking signal');