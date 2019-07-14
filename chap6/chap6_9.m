clear all;
close all;
h=0.01;%Sampling time
%ESO Parameters
beta1=100;beta2=300;beta3=1000;
delta1=0.0025;
alfa1=0.5;alfa2=0.25;

kp=10;kd=0.3;

xk=zeros(2,1);
u_1=0;
z1_1=0;z2_1=0;z3_1=0;

for k=1:1:2000
    time(k)=k*h;
    
    p1_u_1;
    p2=k*h;
    tSpan=[0 h];
    [tt,xx]=ode45('chap6_9plant',tSpan,xk,[],p1,p2);
    xk=xx(length(xx),:);
    y(k)=xk(1);
    dy(k)=xk(2);
    
    yd(k)=sin(k*h);
    dyd(k)=cos(k*h);
    
    f(k)=-25*dy(k)+33*sin(pi*p2);%unknown part
    b=133;
    x3(k)=f(k);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %ESO
    