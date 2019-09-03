function [sys,x0,str,ts]=s_function(t,x,u,flag)
switch flag,
    case 0,
        [sys,x0,str,ts]=mdlInitializeSizes;
    case 3,
        sys=mdlOutputs(t,x,u);
    case {2,4,9}
        sys=[];
    otherwise
        error(['Unhandled flag = ',num2str(flag)]);
end

function [sys,x0,str,ts]=mdlInitializeSizes
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 1;
sizes.NumInputs      = 3;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
x0=[];
str = [];
ts = [0 0];

function sys=mdlOutputs(t,x,u)
xd=u(1);
dxd=0;
ddxd=0;
x1=u(2);%反馈x
x2=u(3);%反馈dx
e=x1-xd;
de=x2-dxd; 

Kp=100;Kd=50;
ut=-Kp*e-Kd*de;%控制律

sys(1)=ut;


