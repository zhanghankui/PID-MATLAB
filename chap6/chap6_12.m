clear all;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%
h=0.01; %Sampling time
%Transient parameters with TD
delta = 10;
%ESO parameters
beta1=100;beta2=200;beta3=500;%比前面写的值少了一半
delta1=0.0025;
alfa1=0.5;alfa2=0.25;
%NPID parameters
delta0=2*h;
alfa01=3/4;alfa02=3/2; %0<alfa1<1<alfa2
beta01=10;beta02=0.3;
kp=beta01;kd=beta02;
%%%%%%%%%%%%%%%%%%%%%%%%%%
xk=zeros(2,1);
e1_1=0;
u_1=0;
v_1=0;
v1_1=0;v2_1=0;
z1_1=0;z2_1=0;z3_1=0;

for k=1:1:2000
    time(k)=k*h;
    p1=u_1;
    p2=k*h;%time
    tSpan=[0 h];
    [tt,xx]=ode('chap6_12plant',tSpan,xk,[],p1,p2);
    xk=xx(length(xx),:);
    y(k)=xk(1);
    dy(k)=xk(2);
    
    v(k)=sign(sin(k*h));% 输入参考信号
    dv(k)=0;
    
    f(k)=-25*dy(k)+33*sin(pi*p2);%unkonwn part
    